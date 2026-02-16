allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// Eliminamos evaluationDependsOn(":app") para evitar dependencias circulares

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    // 1. Forzar la versión de core-ktx para solucionar el error lStar
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "androidx.core" && requested.name == "core-ktx") {
                useVersion("1.12.0")
            }
        }
    }
    
    // 2. Forzar el SDK 35 con la jerarquía correcta de Kotlin DSL
    afterEvaluate {
        val android = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
        android?.apply {
            compileSdkVersion(35) 
            defaultConfig {
                targetSdkVersion(35)
            }
        }
    }
}