//
//  HFKsyMeta.m
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import "HFKsyMeta.h"

@interface HFKsyMeta ()
@property (retain) NSString* identifier;
@property (retain) NSString* title;
@property (retain) NSString* application;
@property (retain) NSArray<NSString*>* imports;
@property (retain) NSString* encoding;
@property (retain) NSString* endian;
@property (retain) NSString* ksVersion;
@property (retain) NSNumber* ksDebug; // use NSNumber instead of BOOL to have KVO handle nil properly
@property (retain) NSNumber* ksOpaqueTypes; // in case of BOOL a nil value would crash the app
@property (retain) NSString* license;
@property (retain) NSArray<NSString*>* fileExtensions;

@end

@implementation HFKsyMeta

+ (NSMutableDictionary<NSString*,NSString*>*)attributesForKeyNames
{
    NSMutableDictionary<NSString*,NSString*>* dict = [super attributesForKeyNames];
    dict[@"id"] = @"identifier";
    dict[@"title"] = @"title";
    dict[@"application"] = @"application";
    dict[@"imports"] = @"imports";
    dict[@"encoding"] = @"encoding";
    dict[@"endian"] = @"endian";
    dict[@"ks-version"] = @"ksVersion";
    dict[@"ks-debug"] = @"ksDebug";
    dict[@"ks-opaque-types"] = @"ksOpaqueTypes";
    dict[@"license"] = @"license";
    dict[@"file-extension"] = @"fileExtensionStrings";
    return dict;
}

- (void)setFileExtensionStrings:(id)object
{
    if ([object isKindOfClass:[NSArray class]])
    {
        _fileExtensions = (NSArray*)object;
    }
    if ([object isKindOfClass:[NSString class]])
    {
        _fileExtensions = @[ (NSString*)object ];
    }
}
@end
