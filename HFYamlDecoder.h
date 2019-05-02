//
//  HFYamlDecoder.h
//  HexFiend_2
//
//  Created by Karsten Kusche on 02.05.19.
//  Copyright © 2019 ridiculous_fish. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFYamlDecoder : NSObject

+ (id _Nullable)propertyListFromData:(NSData*)data error:(NSError**)error;
+ (NSDictionary* _Nullable)dictionaryFromData:(NSData*)data error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
