plugins {
    id("com.android.application")
    kotlin("android")
    // Apply the Google services Gradle plugin
    id("com.google.gms.google-services")
}

android {
    compileSdk = 34

    defaultConfig {
        applicationId = "com.example."
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    // other android config …
}

dependencies {
    implementation("androidx.core:core-ktx:1.10.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.9.0")

    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

    // Firebase Analytics (no version needed when using BoM)
    implementation("com.google.firebase:firebase-analytics")

    // TODO: Add other Firebase product dependencies here, e.g.
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
}
