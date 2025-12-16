#!/bin/bash

echo "DYALOG_RELEASE IS: $DYALOG_RELEASE"
echo "BUILDTYPE IS: $BUILDTYPE"

if [ "$BUILDTYPE" = "minimal" ]; then
  cd /opt/mdyalog/$DYALOG_RELEASE/64/unicode/

  rm -Rf aplfmt \
    aplkeys/file_siso \
    aplkeys/xterm \
    aplkeys.sh \
    apltrans/xterm \
    BuildID \
    dyalog.BuildID \
    dyalog.config.example \
    dyalog.desktop \
    dyalog.svg \
    dyalogc \
    fonts \
    help \
    libcef.so \
    libEGL.so \
    libGLESv2.so \
    libvulkan.so \
    libvk_swiftshader.so \
    lib/ademo64.so \
    lib/testcallback.so \
    make_scripts \
    mapl \
    outprods \
    resource.pak \
    samples \
    DWASamples \
    Samples \
    TestCertificates \
    vk_swiftshader_icd.json \
    v8_context_snapshot.bin \
    ws/apl2in.dws \
    ws/apl2pcin.dws \
    ws/ddb.dws \
    ws/display.dws \
    ws/eval.dws \
    ws/fonts.dws \
    ws/ftp.dws \
    ws/groups.dws \
    ws/max.dws \
    ws/min.dws \
    ws/ops.dws \
    ws/quadna.dws \
    ws/smdemo.dws \
    ws/smdesign.dws \
    ws/smtutor.dws \
    ws/tube.dws \
    ws/tutor.dws \
    ws/xfrcode.dws \
    ws/xlate.dws \
    xflib \
    xfsrc \
    cef.pak \
    cef_100_percent.pak \
    cef_200_percent.pak \
    chrome_100_percent.pak \
    chrome_200_percent.pak \
    cef_extensions.pak \
    chrome-sandbox \
    devtools_resources.pak \
    icudtl.dat \
    locales \
    snapshot_blob.bin \
    natives_blob.bin \
    lib/libcef.so \
    lib/libAplWrapper.so \
    lib/libHttpInterceptor.so \
    RIDEapp/node_modules/cross-spawn \

fi
