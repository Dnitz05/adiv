import java.io.File
import java.util.Base64
import org.gradle.api.GradleException
import java.util.Properties

fun Properties.overrideFromEnv(propertyKey: String, envKey: String) {
    System.getenv(envKey)?.takeIf { it.isNotBlank() }?.let { value ->
        setProperty(propertyKey, value)
    }
}

fun Properties.valueOrNull(propertyKey: String): String? {
    val direct = getProperty(propertyKey)
    if (!direct.isNullOrBlank()) {
        return direct
    }
    val raw = get(propertyKey) as? String
    return raw?.takeIf { it.isNotBlank() }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties().apply {
    val keystorePropertiesFile = rootProject.file("key.properties")
    if (keystorePropertiesFile.exists()) {
        keystorePropertiesFile.inputStream().use { load(it) }
    }
}

keystoreProperties.overrideFromEnv("storePassword", "ANDROID_KEYSTORE_PASSWORD")
keystoreProperties.overrideFromEnv("keyPassword", "ANDROID_KEY_PASSWORD")
keystoreProperties.overrideFromEnv("keyAlias", "ANDROID_KEY_ALIAS")

System.getenv("ANDROID_KEYSTORE_PATH")?.trim()?.takeIf { it.isNotEmpty() }?.let { path ->
    keystoreProperties.setProperty("storeFile", path)
}

System.getenv("ANDROID_KEYSTORE_BASE64")?.trim()?.takeIf { it.isNotEmpty() }?.let { encoded ->
    val keystoreOutputDir = File(buildDir, "keystore")
    if (!keystoreOutputDir.exists()) {
        keystoreOutputDir.mkdirs()
    }

    val generatedKeystore = File(keystoreOutputDir, "upload-keystore.jks")
    val decodedKeystore = try {
        Base64.getDecoder().decode(encoded)
    } catch (error: IllegalArgumentException) {
        throw GradleException("ANDROID_KEYSTORE_BASE64 is not valid Base64 data.", error)
    }

    if (!generatedKeystore.exists() || !generatedKeystore.readBytes().contentEquals(decodedKeystore)) {
        generatedKeystore.writeBytes(decodedKeystore)
    }

    keystoreProperties.setProperty("storeFile", generatedKeystore.absolutePath)
}

android {
    namespace = "com.smartdivination.tarot"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.smartdivination.tarot"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            val storeFilePath = keystoreProperties.valueOrNull("storeFile")
            val storePasswordValue = keystoreProperties.valueOrNull("storePassword")
            val keyAliasValue = keystoreProperties.valueOrNull("keyAlias")
            val keyPasswordValue = keystoreProperties.valueOrNull("keyPassword")

            if (storeFilePath != null && storePasswordValue != null && keyAliasValue != null && keyPasswordValue != null) {
                val candidateStoreFile = File(storeFilePath)
                val resolvedStoreFile = if (candidateStoreFile.isAbsolute) {
                    candidateStoreFile
                } else {
                    rootProject.file(storeFilePath)
                }

                if (!resolvedStoreFile.exists()) {
                    throw GradleException(
                        "Release keystore not found at ${resolvedStoreFile.path}. Provide key.properties or set ANDROID_KEYSTORE_PATH / ANDROID_KEYSTORE_BASE64."
                    )
                }

                storeFile = resolvedStoreFile
                storePassword = storePasswordValue
                keyAlias = keyAliasValue
                keyPassword = keyPasswordValue
            } else {
                throw GradleException(
                    "Missing release keystore configuration. Provide key.properties or set ANDROID_KEYSTORE_* environment variables."
                )
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
