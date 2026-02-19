# School Map & Search Features Setup

I have implemented the requested features:
1. **Map of UK Schools**: A screen showing schools on a map.
2. **Search/Filter Screen**: A screen to filter schools by Type, Address, Course, and Fee.

## ⚠️ Important Next Steps

To make the Map feature work, you need to add the `google_maps_flutter` package and configure your API keys.

### 1. Add Dependency
Open your terminal in the `school` directory and run:
```bash
flutter pub add google_maps_flutter
```

### 2. Android Configuration
1. Open `android/app/src/main/AndroidManifest.xml`.
2. Add the following inside the `<application>` tag:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

### 3. iOS Configuration
1. Open `ios/Runner/AppDelegate.swift`.
2. Import GoogleMaps and provide your API Key:
```swift
import GoogleMaps

...

GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

After adding the key, run the app again:
```bash
flutter run
```
