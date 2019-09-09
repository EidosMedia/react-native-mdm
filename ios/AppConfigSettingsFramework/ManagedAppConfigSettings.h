//
//  ManagedAppConfigSettings.h
//  AppConfigSettingsFramework
//
//  Created by Diego Negri on 09/09/2019.
//  Copyright © 2019 AppConfig. All rights reserved.
//

#ifndef ManagedAppConfigSettings_h
#define ManagedAppConfigSettings_h

@protocol ManagedAppConfigSettingsDelegate <NSObject>
- (void)settingsDidChange:(NSDictionary*)changes;
@end

@interface ManagedAppConfigSettings : NSObject
{
}
@property (nonatomic, weak) id<ManagedAppConfigSettingsDelegate> delegate;

+ (ManagedAppConfigSettings *)clientInstance;
- (void)start;
- (void)end;
- (NSDictionary*)appConfig;

@end

#endif /* ManagedAppConfigSettings_h */
