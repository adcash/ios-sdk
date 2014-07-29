//
//  ACIdentityProvider.m
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import "ACIdentityProvider.h"
#import "ACGlobal.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
#import <AdSupport/AdSupport.h>
#endif

#define ADCASH_IDENTIFIER_DEFAULTS_KEY @"com.adcash.identifier"

@interface ACIdentityProvider ()

+ (BOOL)deviceHasASIdentifierManager;

+ (NSString *)identifierFromASIdentifierManager:(BOOL)obfuscate;
+ (NSString *)adcashIdentifier:(BOOL)obfuscate;

@end

@implementation ACIdentityProvider

+ (BOOL)deviceHasASIdentifierManager
{
    return !!NSClassFromString(@"ASIdentifierManager");
}

+ (NSString *)identifier
{
    return [self _identifier:NO];
}

+ (NSString *)obfuscatedIdentifier
{
    return [self _identifier:YES];
}

+ (NSString *)_identifier:(BOOL)obfuscate
{
    if ([self deviceHasASIdentifierManager]) {
        return [self identifierFromASIdentifierManager:obfuscate];
    } else {
        return [self adcashIdentifier:obfuscate];
    }
}

+ (BOOL)advertisingTrackingEnabled
{
    BOOL enabled = YES;

    if ([self deviceHasASIdentifierManager]) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
        enabled = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
#endif
    }

    return enabled;
}

+ (NSString *)identifierFromASIdentifierManager:(BOOL)obfuscate
{
    if (obfuscate) {
        return @"ifa:XXXX";
    }
    
    NSString *identifier = nil;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= AC_IOS_6_0
    identifier = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
#endif
    
    return [NSString stringWithFormat:@"ifa:%@", [identifier uppercaseString]];
}

+ (NSString *)adcashIdentifier:(BOOL)obfuscate
{
    if (obfuscate) {
        return @"adcash:XXXX";
    }

    NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:ADCASH_IDENTIFIER_DEFAULTS_KEY];
    if (!identifier) {
        CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
        NSString *uuidStr = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject);
        CFRelease(uuidObject);
        [uuidStr autorelease];

        identifier = [NSString stringWithFormat:@"adcash:%@", [uuidStr uppercaseString]];
        [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:ADCASH_IDENTIFIER_DEFAULTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    return identifier;
}

@end
