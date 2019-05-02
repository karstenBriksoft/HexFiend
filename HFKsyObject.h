//
//  HFKsyObject.h
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This object hierarchy is used mainly to decode the YAML data
 For each thing that's described in the Kaitai spec, there's a subclass that relates
 */
@interface HFKsyObject : NSObject

+ (instancetype)fromDictionary:(NSDictionary*)dictionary;
/// for subclasses to directly map dictionary keys to instance variables
+ (NSMutableDictionary<NSString*,NSString*>*)attributesForKeyNames;
/// for subclasses to interpret the more complicated values of the dictionary
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

NS_ASSUME_NONNULL_END
