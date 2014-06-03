//
//  CCExtensionHandle.m
//  WeixinSdk
//
//  Created by CZQ on 14-1-2.
//
//

#import "CCExtensionHandle.h"
#import "CCTypeConversion.h"

#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)

@interface CCExtensionHandle () {
    
}

@property (nonatomic, assign) FREContext context;
@property (nonatomic, retain) CCTypeConversion *converter;

- (void)addObservers;
- (void)removeObservers;

@end

@implementation CCExtensionHandle

@synthesize context;
@synthesize converter;

#pragma mark -

- (id)initWithContext:(FREContext)extensionContext
{
    self = [super init];
    if (self) {
        self.context = extensionContext;
        self.converter = [[[CCTypeConversion alloc] init] autorelease];
        [self addObservers];
    }
    return self;
}

- (void)dealloc {
    
    [self removeObservers];
    self.context = nil;
    self.converter = nil;
    
    [super dealloc];
}

#pragma mark -

- (void)addObservers
{

}

- (void)removeObservers
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (FREObject)wxRegister:(FREObject)appid
{
    NSString *strAppId;
    if ([self.converter FREGetObject:appid asString:&strAppId] != FRE_OK)
    {
        return NULL;
    }
    NSLog(@"register:%@", strAppId);
    BOOL r = [WXApi registerApp:strAppId];
    NSLog(@"%hhd", r);
    return NULL;
}

- (FREObject)openUrl:(FREObject)url
{
    NSString *strUrl;
    if ([self.converter FREGetObject:url asString:&strUrl] != FRE_OK)
    {
        return NULL;
    }
    NSLog(@"openurl:%@", strUrl);
    NSURL *nsurl = [NSURL URLWithString:strUrl];
    BOOL r;
    r = [WXApi handleOpenURL:nsurl delegate:self];
    NSLog(@"return:%hhd", r);
    return NULL;
}

- (FREObject)sendTextContent:(FREObject)shareTo
                        text:(FREObject)text
{
    NSString *strShareTo;
    if ([self.converter FREGetObject:shareTo asString:&strShareTo] != FRE_OK)
    {
        strShareTo = @"WXSceneSession";
    }
    
    NSString *strText;
    if ([self.converter FREGetObject:text asString:&strText] != FRE_OK)
    {
        return NULL;
    }
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.text = strText;
    req.bText = YES;
    req.scene = [self getScene:strShareTo];
    
    [WXApi sendReq:req];
    return NULL;
}

- (FREObject)sendLinkContent:(FREObject)shareTo
                       title:(FREObject)title
                        text:(FREObject)text
                         url:(FREObject)url
{
    NSLog(@"share text");
    NSString *strShareTo;
    if ([self.converter FREGetObject:shareTo asString:&strShareTo] != FRE_OK)
    {
        strShareTo = @"WXSceneSession";
    }
    
    NSString *strTitle;
    if ([self.converter FREGetObject:title asString:&strTitle] != FRE_OK)
    {
        return NULL;
    }
    
    NSString *strText;
    if ([self.converter FREGetObject:text asString:&strText] != FRE_OK)
    {
        return NULL;
    }
    
    NSString *strUrl;
    if ([self.converter FREGetObject:url asString:&strUrl] != FRE_OK)
    {
        return NULL;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = strTitle;
    message.description = strText;
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = strUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = [self getScene:strShareTo];
    
    [WXApi sendReq:req];
    return NULL;
}

-(FREObject)sendImageUrlContent:(FREObject)shareTo
                            url:(FREObject)imgUrl
{
    NSString *strShareTo;
    if ([self.converter FREGetObject:shareTo asString:&strShareTo] != FRE_OK)
    {
        strShareTo = @"WXSceneSession";
    }
    
    NSString *strImgUrl;
    if ([self.converter FREGetObject:imgUrl asString:&strImgUrl] != FRE_OK)
    {
        strImgUrl = @"http://tp2.sinaimg.cn/1595852157/180/5596690249/1";
    }
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:strImgUrl]]];
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *thumb = [self.converter thumbnailOfImage:image withMaxSize:100];
    [message setThumbImage:thumb];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(image);
    
    message.mediaObject = ext;
    message.description = @"";
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = [self getScene:strShareTo];

    [WXApi sendReq:req];
    
    return NULL;
}

- (FREObject)sendImageContent:(FREObject)shareTo
                        image:(FREObject)image
{
    NSString *strShareTo;
    if ([self.converter FREGetObject:shareTo asString:&strShareTo] != FRE_OK)
    {
        strShareTo = @"WXSceneSession";
    }
    
    UIImage* uiImage;
    if ([self.converter FREGetImage:&uiImage asObject:image] != FRE_OK)
    {
        return NULL;
    }
    WXMediaMessage *message = [WXMediaMessage message];
    UIImage *thumb = [self.converter thumbnailOfImage:uiImage withMaxSize:100];
    [message setThumbImage:thumb];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImagePNGRepresentation(uiImage);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = [self getScene:strShareTo];
    
    [WXApi sendReq:req];
    NSLog(@"send!");
    return NULL;
}

- (FREObject)sendAppContent:(FREObject)shareTo
                      title:(FREObject)title
                       text:(FREObject)text
                        url:(FREObject)url
                      image:(FREObject)image
{
    NSString *strShareTo;
    if ([self.converter FREGetObject:shareTo asString:&strShareTo] != FRE_OK)
    {
        strShareTo = @"WXSceneSession";
    }
    
    NSString *strTitle;
    if ([self.converter FREGetObject:title asString:&strTitle] != FRE_OK)
    {
        return NULL;
    }
    
    NSString *strText;
    if ([self.converter FREGetObject:text asString:&strText] != FRE_OK)
    {
        return NULL;
    }
    UIImage* uiImage;
    if ([self.converter FREGetImage:&uiImage asObject:image] != FRE_OK)
    {
        return NULL;
    }
    
    NSString *strUrl;
    if ([self.converter FREGetObject:url asString:&strUrl] != FRE_OK)
    {
        return NULL;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = strTitle;
    message.description = strText;
    [message setThumbImage:uiImage];
    
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = @"<xml>extend info</xml>";
    ext.url = strUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = [self getScene:strShareTo];
    
    [WXApi sendReq:req];
    return NULL;
}

- (FREObject)isWechatInstalled
{
    return [self.converter getFREBool:[WXApi isWXAppInstalled]];
}

#pragma base function

- (int)getScene:(NSString*)shareTo
{
    if ([shareTo  isEqual: @"WXSceneFavorite"])
    {
        return WXSceneFavorite;
    }
    else if([shareTo isEqualToString:@"WXSceneTimeline"])
    {
        return WXSceneTimeline;
    }
    return WXSceneSession;
}

#pragma weixin delegate

-(void) onReq:(BaseReq*)req
{
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strErrCode = [NSString stringWithFormat:@"%d", resp.errCode];
        NSLog(@"errcode: %@", strErrCode);
        DISPATCH_STATUS_EVENT(self.context, [@"onResp" UTF8String], [strErrCode UTF8String]);
    }
}

@end
