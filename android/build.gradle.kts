// Top-level build.gradle.kts file

plugins {
    // ✅ DO NOT specify versions here — Flutter manages Gradle plugin versions internally
    id("com.android.application") apply false
    id("org.jetbrains.kotlin.android") apply false
    id("com.google.gms.google-services") apply false
    id("dev.flutter.flutter-gradle-plugin") apply false
}

// ✅ Repositories for all submodules (required for Firebase + Flutter)
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Custom Flutter build directory mapping
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// ✅ Ensure each subproject uses the same build directory
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// ✅ Ensure the app module is evaluated before others
subprojects {
    project.evaluationDependsOn(":app")
}

// 🧹 Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
