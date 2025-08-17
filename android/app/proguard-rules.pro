# Keep Razorpay classes
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Keep annotation classes
-keep class proguard.annotation.Keep
-keep class proguard.annotation.KeepClassMembers

# Keep Kotlin metadata
-keep class kotlin.Metadata { *; }
