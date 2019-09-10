#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#else
#import "React/RCTBridgeModule.h"
#endif

#import <UIKit/UIKit.h>

#if __has_include("ManagedAppConfigSettings.h")
#import "ManagedAppConfigSettings.h"
#else
@import AppConfigSettingsFramework;
#endif

@interface MobileDeviceManager : NSObject <RCTBridgeModule, ManagedAppConfigSettingsDelegate>
@end
