#!/usr/bin/env bash
set -euo pipefail

############################################
# 固定配置
############################################
NEW_ROOT_PASSWORD="root"
WORKDIR="$(pwd)/iso-repack-work"
LOG_PREFIX="[ISO-REPACK]"

TRIMFS_PATH="/trimfs.tgz"
TRIMFS_CONF_PATH="/config/trimfs.conf"

CPU_THREADS="$(nproc)"

############################################
# 工具函数
############################################
log() {
    echo "${LOG_PREFIX} $(date '+%F %T') | $*"
}

die() {
    echo "${LOG_PREFIX} ERROR: $*" >&2
    exit 1
}

############################################
# 参数
############################################
[ $# -eq 1 ] || die "用法: $0 <ISO路径或URL>"
INPUT="$1"

############################################
# 工作目录
############################################
mkdir -p "$WORKDIR"
WORKDIR_ABS="$(cd "$WORKDIR" && pwd)"
cd "$WORKDIR_ABS"

############################################
# 获取 ISO
############################################
ISO_NAME="$(basename "$INPUT")"
ISO_PATH="$WORKDIR_ABS/$ISO_NAME"

if [[ "$INPUT" =~ ^https?:// ]]; then
    if [ -f "$ISO_PATH" ]; then
        log "ISO 已存在，跳过下载: $ISO_PATH"
    else
        log "下载 ISO: $INPUT"
        wget -O "$ISO_PATH" "$INPUT"
    fi
else
    [ -f "$INPUT" ] || die "本地 ISO 不存在: $INPUT"
    log "复制本地 ISO"
    cp -f "$INPUT" "$ISO_PATH"
fi

############################################
# 提取 trimfs.tgz
############################################
log "提取 $TRIMFS_PATH"
TRIMFS_ABS="$WORKDIR_ABS/trimfs.tgz"
xorriso -indev "$ISO_PATH" -osirrox on -extract "$TRIMFS_PATH" "$TRIMFS_ABS"

############################################
# 解压 trimfs.tgz（多线程）
############################################
log "解压 trimfs.tgz (threads=$CPU_THREADS)"
rm -rf rootfs
mkdir rootfs
tar --use-compress-program="pigz -d -p $CPU_THREADS" \
    -xf "$TRIMFS_ABS" -C rootfs

############################################
# chroot 修改 rootfs（不挂载任何 pseudo-fs）
############################################
log "chroot 修改 rootfs"

# 修改 root 密码（严格 chroot）
chroot rootfs bash -c "echo 'root:$NEW_ROOT_PASSWORD' | chpasswd"
log "root 密码已修改"

# SSH 配置
SSHD_CONF="rootfs/etc/ssh/sshd_config"
[ -f "$SSHD_CONF" ] || die "sshd_config 不存在"

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONF"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONF"
log "已允许 root SSH 登录"

# 启用 ssh 服务
if [ -d rootfs/etc/systemd/system ]; then
    chroot rootfs systemctl enable ssh || true
    log "ssh.service 已启用"
else
    die "systemd 目录不存在，无法 enable ssh"
fi

############################################
# 重新打包 trimfs.tgz（多线程）
############################################
log "重新打包 trimfs.tgz (threads=$CPU_THREADS)"
mv "$TRIMFS_ABS" "$TRIMFS_ABS.bak"

tar --use-compress-program="pigz -p $CPU_THREADS" \
    -cf "$TRIMFS_ABS" -C rootfs .

############################################
# 从 gzip -l 获取严格尺寸
############################################
log "读取 gzip -l 信息"

read TRIMFS_TGZ_SIZE TRIMFS_SIZE <<< "$(
    gzip -l "$TRIMFS_ABS" | awk 'NR==2 {print $1, $2}'
)"

# 强制校验（防止再出现 %）
[[ "$TRIMFS_TGZ_SIZE" =~ ^[0-9]+$ ]] || die "trimfs_tgz_size 非数字"
[[ "$TRIMFS_SIZE" =~ ^[0-9]+$ ]]     || die "trimfs_size 非数字"

log "trimfs_tgz_size = $TRIMFS_TGZ_SIZE"
log "trimfs_size     = $TRIMFS_SIZE"

############################################
# 修改 trimfs.conf
############################################
log "修改 $TRIMFS_CONF_PATH"
TRIMFS_CONF_ABS="$WORKDIR_ABS/trimfs.conf"

xorriso -indev "$ISO_PATH" -osirrox on \
        -extract "$TRIMFS_CONF_PATH" "$TRIMFS_CONF_ABS"

sed -i "s/^trimfs_size=.*/trimfs_size=$TRIMFS_SIZE/" "$TRIMFS_CONF_ABS"
sed -i "s/^trimfs_tgz_size=.*/trimfs_tgz_size=$TRIMFS_TGZ_SIZE/" "$TRIMFS_CONF_ABS"

############################################
# 原位替换 ISO 文件
############################################
MOD_ISO="$WORKDIR_ABS/${ISO_NAME%.iso}-modify.iso"

log "生成新 ISO: $MOD_ISO"
xorriso \
  -indev "$ISO_PATH" \
  -outdev "$MOD_ISO" \
  -map "$TRIMFS_ABS"      "$TRIMFS_PATH" \
  -map "$TRIMFS_CONF_ABS" "$TRIMFS_CONF_PATH" \
  -boot_image any keep \
  -overwrite on

############################################
# 校验
############################################
log "校验新 ISO 内容"
xorriso -indev "$MOD_ISO" -ls "$TRIMFS_PATH"
xorriso -indev "$MOD_ISO" -ls "$TRIMFS_CONF_PATH"

log "完成"
log "原 ISO: $ISO_PATH"
log "新 ISO: $MOD_ISO"
