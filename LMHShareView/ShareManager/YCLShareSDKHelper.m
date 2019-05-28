//
//  YCLShareSDKHelper.m
//  YuncaiLive
//
//  Created by 云舟02 on 2019/5/24.
//  Copyright © 2019 yunzhouwangluo. All rights reserved.
//

#import "YCLShareSDKHelper.h"
#import "ShareSDKExtension/ShareSDK+Extension.h"

@implementation YCLShareSDKHelper

    
+ (BOOL)isWXAppInstalled {
    if (![ShareSDK isClientInstalled:(SSDKPlatformSubTypeWechatSession)]) {
        [self alertControllerWithMessage:@"检测到您未安装微信!"];
        return NO;
    }
    return YES;
}
    
+ (BOOL)isQQInstalled {
    if (![ShareSDK isClientInstalled:(SSDKPlatformTypeQQ)]) {
        [self alertControllerWithMessage:@"检测到您未安装QQ!"];
        return NO;
    }
    return YES;
}
    
+ (BOOL)isWeiboAppInstalled {
    if (![ShareSDK isClientInstalled:(SSDKPlatformTypeSinaWeibo)]) {
        [self alertControllerWithMessage:@"检测到您未安装微博!"];
        return NO;
    }
    return YES;
}
    
    
+ (void)alertControllerWithMessage:(NSString*)message {
    UIAlertController * alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertVc addAction:action];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVc animated:YES completion:nil];
}
    
@end
