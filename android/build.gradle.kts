val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()

rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Fix flutter_ringtone_player compileSdk requirement.
subprojects {
    afterEvaluate {
        if (name == "flutter_ringtone_player") {
            val androidExtension =
                extensions.findByType(
                    com.android.build.api.dsl.LibraryExtension::class.java
                )

            if (androidExtension != null) {
                androidExtension.compileSdk = 37
                println(
                    "FIX APPLIED: flutter_ringtone_player compileSdk = ${androidExtension.compileSdk}"
                )
            } else {
                println("ERROR: LibraryExtension not found for $name")
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}