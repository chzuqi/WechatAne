//
//  NdCPTypeConversion.m
//  NdComPlatformExtension
//
//  Created by Chen Jianshe on 12-10-19.
//  Copyright (c) 2012年 NetDragon.WebSoft.Inc. All rights reserved.
//

#import "CCTypeConversion.h"

@implementation CCTypeConversion

- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value
{
    FREResult result;
    uint32_t length = 0;
    const uint8_t* tempValue = NULL;
    
    result = FREGetObjectAsUTF8( object, &length, &tempValue );
    if( result != FRE_OK ) return result;
    
    *value = [NSString stringWithUTF8String: (char*) tempValue];
    return FRE_OK;
}

- (FREResult) FREGetString:(NSString*)string asObject:(FREObject*)asString
{
    if( string == nil )
    {
        return FRE_INVALID_ARGUMENT;
    }
    const char* utf8String = string.UTF8String;
    unsigned long length = strlen( utf8String );
    return FRENewObjectFromUTF8( length + 1, (uint8_t*) utf8String, asString );
}

- (FREResult) FREGetDate:(NSDate*)date asObject:(FREObject*)asDate
{
    if( date == nil )
    {
        return FRE_INVALID_ARGUMENT;
    }
    NSTimeInterval timestamp = date.timeIntervalSince1970 * 1000;
    FREResult result;
    FREObject time;
    result = FRENewObjectFromDouble( timestamp, &time );
    if( result != FRE_OK ) return result;
    result = FRENewObject( (const uint8_t*)"Date", 0, NULL, asDate, NULL );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( *asDate, (const uint8_t*)"time", time, NULL);
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult)FREGetImage:(UIImage**)value asObject:(FREObject*)asImage
{
    FREResult result;
    FREBitmapData2 bitmapData;
    result = FREAcquireBitmapData2( asImage, &bitmapData );
    if( result != FRE_OK ) return result;
    
    int width = bitmapData.width;
    int height = bitmapData.height;
    
    // make data provider from buffer
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bitmapData.bits32, (width * height * 4), NULL);
    
    // set up for CGImage creation
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo;
    
    if( bitmapData.hasAlpha )
    {
        if( bitmapData.isPremultiplied )
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst;
        }
        else
        {
            bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaFirst;
        }
    }
    else
    {
        bitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    }
    
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    *value = [UIImage imageWithCGImage:imageRef];
    
    FREReleaseBitmapData( asImage );
    CGColorSpaceRelease(colorSpaceRef);
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toString:(NSString*)value
{
    if( value == nil )
    {
        return FRE_INVALID_ARGUMENT;
    }
    FREResult result;
    FREObject asValue;
    result = [self FREGetString:value asObject:&asValue];
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toBool:(uint32_t)value
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromBool( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toInt:(int32_t)value
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromInt32( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toDouble:(double)value
{
    FREResult result;
    FREObject asValue;
    result = FRENewObjectFromDouble( value, &asValue );
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (FREResult) FRESetObject:(FREObject)asObject property:(const uint8_t*)propertyName toDate:(NSDate*)value
{
    if( value == nil )
    {
        return FRE_INVALID_ARGUMENT;
    }
    FREResult result;
    FREObject asValue;
    result = [self FREGetDate:value asObject:&asValue];
    if( result != FRE_OK ) return result;
    result = FRESetObjectProperty( asObject, propertyName, asValue, NULL );
    if( result != FRE_OK ) return result;
    return FRE_OK;
}

- (UIImage*)thumbnailOfImage:(UIImage*)image withMaxSize:(float)maxsize
{
    //NSLog(@"create thumbnail image");
    
    if (!image)
        return nil;
    
    CGImageRef imageRef = [image CGImage];
    UIImage *thumb = nil;
    
    float _width = CGImageGetWidth(imageRef);
    float _height = CGImageGetHeight(imageRef);
    
    // hardcode width and height for now, shouldn't stay like that
    float _resizeToWidth;
    float _resizeToHeight;
    
    if (_width > _height){
        _resizeToWidth = maxsize;
        _resizeToHeight = maxsize * _height / _width;
    }else{
        _resizeToHeight = maxsize;
        _resizeToWidth = maxsize * _width / _height;
    }
    
//    _resizeToWidth = aSize.width;
//    _resizeToHeight = aSize.height;
    
    float _moveX = 0.0f;
    float _moveY = 0.0f;
    
    // determine the start position in the window if it doesn't fit the sizes 100%
    
    //NSLog(@" width: %f  to: %f", _width, _resizeToWidth);
    //NSLog(@" height: %f  to: %f", _height, _resizeToHeight);
    
    // resize the image if it is bigger than the screen only
    if ( (_width > _resizeToWidth) || (_height > _resizeToHeight) )
    {
        float _amount = 0.0f;
        
        if (_width > _resizeToWidth)
        {
            _amount = _resizeToWidth / _width;
            _width *= _amount;
            _height *= _amount;
            
            //NSLog(@"1 width: %f height: %f", _width, _height);
        }
        
        if (_height > _resizeToHeight)
        {
            _amount = _resizeToHeight / _height;
            _width *= _amount;
            _height *= _amount;
            
            //NSLog(@"2 width: %f height: %f", _width, _height);
        }
    }
    
    _width = (NSInteger)_width;
    _height = (NSInteger)_height;
    
    _resizeToWidth = _width;
    _resizeToHeight = _height;
    
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                _resizeToWidth,
                                                _resizeToHeight,
                                                CGImageGetBitsPerComponent(imageRef),
                                                CGImageGetBitsPerPixel(imageRef)*_resizeToWidth,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef)
                                                );
    
    // now center the image
    _moveX = (_resizeToWidth - _width) / 2;
    _moveY = (_resizeToHeight - _height) / 2;
    
    CGContextSetRGBFillColor(bitmap, 1.f, 1.f, 1.f, 1.0f);
    CGContextFillRect( bitmap, CGRectMake(0, 0, _resizeToWidth, _resizeToHeight));
    CGContextDrawImage( bitmap, CGRectMake(_moveX, _moveY, _width, _height), imageRef );
    
    // create a templete imageref.
    CGImageRef ref = CGBitmapContextCreateImage( bitmap );
    thumb = [UIImage imageWithCGImage:ref];
    
    // release the templete imageref.
    CGContextRelease( bitmap );
    CGImageRelease( ref );
    
    return [[thumb retain] autorelease];
    
}

@end
