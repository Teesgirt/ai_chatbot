# Keep WorkManager and Room implementation classes
-keep class androidx.work.impl.** { *; }
-keep class * extends androidx.room.RoomDatabase
-keep class * extends androidx.work.ListenableWorker
-keep class * extends androidx.work.Worker

# Specifically keep generated Room implementation classes
-keep class * extends androidx.room.RoomDatabase {
    <init>(...);
}
-keep class **_Impl { *; }

# If using workmanager flutter plugin (common in Flutter)
-keep class be.tramckas.workmanager.** { *; }
