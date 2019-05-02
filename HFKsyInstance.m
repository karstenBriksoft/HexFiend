//
//  HFKsyInstance.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyInstance.h"

@interface HFKsyInstance ()

@property (retain) NSString* position;
@property (retain) NSString* io;
@property (retain) NSString* value;

@end

@implementation HFKsyInstance

+ (NSMutableDictionary<NSString*,NSString*>*)attributesForKeyNames
{
    NSMutableDictionary<NSString*,NSString*>* dict = [super attributesForKeyNames];
    dict[@"pos"] = @"position";
    dict[@"io"] = @"io";
    dict[@"value"] = @"value";
    return dict;
}

@end
