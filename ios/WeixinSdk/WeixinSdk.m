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
        MAP_FUNCTION(registerWeixin, NULL),
        MAP_FUNCTION(sendTextContent, NULL),
        MAP_FUNCTION(sendLinkContent, NULL),
        MAP_FUNCTION(sendImageContent, NULL),
        MAP_FUNCTION(sendAppContent, NULL),
        MAP_FUNCTION(openUrl, NULL),
    };
    
    *numFunctionsToTest = sizeof(func) / sizeof(FRENamedFunction);
    *functionsToSet = func;
    
    CCext_handle = [[CCExtensionHandle alloc]initWithContext:ctx];
}

void WeixinContextFinalizer(FREContext ctx)
{
    return;
}


ANE_FUNCTION(registerWeixin)
{
    return [CCext_handle wxRegister:argv[0]];
}
ANE_FUNCTION(sendTextContent)
{
    return [CCext_handle sendTextContent:argv[0] text:argv[1]];
}
ANE_FUNCTION(sendLinkContent)
{
    return [CCext_handle sendLinkContent:argv[0] title:argv[1] text:argv[2] url:argv[3]];
}
ANE_FUNCTION(sendImageContent)
{
    return [CCext_handle sendImageContent:argv[0] image:argv[1]];
}
ANE_FUNCTION(sendAppContent)
{
    return [CCext_handle sendAppContent:argv[0] title:argv[1] text:argv[1] url:argv[3] image:argv[4]];
}
ANE_FUNCTION(openUrl)
{
    return [CCext_handle openUrl:argv[0]];
}

