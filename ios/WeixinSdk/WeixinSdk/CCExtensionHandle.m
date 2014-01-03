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
    message.title = @"爱吃货";
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
    [message setThumbImage:uiImage];
    
    WXImageObject *ext = [WXImageObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res1" ofType:@"jpg"];
    ext.imageData = UIImageJPEGRepresentation(uiImage, 0.9);
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = [self getScene:strShareTo];
    
    [WXApi sendReq:req];
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
//    if([req isKindOfClass:[GetMessageFromWXReq class]])
//    {
//        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
//        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        alert.tag = 1000;
//        [alert show];
//        [alert release];
//    }
//    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
//    {
//        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
//        WXMediaMessage *msg = temp.message;
//        
//        //显示微信传过来的内容
//        WXAppExtendObject *obj = msg.mediaObject;
//        
//        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
//        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%u bytes\n\n", msg.title, msg.description, obj.extInfo, msg.thumbData.length];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
//    else if([req isKindOfClass:[LaunchFromWXReq class]])
//    {
//        //从微信启动App
//        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
//        NSString *strMsg = @"这是从微信启动的消息";
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
        NSString *strErrCode = [NSString stringWithFormat:@"%d", resp.errCode];
        NSLog(@"errcode: %@", strErrCode);
        DISPATCH_STATUS_EVENT(self.context, [@"onResp" UTF8String], [strErrCode UTF8String]);
    }
}

@end
