//
//  ManagedAppConfigSettings.m
//  AppConfigSettingsFramework
//
//  Created by Diego Negri on 09/09/2019.
//  Copyright © 2019 AppConfig. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ManagedAppConfigSettings.h"
#import "ManagedAppConfigKeys.h"

@implementation ManagedAppConfigSettings

static ManagedAppConfigSettings *instance;

+ (ManagedAppConfigSettings *)clientInstance
{
    @synchronized (instance)
    {
        if (instance == nil)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

- (void)start
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NSUserDefaultsDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
        NSDictionary* changes = [self checkAppConfigChanges];
        if([changes count] > 0)
        {
            if(self.delegate)
            {
                NSLog(@"notify others of changes: %@", changes);
                [self.delegate settingsDidChange:changes];
            }
        }
    }];

    [self checkAppConfigChanges];
}

- (void)end
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

- (NSDictionary*)appConfig
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:kMDM_CONFIGURATION_KEY];
}

- (NSDictionary*)checkAppConfigChanges
{
    NSMutableDictionary* result  = [[NSMutableDictionary alloc] init];

    // copy the keys into the result
    NSDictionary* newConfig = [self appConfig];
    if(newConfig)
    {
        result = [NSMutableDictionary dictionaryWithDictionary:newConfig];
    }
    
    // reove any values that were already in the set
    NSDictionary* persistedAppConfig = [self persistedAppConfig];
    if(persistedAppConfig)
    {
        [persistedAppConfig enumerateKeysAndObjectsUsingBlock:^(id key, id oldValue, BOOL* stop) {
            id newValue = [result objectForKey:key];
            if(newValue && [self isEqual:oldValue b:newValue])
            {
                [result removeObjectForKey:key];
            }
        }];
    }
    
    newConfig = [self appConfig];
    if(newConfig)
    {
        if([result count] > 0)
        {
            // only write out the changes if there were new values
            [self persistConfig:newConfig];
        }
    }
    else
    {
        [self persistConfig:nil];
    }

    return result;
}

- (NSDictionary*)persistedAppConfig
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey: kMDM_CACHED_CONFIGURATION_KEY];
    
}

- (BOOL) isEqual:(id)a b:(id)b
{
    if([a isKindOfClass:[NSString class]] && [b isKindOfClass:[NSString class]])
    {
        NSString* va = (NSString*)a;
        NSString* vb = (NSString*)b;
        return va == vb;
    }
    else if([a isKindOfClass:[NSNumber class]] && [b isKindOfClass:[NSNumber class]])
    {
        NSNumber* va = (NSNumber*)a;
        NSNumber* vb = (NSNumber*)b;
        return va == vb;
    }
//    else if let va = a as? Bool, let vb = b as? Bool
//    {
//        return va == vb
//    }
    else if([a isKindOfClass:[NSDate class]] && [b isKindOfClass:[NSDate class]])
    {
        NSDate* va = (NSDate*)a;
        NSDate* vb = (NSDate*)b;
        return (va == vb);
    }
    return false;
}

- (void)persistConfig:(NSDictionary*)toPersist
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if(toPersist)
    {
        [defaults setValue:toPersist forKey:kMDM_CACHED_CONFIGURATION_KEY];
    }
    else
    {
        if([defaults objectForKey:kMDM_CACHED_CONFIGURATION_KEY])
        {
            [defaults removeObjectForKey:kMDM_CACHED_CONFIGURATION_KEY];
        }
    }
    [defaults synchronize];
}

@end
