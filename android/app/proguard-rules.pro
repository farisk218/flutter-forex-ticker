# Flutter-specific ProGuard rules to avoid obfuscating essential classes and methods
-keep class io.flutter.** { *; }
-keep class * extends io.flutter.embedding.engine.plugins.FlutterPlugin
-keep class * extends io.flutter.plugin.common.MethodChannel$MethodCallHandler

# If you are using JSON serialization (like fromJson or toJson methods), add this:
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep certain model classes and avoid obfuscation if needed:
-keep class com.yourpackage.** { *; }
