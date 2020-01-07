#!/bin/bash
 
set -e
echo $ANDROID_SDK_ROOT

android_sdk=$HOME/opt/android/sdk

AAPT="$android_sdk/build-tools/24.0.3/aapt"
DX="$android_sdk/build-tools/24.0.3/dx"
ZIPALIGN="$android_sdk/build-tools/24.0.3/zipalign"
APKSIGNER="$android_sdk/build-tools/24.0.3/apksigner"
PLATFORM="$android_sdk/platforms/android-24/android.jar"
 
echo "Cleaning..."
rm -rf obj/*
rm -rf src/in/ignas/helloandroid/R.java
rm -rf bin/*
 
echo "Generating R.java file..."
$AAPT package -f -m -J src -M AndroidManifest.xml -S res -I $PLATFORM
 
echo "Compiling..."
javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/in/ignas/helloandroid/MainActivity.java
javac -d obj -classpath src -bootclasspath $PLATFORM -source 1.7 -target 1.7 src/in/ignas/helloandroid/R.java
 
echo "Translating in Dalvik bytecode..."
$DX --dex --output=classes.dex obj
 
echo "Making APK..."
$AAPT package -f -m -F bin/hello.unaligned.apk -M AndroidManifest.xml -S res -I $PLATFORM
$AAPT add bin/hello.unaligned.apk classes.dex
 
echo "Aligning and signing APK..."
$ZIPALIGN -f 4 bin/hello.unaligned.apk bin/hello.apk
$APKSIGNER sign --ks mykey.keystore bin/hello.apk
