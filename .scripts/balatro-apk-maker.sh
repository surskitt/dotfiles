#!/usr/bin/env bash

set -euo pipefail

checkcmd() {
    cmd="${1}"

    if ! type "${cmd}" >/dev/null 2>&1 ; then
        echo "Error: ${cmd} command not found" >&2
        return 1
    fi
}

checkfile() {
    file="${1}"

    if [[ ! -f "${file}" ]] ; then
        echo "Error: ${file} not found in current dir" >&2
        return 1
    fi
}

find_and_replace() {
    fn="${1}"
    input="${2}"
    repl="${3}"

    match_line_number="$(grep -n "${input}" "${fn}" | cut -d : -f 1)"

    sed -i "${match_line_number}d" "${fn}"
    tac <<< "${repl}" | while read ; do
        sed -i "${match_line_number} i \ ${REPLY}" "${fn}"
    done
}

for c in java 7za uber-apk-signer apktool sed ; do
    checkcmd "${c}"
done || {
    exit 1
}

for f in Balatro-APK-Patch.zip Balatro.exe love-11.5-android-embed.apk ; do
    checkfile "${f}"
done || {
    exit 1
}

TEMPDIR="$(mktemp -d -p "${PWD}")"
# trap 'rm -rf -- "${TEMPDIR}"' EXIT

echo "=== Extracting Balatro.exe"

BALATRO_EXE_DIR="${TEMPDIR}/Balatro"
mkdir -p "${BALATRO_EXE_DIR}"
7za x Balatro.exe -o"${BALATRO_EXE_DIR}"

echo
echo "=== Extracting love android apk"
echo

BALATRO_APK_DIR="${TEMPDIR}/balatro_apk"
apktool d -s -o "${BALATRO_APK_DIR}" love-11.5-android-embed.apk

echo
echo "=== Extracting balatro apk patch"

APK_PATCH_DIR="${TEMPDIR}/apk_patch"
7za x Balatro-APK-Patch.zip -o"${APK_PATCH_DIR}"

echo
echo "=== Copying balatro apk patch to balatro apk dir"

cp -r "${APK_PATCH_DIR}"/* "${BALATRO_APK_DIR}"/

echo "=== Applying patches to balatro lua files"

echo "=== Deleting loadstring line"
echo "=== Adding android global settings"
# all text blocks should lead with one less space than needed since the replace command prepends one
android_globals="$(
cat << EOF
   if love.system.getOS() == 'Android' then
       self.F_DISCORD = true
       self.F_NO_ACHIEVEMENTS = true
       self.F_SOUND_THREAD = true
       self.F_VIDEO_SETTINGS = false
       self.F_ENGLISH_ONLY = false
       self.F_QUIT_BUTTON = false
   end
 
EOF
)"
find_and_replace "${BALATRO_EXE_DIR}/globals.lua" "loadstring" "${android_globals}"

echo "=== patching fps"
find_and_replace "${BALATRO_EXE_DIR}/main.lua" "G.FPS_CAP = G.FPS_CAP or" "       G.FPS_CAP = 30"

echo "=== patching orientation"
android_orientation="$(
cat << EOF
   local os = love.system.getOS()
   love.window.setMode(2, 1)
EOF
)"
find_and_replace "${BALATRO_EXE_DIR}/main.lua" "local os = love.system.getOS()" "${android_orientation}"

# echo "=== patching crt effect"
# find_and_replace "${BALATRO_EXE_DIR}/globals.lua" "crt = " "           crt = 0,"
# find_and_replace "${BALATRO_EXE_DIR}/game.lua" "G.SHADERS['CRT'])" ""

# android_save="$(
# cat << EOF
#    t.window.width = 0
#    t.externalstorage = true
# EOF
# )"
# find_and_replace "${BALATRO_EXE_DIR}/conf.lua" "t.window.width = 0" "${android_save}"

echo "=== zipping balatro exe contents"
(
    cd "${BALATRO_EXE_DIR}"
    7za a balatro.zip
)
mv "${BALATRO_EXE_DIR}/balatro.zip" "${BALATRO_APK_DIR}/assets/game.love"

echo "=== creating apk"
apktool b -o "${TEMPDIR}/balatro.apk" "${BALATRO_APK_DIR}"

echo "=== signing apk"
uber-apk-signer -a "${TEMPDIR}/balatro.apk"

echo "=== renaming apk"
mv "${TEMPDIR}/balatro-aligned-debugSigned.apk" balatro.apk
