# ![][AppIcon]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Runtime Warnings During Simulator Use

The following runtime warnings occur at app startup:

```
OnTheMap[20375:9647192] Falling back to loading access token from NSUserDefaults because of simulator bug
OnTheMap[20375:9647192] Falling back to storing access token in NSUserDefaults because of simulator bug
OnTheMap[20375:9647192] Falling back to loading access token from NSUserDefaults because of simulator bug
OnTheMap[20375:9647192] Falling back to storing access token in NSUserDefaults because of simulator bug
OnTheMap[20375:9647192] Falling back to loading access token from NSUserDefaults because of simulator bug
OnTheMap[20375:9647192] Falling back to storing access token in NSUserDefaults because of simulator bug
```

The following runtime warnings occur after tapping the **Find On The Map** button in the **Travelogue View**:

```
ERROR /BuildRoot/Library/Caches/com.apple.xbs/Sources/VectorKit_Sim/VectorKit-1230.32.8.29.9/GeoGL/GeoGL/GLCoreContext.cpp 1763: InfoLog SolidRibbonShader:
ERROR /BuildRoot/Library/Caches/com.apple.xbs/Sources/VectorKit_Sim/VectorKit-1230.32.8.29.9/GeoGL/GeoGL/GLCoreContext.cpp 1764: WARNING: Output of vertex shader 'v_gradient' not read by fragment shader
```

The following runtime warnings occur during the Facebook Login process:

1) After tapping the **Continue With Facebook** button in the **Login View**

```
OnTheMap[20494:9664743] -canOpenURL: failed for URL: "fbauth2:/" - error: "The operation couldn’t be completed. (OSStatus error -10814.)"
OnTheMap[20494:9664743] Falling back to storing access token in NSUserDefaults because of simulator bug
OnTheMap[20494:9664743] -canOpenURL: failed for URL: "fbauth2:/" - error: "The operation couldn’t be completed. (OSStatus error -10814.)"
objc[20494]: Class PLBuildVersion is implemented in both /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/PrivateFrameworks/AssetsLibraryServices.framework/AssetsLibraryServices (0x119f8e998) and /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/PrivateFrameworks/PhotoLibraryServices.framework/PhotoLibraryServices (0x119db0880). One of the two will be used. Which one is undefined.
```

2) After tapping the **OK** button in the Facebook Confirmation view

```
OnTheMap[20494:9664743] Falling back to loading access token from NSUserDefaults because of simulator bug
OnTheMap[20494:9664743] Falling back to storing access token in NSUserDefaults because of simulator bug
OnTheMap[20494:9664743] Falling back to storing access token in NSUserDefaults because of simulator bug
```

---
**Copyright © 2016-2017 Gregory White. All rights reserved.**



[AppIcon]:  ../images/OnTheMap_80.png
