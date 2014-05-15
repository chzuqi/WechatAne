//
//  CCExtensionHandle.h
//  WeixinSdk
//
//  Created by CZQ on 14-1-2.
//
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import "WXApi.h"

@interface CCExtensionHandle : NSObject<WXApiDelegate>

- (id)initWithContext:(FREContext)extensionContext;

#pragma mark -

- (FREObject)wxRegister:(FREObject)appid;

- (FREObject)openUrl:(FREObject)url;

- (FREObject)sendTextContent:(FREObject)shareTo
                        text:(FREObject)text;

- (FREObject)sendLinkContent:(FREObject)shareTo
                       title:(FREObject)title
                        text:(FREObject)text
                         url:(FREObject)url;

- (FREObject)sendImageContent:(FREObject)shareTo
                        image:(FREObject)image;
-(FREObject)sendImageUrlContent:(FREObject)shareTo
                            url:(FREObject)imgUrl;
- (FREObject)sendAppContent:(FREObject)shareTo
                      title:(FREObject)title
                       text:(FREObject)text
                        url:(FREObject)url
                      image:(FREObject)image;


- (FREObject)isWechatInstalled;

@end
