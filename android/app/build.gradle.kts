// Import Java utilities for keystore handling
import java.util.Properties
import java.io.FileInputStream

plugins {
    // Core Android app plugin
    id("com.android.application")

    // 🔥 Firebase plugin (Google Services)
    id("com.google.gms.google-services")

    // Kotlin Android plugin
    id("org.jetbrains.kotlin.android")

    // Flutter Gradle plugin (needed for Flutter integration)
    id("dev.flutter.flutter-gradle-plugin")
}

// 🧩 Load keystore properties (for release signing)
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.sit.secure_me"
    compileSdk = 36       // Flutter defaults to 34; you can keep flutter.compileSdkVersion

    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.sit.secure_me"
        minSdk = flutter.minSdkVersion       // Minimum required for Firebase
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true  // Recommended for Firebase
    }

    // ✅ Compatibility
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    // ✅ Signing configuration
    signingConfigs {
        create("release") {
            if (keystoreProperties.isNotEmpty()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    // ✅ Build Types
    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            isShrinkResources = false
        }

        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true            // Shrinks & optimizes release APK
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

// ✅ Required for Flutter integration
flutter {
    source = "../.."
}
