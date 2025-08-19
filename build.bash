#!/bin/bash

# Exit immediately if any command fails
set -e

echo "🔹 Adding/Updating ProGuard rules..."
cat > android/app/proguard-rules.pro <<'EOF'
# Keep Razorpay classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep annotation classes
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }
EOF
echo "✅ ProGuard rules added/updated."

echo "🔹 Ensuring build.gradle has correct release config..."
GRADLE_FILE="android/app/build.gradle"

if grep -q "proguard-rules.pro" "$GRADLE_FILE"; then
    echo "✅ build.gradle already configured for ProGuard."
else
    sed -i '/buildTypes {/,/}/ s/release {/&\
        minifyEnabled true\
        shrinkResources false\
        proguardFiles getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro"/' "$GRADLE_FILE"
    echo "✅ ProGuard config added to build.gradle."
fi

echo "🔹 Cleaning project..."
flutter clean

echo "🔹 Getting packages..."
flutter pub get

echo "🔹 Building release APK..."
flutter build apk --release

echo "🎉 Done! APK built successfully."
