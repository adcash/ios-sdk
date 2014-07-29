//
//  NSJSONSerialization+ACAdditions.h
//  Adcash
//
//  Copyright (c) 2014 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (ACAdditions)

+ (id)mp_JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt clearNullObjects:(BOOL)clearNulls error:(NSError **)error;

@end
