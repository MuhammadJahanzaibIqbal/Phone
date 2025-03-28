// Configure the plugin repositories and versions
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
        classpath("com.google.gms:google-services:4.4.0")
    }
}

// Declare plugins using the plugins DSL
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
}

// Keep your task graph hooks
gradle.taskGraph.beforeTask {
    task -> println("Executing ${task.name}...")
}

gradle.taskGraph.afterTask {
    task, state -> println("Finished ${task.name} with status ${state.failure?.message ?: 'Success'}")
}

// Define versions in one place for easier maintenance
val lifecycleVersion = "2.7.0"
val navVersion = "2.7.7"
val coroutinesVersion = "1.7.3"

android {
    namespace = "com.example.myapplication"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example.myapplication"
        minSdk = 28
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
        
        // Optional: Specify vector drawables compatibility
        vectorDrawables.useSupportLibrary = true
        // Optional: Set up multi-dex if needed
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            // Configure your signing information when ready for release
            // storeFile = file("keystore.jks")
            // storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
            // keyAlias = System.getenv("KEY_ALIAS") ?: ""
            // keyPassword = System.getenv("KEY_PASSWORD") ?: ""
        }
    }

    buildTypes {
        debug {
            isDebuggable = true
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }
        release {
            isMinifyEnabled = true // Enable code shrinking
            isShrinkResources = true // Enable resource shrinking
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            // Uncomment when ready to sign release builds
            // signingConfig = signingConfigs.getByName("release")
        }
    }

    buildFeatures {
        viewBinding = true
        // dataBinding = true  // Uncomment if needed
        // compose = true  // Uncomment if using Jetpack Compose
    }

    // Optional: Set up Compose compiler options if using Compose
    /*
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.1"
    }
    */

    // Support Java 17 for modern Android development
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // isCoreLibraryDesugaringEnabled = true // Uncomment if using Java 8+ features on older Android versions
    }

    kotlinOptions {
        jvmTarget = "17"
        // Optional: Enable explicit API mode
        // freeCompilerArgs += "-Xexplicit-api=strict"
    }

    // Optional: Configure test options
    testOptions {
        unitTests.isReturnDefaultValues = true
        // animationsDisabled = true
    }

    // Optional: Configure packaging options
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
            excludes += "META-INF/LICENSE.md"
            excludes += "META-INF/LICENSE-notice.md"
        }
    }
}

dependencies {
    // Core Android dependencies
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // Lifecycle components
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:$lifecycleVersion")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:$lifecycleVersion")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:$lifecycleVersion")

    // Navigation component
    implementation("androidx.navigation:navigation-fragment-ktx:$navVersion")
    implementation("androidx.navigation:navigation-ui-ktx:$navVersion")

    // Coroutines
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:$coroutinesVersion")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:$coroutinesVersion")

    // Optional: Uncomment if using Jetpack Compose
    /*
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.compose.ui:ui:1.6.1")
    implementation("androidx.compose.material3:material3:1.2.0")
    implementation("androidx.compose.ui:ui-tooling-preview:1.6.1")
    debugImplementation("androidx.compose.ui:ui-tooling:1.6.1")
    */

    // Optional: Uncomment if using Room database
    /*
    val roomVersion = "2.6.1"
    implementation("androidx.room:room-runtime:$roomVersion")
    implementation("androidx.room:room-ktx:$roomVersion")
    ksp("androidx.room:room-compiler:$roomVersion")
    */

    // Optional: For advanced networking
    /*
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
    */

    // Optional: For dependency injection
    /*
    implementation("io.insert-koin:koin-android:3.5.0")
    */

    // Optional: For Java 8+ features on older Android versions
    /*
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    */

    // Testing
    testImplementation("junit:junit:4.13.2")
    testImplementation("org.mockito:mockito-core:5.8.0")
    testImplementation("org.jetbrains.kotlinx:kotlinx-coroutines-test:$coroutinesVersion")
    testImplementation("androidx.arch.core:core-testing:2.2.0")

    // Android Testing
    androidTestImplementation("androidx.test.ext:junit:1.1.5")
    androidTestImplementation("androidx.test.espresso:espresso-core:3.5.1")
    androidTestImplementation("androidx.test:runner:1.5.2")
    androidTestImplementation("androidx.test:rules:1.5.0")

    // Optional: For UI testing with Compose
    /*
    androidTestImplementation("androidx.compose.ui:ui-test-junit4:1.6.1")
    debugImplementation("androidx.compose.ui:ui-test-manifest:1.6.1")
    */

    // Add this dependency
    implementation("androidx.multidex:multidex:2.0.1")
}