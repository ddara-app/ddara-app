import java.util.Properties

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localProperties.load(localPropertiesFile.inputStream())
}

android {
    namespace = "com.swyp.ddara"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // flutter_local_notifications(22.x)가 요구하는 코어 라이브러리 디슈가링.
        // (예약 알림 등 최신 java.time API 를 구버전 Android 에서 쓰기 위함)
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // 스토어 식별자(Application ID). iOS 번들 ID 와 통일 (com.ddara.team3).
        // namespace(코드 패키지)는 com.swyp.ddara 로 유지 — applicationId 와 독립이라 무방.
        applicationId = "com.ddara.team3"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // firebase_auth 6.x 는 minSdk 23 이상을 요구한다. (Flutter 기본값이 더 높으면 그 값을 유지)
        minSdk = maxOf(flutter.minSdkVersion, 23)
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders["KAKAO_NATIVE_APP_KEY"] =
            localProperties["KAKAO_NATIVE_APP_KEY"]?.toString() ?: ""
    }

    signingConfigs {
        // 업로드 키스토어 서명 값은 local.properties 에서 읽는다(gitignore 대상, 커밋 금지).
        // 필요한 키: RELEASE_STORE_FILE / RELEASE_STORE_PASSWORD / RELEASE_KEY_ALIAS / RELEASE_KEY_PASSWORD
        // CI 에서는 키스토어(.jks) 복원 후 이 4개 값을 local.properties 에 주입(KAKAO 키와 동일 패턴).
        create("release") {
            val storeFilePath = localProperties["RELEASE_STORE_FILE"]?.toString()
            if (storeFilePath != null) {
                // file(...) 는 app 모듈 기준 상대경로. 예) android/app/upload-keystore.jks → "upload-keystore.jks"
                storeFile = file(storeFilePath)
                storePassword = localProperties["RELEASE_STORE_PASSWORD"]?.toString()
                keyAlias = localProperties["RELEASE_KEY_ALIAS"]?.toString()
                keyPassword = localProperties["RELEASE_KEY_PASSWORD"]?.toString()
            }
        }
    }

    buildTypes {
        release {
            // 키스토어 값이 있으면 업로드 키로 서명, 없으면(로컬 개발/무서명 빌드) debug 로 폴백.
            signingConfig = if (localProperties["RELEASE_STORE_FILE"] != null) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            // R8 코드 축소/난독화 + 리소스 축소. keep 규칙은 proguard-rules.pro 참고.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 코어 라이브러리 디슈가링 런타임. (isCoreLibraryDesugaringEnabled 와 짝)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
