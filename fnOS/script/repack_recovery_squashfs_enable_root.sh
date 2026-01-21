#!/usr/bin/env bash
set -euo pipefail

############################################
# 固定配置
############################################
NEW_ROOT_PASSWORD="root"
WORKDIR="$(pwd)/squashfs-repack-work"
LOG_PREFIX="[SQUASHFS-REPACK]"

TRIMFS_REL="trimfs.tgz"
CONF_REL="config/trimfs.conf"

CPU_THREADS="$(nproc)"

############################################
# 工具函数
############################################
log() { echo "${LOG_PREFIX} $(date '+%F %T') | $*"; }
die() { echo "${LOG_PREFIX} ERROR: $*" >&2; exit 1; }

############################################
# 参数
############################################
[ $# -eq 1 ] || die "用法: $0 <squashfs 文件 | URL | block device>"
INPUT="$1"

############################################
# 工作目录
############################################
mkdir -p "$WORKDIR"
WORKDIR_ABS="$(cd "$WORKDIR" && pwd)"
cd "$WORKDIR_ABS"

############################################
# 判断输入类型
############################################
SQFS_SOURCE=""
SQFS_BASENAME=""

if [[ "$INPUT" =~ ^https?:// ]]; then
    SQFS_BASENAME="$(basename "$INPUT")"
    SQFS_SOURCE="$WORKDIR_ABS/$SQFS_BASENAME"

    if [ -f "$SQFS_SOURCE" ]; then
        log "squashfs 已存在，跳过下载: $SQFS_SOURCE"
    else
        log "下载 squashfs: $INPUT"
        wget -O "$SQFS_SOURCE" "$INPUT"
    fi

elif [ -b "$INPUT" ]; then
    log "使用块设备作为 squashfs: $INPUT"
    SQFS_SOURCE="$INPUT"
    SQFS_BASENAME="$(basename "$INPUT")"

elif [ -f "$INPUT" ]; then
    log "使用本地 squashfs 文件: $INPUT"
    SQFS_SOURCE="$(realpath "$INPUT")"
    SQFS_BASENAME="$(basename "$INPUT")"

else
    die "不支持的输入类型: $INPUT"
fi

############################################
# 解包 squashfs（只读源）
############################################
log "unsquashfs 解包"
rm -rf root
unsquashfs -d root "$SQFS_SOURCE"

############################################
# 处理 trimfs.tgz
############################################
TRIMFS_ABS="root/$TRIMFS_REL"
[ -f "$TRIMFS_ABS" ] || die "trimfs.tgz 不存在"

log "解压 trimfs.tgz (threads=$CPU_THREADS)"
rm -rf rootfs
mkdir rootfs

tar --use-compress-program="pigz -d -p $CPU_THREADS" \
    -xf "$TRIMFS_ABS" -C rootfs

############################################
# chroot 修改 rootfs（无 pseudo-fs）
############################################
log "chroot 修改 rootfs"

chroot rootfs bash -c "echo 'root:$NEW_ROOT_PASSWORD' | chpasswd"
log "root 密码已修改"

SSHD_CONF="rootfs/etc/ssh/sshd_config"
[ -f "$SSHD_CONF" ] || die "sshd_config 不存在"

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONF"
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONF"

chroot rootfs systemctl enable ssh || true
log "SSH 已启用，允许 root 登录"

############################################
# 重新打包 trimfs.tgz（多线程）
############################################
log "重新打包 trimfs.tgz (threads=$CPU_THREADS)"
mv "$TRIMFS_ABS" "$TRIMFS_ABS.bak"

tar --use-compress-program="pigz -p $CPU_THREADS" \
    -cf "$TRIMFS_ABS" -C rootfs .

rm "$TRIMFS_ABS.bak"
############################################
# 从 gzip -l 获取严格尺寸
############################################
read TRIMFS_TGZ_SIZE TRIMFS_SIZE <<< "$(
    gzip -l "$TRIMFS_ABS" | awk 'NR==2 {print $1, $2}'
)"

[[ "$TRIMFS_TGZ_SIZE" =~ ^[0-9]+$ ]] || die "trimfs_tgz_size 非数字"
[[ "$TRIMFS_SIZE" =~ ^[0-9]+$ ]]     || die "trimfs_size 非数字"

log "trimfs_tgz_size=$TRIMFS_TGZ_SIZE"
log "trimfs_size=$TRIMFS_SIZE"

############################################
# 修改 trimfs.conf
############################################
CONF_ABS="root/$CONF_REL"
[ -f "$CONF_ABS" ] || die "trimfs.conf 不存在"

sed -i "s/^trimfs_size=.*/trimfs_size=$TRIMFS_SIZE/" "$CONF_ABS"
sed -i "s/^trimfs_tgz_size=.*/trimfs_tgz_size=$TRIMFS_TGZ_SIZE/" "$CONF_ABS"

log "trimfs.conf 已更新"

############################################
# 重新生成 squashfs
############################################
OUT_SQFS="$WORKDIR_ABS/${SQFS_BASENAME}-modify.squashfs"

log "重新生成 squashfs: $OUT_SQFS"
mksquashfs root "$OUT_SQFS" \
    -comp gzip \
    -processors "$CPU_THREADS" \
    -noappend \
    -no-xattrs

log "完成"
log "输出 squashfs: $OUT_SQFS"
