import java.util.Properties
plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    val flutterProperties = Properties()
    val flutterPropertiesFile = rootProject.file("../flutter.properties")
    if (flutterPropertiesFile.exists()) {
        flutterPropertiesFile.inputStream().use { flutterProperties.load(it) }
    }

    namespace = "com.example.phonebooth"
    compileSdk = flutterProperties["flutter.compileSdkVersion"]?.toString()?.toInt() ?: 34
    ndkVersion = flutterProperties["flutter.ndkVersion"]?.toString() ?: "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    android {
        // Other configuration might be here...

        defaultConfig {
            applicationId = "com.example.phonebooth"
            // Change this line from flutter.minSdkVersion (which is 21) to 23
            minSdk = 23
            targetSdk = flutter.targetSdkVersion
            versionCode = flutter.versionCode
            versionName = flutter.versionName
        }

        // More configuration might follow...
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
