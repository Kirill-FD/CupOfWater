# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Kotlin
-dontwarn kotlin.**
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-keepclassmembers class **$WhenMappings { <fields>; }
-keepclassmembers class kotlin.Metadata { *; }

# OkHttp / network (used by supabase, postgrest)
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-keepnames class okhttp3.internal.publicapi.PublicApi

# Glance / home widget
-keep class androidx.glance.** { *; }
-keep class androidx.work.** { *; }

# Gson (if used transitively)
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }

# App (Glance widget receiver, Application)
-keep class com.mycompany.water_tracker.** { *; }

# Flutter embedding ссылается на Play Feature Delivery; классы не в classpath.
# Без этого R8 падает при minifyReleaseWithR8.
-dontwarn com.google.android.play.core.**
