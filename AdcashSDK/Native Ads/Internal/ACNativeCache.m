//
//  ACNativeCache.m
//  Adcash
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import "ACNativeCache.h"
#import "ACDiskLRUCache.h"
#import "ACLogging.h"

typedef enum {
    ACNativeCacheMethodDisk = 0,
    ACNativeCacheMethodDiskAndMemory = 1 << 0
} ACNativeCacheMethod;

@interface ACNativeCache () <NSCacheDelegate>

@property (nonatomic, retain) NSCache *memoryCache;
@property (nonatomic, retain) ACDiskLRUCache *diskCache;
@property (nonatomic, assign) ACNativeCacheMethod cacheMethod;

- (BOOL)cachedDataExistsForKey:(NSString *)key withCacheMethod:(ACNativeCacheMethod)cacheMethod;
- (NSData *)retrieveDataForKey:(NSString *)key withCacheMethod:(ACNativeCacheMethod)cacheMethod;
- (void)storeData:(id)data forKey:(NSString *)key withCacheMethod:(ACNativeCacheMethod)cacheMethod;
- (void)removeAllDataFromMemory;
- (void)removeAllDataFromDisk;

@end

@implementation ACNativeCache

+ (instancetype)sharedCache;
{
    static dispatch_once_t once;
    static ACNativeCache *sharedCache;
    dispatch_once(&once, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (id)init
{
    self = [super init];
    if (self != nil) {
        _memoryCache = [[NSCache alloc] init];
        _memoryCache.delegate = self;
        
        _diskCache = [[ACDiskLRUCache alloc] init];
        
        _cacheMethod = ACNativeCacheMethodDiskAndMemory;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:[UIApplication sharedApplication]];
    }

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    
    [_memoryCache release];
    [_diskCache release];
    
    [super dealloc];
}

#pragma mark - Public Cache Interactions

- (void)setInMemoryCacheEnabled:(BOOL)enabled
{
    if (enabled) {
        self.cacheMethod = ACNativeCacheMethodDiskAndMemory;
    }
    else {
        self.cacheMethod = ACNativeCacheMethodDisk;
        [self.memoryCache removeAllObjects];
    }
}

- (BOOL)cachedDataExistsForKey:(NSString *)key
{
    return [self cachedDataExistsForKey:key withCacheMethod:self.cacheMethod];
}

- (NSData *)retrieveDataForKey:(NSString *)key
{
    return [self retrieveDataForKey:key withCacheMethod:self.cacheMethod];
}

- (void)storeData:(NSData *)data forKey:(NSString *)key
{
    [self storeData:data forKey:key withCacheMethod:self.cacheMethod];
}

- (void)removeAllDataFromCache
{
    [self removeAllDataFromMemory];
    [self removeAllDataFromDisk];
}

#pragma mark - Private Cache Implementation

- (BOOL)cachedDataExistsForKey:(NSString *)key withCacheMethod:(ACNativeCacheMethod)cacheMethod
{
    BOOL dataExists = NO;
    if (cacheMethod & ACNativeCacheMethodDiskAndMemory) {
        dataExists = [self.memoryCache objectForKey:key] != nil;
    }
    
    if (!dataExists) {
        dataExists = [self.diskCache cachedDataExistsForKey:key];
    }

    return dataExists;
}

- (id)retrieveDataForKey:(NSString *)key withCacheMethod:(ACNativeCacheMethod)cacheMethod
{
    id data = nil;
    
    if (cacheMethod & ACNativeCacheMethodDiskAndMemory) {
        data = [self.memoryCache objectForKey:key];
    }
    
    if (data) {
        ACLogDebug(@"RETRIEVE FROM MEMORY: %@", key);
    }
    
    
    if (data == nil) {
        data = [self.diskCache retrieveDataForKey:key];
        
        if (data && cacheMethod & ACNativeCacheMethodDiskAndMemory) {
            ACLogDebug(@"RETRIEVE FROM DISK: %@", key);
            
            [self.memoryCache setObject:data forKey:key];
            ACLogDebug(@"STORED IN MEMORY: %@", key);
        }
    }
    
    if (data == nil) {
        ACLogDebug(@"RETRIEVE FAILED: %@", key);
    }
    
    return data;
}

- (void)storeData:(id)data forKey:(NSString *)key withCacheMethod:(ACNativeCacheMethod)cacheMethod
{
    if (data == nil) {
        return;
    }
    
    if (cacheMethod & ACNativeCacheMethodDiskAndMemory) {
        [self.memoryCache setObject:data forKey:key];
        ACLogDebug(@"STORED IN MEMORY: %@", key);
    }
    
    [self.diskCache storeData:data forKey:key];
    ACLogDebug(@"STORED ON DISK: %@", key);
}

- (void)removeAllDataFromMemory
{
    [self.memoryCache removeAllObjects];
}

- (void)removeAllDataFromDisk
{
    [self.diskCache removeAllCachedFiles];
}

#pragma mark - Notifications

- (void)didReceiveMemoryWarning:(NSNotification *)notification
{
    [self.memoryCache removeAllObjects];
}

#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj
{
    ACLogDebug(@"Evicting Object");
}


@end
