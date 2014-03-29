//
//  NdCPTypeConversion.h
//  NdComPlatformExtension
//
//  Created by Chen Jianshe on 12-10-19.
//  Copyright (c) 2012年 NetDragon.WebSoft.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>

@interface CCTypeConversion : NSObject

- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value;

- (FREResult) FREGetString:(NSString*)string asObject:(FREObject*)asString;
- (FREResult) FREGetDate:(NSDate*)date asObject:(FREObject*)asDate;

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toString:(NSString*)value;
- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toBool:(uint32_t)value;
- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toInt:(int32_t)value;
- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toDouble:(double)value;
- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toDate:(NSDate*)value;
- (FREResult)FREGetImage:(UIImage**)value asObject:(FREObject*)asImage;

- (UIImage*)thumbnailOfImage:(UIImage*)image withMaxSize:(float)maxsize;
@end
