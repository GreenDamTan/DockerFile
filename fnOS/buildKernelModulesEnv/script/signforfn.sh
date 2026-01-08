#!/usr/bin/env bash
# usage: ./signforfn.sh <dlkey> <url>

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dlkey> <url>" >&2
    exit 1
fi

DLKEY="$1"
URL="$2"

# 1. Base64 解码 并 XOR 0x5E
# 对应liveupdate中的get_dlurl
#  v8 = decode_base64(a3, v6, v16);
#  if ( v8 > 0 )
#  {
#    v9 = v16;
#    do
#      *v9++ ^= 0x5Eu;
#    while ( &v16[v8 - 1 + 1] != v9 );
#  }
PAD=$(( (4 - ${#DLKEY} % 4) % 4 ))
DLKEY_PADDED="${DLKEY}$(printf '=%.0s' $(seq 1 $PAD))"

KEY=$(
    echo -n "$DLKEY_PADDED" \
    | base64 -d 2>/dev/null \
    | perl -pe 's/(.)/chr(ord($1)^0x5e)/seg'
)

# 2. 提取 URL path
PATH_PART=$(printf '%s\n' "$URL" | sed -E 's#^[a-zA-Z]+://[^/]+##')

# 3. 当前时间戳
T=$(date +%s)

# 4. 计算 MD5(key + path + timestamp)
# 可见liveupdate中to_cdn_url
SIGN=$(printf '%s' "${KEY}${PATH_PART}${T}" | md5sum | awk '{print $1}')

# 5. 输出最终URL
echo "${URL}?sign=${SIGN}&t=${T}"