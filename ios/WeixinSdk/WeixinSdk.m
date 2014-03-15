/*
 * WeixinSdk.m
 * WeixinSdk
 *
 * Created by CZQ on 14-1-2.
 * Copyright (c) 2014年 CZQSOFT. All rights reserved.
 */

#import "WeixinSdk.h"
#import "CCExtensionHandle.h"

CCExtensionHandle* CCext_handle;

void WeixinSdkExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &WeixinContextInitializer;
    *ctxFinalizerToSet = &WeixinContextFinalizer;
}

void WeixinSdkExtFinalizer(void* extData) 
{
    return;
}

void WeixinContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    static FRENamedFunction func[] = 
    {
        MAP_FUNCTION(wechat_function_register, NULL),
        MAP_FUNCTION(wechat_function_text, NULL),
        MAP_FUNCTION(wechat_function_link, NULL),
        MAP_FUNCTION(wechat_function_image, NULL),
        MAP_FUNCTION(wechat_function_app, NULL),
        MAP_FUNCTION(wechat_function_open_url, NULL),
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
    CCext_handle = [[CCExtensionHandle alloc]initWithContext:ctx];
}

void WeixinContextFinalizer(FREContext ctx)
{
    return;
}


ANE_FUNCTION(wechat_function_register)
{
    return [CCext_handle wxRegister:argv[0]];
}
ANE_FUNCTION(wechat_function_text)
{
    return [CCext_handle sendTextContent:argv[0] text:argv[1]];
}
ANE_FUNCTION(wechat_function_link)
{
    return [CCext_handle sendLinkContent:argv[0] title:argv[1] text:argv[2] url:argv[3]];
}
ANE_FUNCTION(wechat_function_image)
{
    return [CCext_handle sendImageContent:argv[0] image:argv[1]];
}
ANE_FUNCTION(wechat_function_app)
{
    return [CCext_handle sendAppContent:argv[0] title:argv[1] text:argv[1] url:argv[3] image:argv[4]];
}
ANE_FUNCTION(wechat_function_open_url)
{
    return [CCext_handle openUrl:argv[0]];
}

