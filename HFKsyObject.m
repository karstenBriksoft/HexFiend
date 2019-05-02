//
//  HFKsyObject.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyObject.h"

@implementation HFKsyObject

+ (instancetype)fromDictionary:(NSDictionary*)dictionary
{
    return [[self alloc] initWithDictionary:dictionary];
}

+ (NSMutableDictionary<NSString*,NSString*>*)attributesForKeyNames
{
    return [NSMutableDictionary dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    self = [self init];
    if (self) {
        NSDictionary* keys = [[self class] attributesForKeyNames];
        for (NSString* keyName in keys.allKeys)
        {
            id value = [dictionary objectForKey:keyName];
            NSString* keyPath = keys[keyName];
            [self setValue:value forKeyPath:keyPath];
        }
    }
    return self;
}

@end
