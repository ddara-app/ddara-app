# ============================================================
# 릴리스(R8) keep / dontwarn 규칙
# isMinifyEnabled=true 시 리플렉션 기반 라이브러리 보호 + 빌드 차단 경고 억제.
# 원칙: 먼저 이 규칙으로 빌드·실기기 스모크 테스트 → 크래시 지점만 keep 추가(과다 keep 금지).
# ============================================================

# --- 공통 attribute 보존 (GSON/직렬화·크래시 역난독화) ---
-keepattributes Signature, *Annotation*, InnerClasses, EnclosingMethod
-keepattributes SourceFile, LineNumberTable

# --- Flutter Play Core (deferred components 미사용) ---
# Flutter 임베딩이 참조하는 Play Core 클래스가 앱에 없어 R8 가 "Missing classes" 로
# 빌드를 실패시키는 것을 방지. (동적 기능 미사용이라 dontwarn 으로 충분)
-dontwarn com.google.android.play.core.**

# --- Kakao SDK (kakao_flutter_sdk_user / _share) ---
# 로그인/공유 응답 모델을 리플렉션·직렬화로 다루므로 모델 보존.
-keep class com.kakao.sdk.**.model.** { *; }
-keep class com.kakao.sdk.** { *; }
-dontwarn com.kakao.sdk.**

# --- GSON + flutter_local_notifications ---
# 알림 상세를 GSON 으로 (역)직렬화 → 모델/제네릭 토큰 보존 필요.
-keep class com.google.gson.** { *; }
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# --- Firebase / Crashlytics ---
# 대부분 consumer rules 로 자동 적용되나, 역난독화 안정화를 위해 경고 억제.
-dontwarn com.google.firebase.**

# --- image_cropper (uCrop) ---
-dontwarn com.yalantis.ucrop.**
-keep class com.yalantis.ucrop.** { *; }

# --- 네이티브 메서드 / 열거형 (일반 보존) ---
-keepclasseswithmembernames class * {
    native <methods>;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
