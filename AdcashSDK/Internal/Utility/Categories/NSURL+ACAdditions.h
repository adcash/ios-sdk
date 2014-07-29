//
//  NSURL+ACAdditions.h
//  Adcash
//
//  Copyright (c) 2013 Adcash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (ACAdditions)

- (NSDictionary *)mp_queryAsDictionary;
- (BOOL)mp_hasTelephoneScheme;
- (BOOL)mp_hasTelephonePromptScheme;

@end
