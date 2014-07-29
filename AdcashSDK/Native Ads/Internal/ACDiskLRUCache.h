//
//  ACDiskLRUCache.h
//  
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACDiskLRUCache : NSObject

+ (ACDiskLRUCache *)sharedDiskCache;

/*
 * Do NOT call any of the following methods on the main thread, potentially lengthy wait for disk IO
 */
- (BOOL)cachedDataExistsForKey:(NSString *)key;
- (NSData *)retrieveDataForKey:(NSString *)key;
- (void)storeData:(NSData *)data forKey:(NSString *)key;
- (void)removeAllCachedFiles;

@end
