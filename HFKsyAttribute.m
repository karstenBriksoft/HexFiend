//
//  HFKsyAttribute.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyAttribute.h"

@interface HFKsyAttribute ()

@property (retain) id contents;
@property (retain) NSString* type;
@property (retain) NSString* repeat;
@property (retain) NSString* repeatExpression;
@property (retain) NSString* repeatUntil;
@property (retain) NSString* condition;
@end

@implementation HFKsyAttribute

+ (NSMutableDictionary<NSString*,NSString*>*)attributesForKeyNames
{
    NSMutableDictionary<NSString*,NSString*>* dict = [super attributesForKeyNames];
    dict[@"contents"] = @"contents";
    dict[@"type"] = @"type";
    dict[@"repeat"] = @"repeat";
    dict[@"repeat-expr"] = @"repeatExpression";
    dict[@"repeat-until"] = @"repeatUntil";
    dict[@"if"] = @"condition";
    return dict;
}

@end
