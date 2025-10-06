// Top-level build.gradle.kts file

plugins {
    // Android & Kotlin Gradle plugins (match Flutter SDK versions)
    id("com.android.application") version "8.6.1" apply false
    id("org.jetbrains.kotlin.android") version "1.9.25" apply false

    // 🔥 Firebase Google Services plugin
    id("com.google.gms.google-services") version "4.4.2" apply false

    // Flutter Gradle plugin
    id("dev.flutter.flutter-gradle-plugin") version "1.0.0" apply false
}

// Repositories for all modules
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ⚙️ Custom Flutter build directory mapping
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Ensure app module is evaluated first
subprojects {
    project.evaluationDependsOn(":app")
}

// 🧹 Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
