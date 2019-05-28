//
//  YCLSharedModel.h
//  YuncaiLive
//
//  Created by yunzhou03 on 2019/5/20.
//  Copyright © 2019 yunzhouwangluo. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,YCLContentType) {
    /**
     *  自动适配类型，视传入的参数来决定
     */
    YCLContentTypeAuto         = 0,
    
    /**
     *  文本
     */
    YCLContentTypeText         = 1,
    
    /**
     *  图片
     */
    YCLContentTypeImage        = 2,
    
    /**
     *  网页
     */
    YCLContentTypeWebPage      = 3,
    
    /**
     *  应用
     */
    YCLContentTypeApp          = 4,
    
    /**
     *  音频
     */
    YCLContentTypeAudio        = 5,
    
    /**
     *  视频
     */
    YCLContentTypeVideo        = 6,
    
    /**
     *  文件类型(暂时仅微信可用)
     */
    YCLContentTypeFile         = 7,
    
    //图片类型 仅FacebookMessage 分享图片并需要明确结果时 注此类型分享后不会显示应用名称与icon
    //v3.6.2 增加
    YCLContentTypeFBMessageImages = 8,
    
    //图片类型 仅FacebookMessage 分享视频并需要明确结果时 注此类型分享后不会显示应用名称与icon
    //所分享的视频地址必须为相册地址
    //v3.6.2 增加
    YCLContentTypeFBMessageVideo = 9,
    
    //3.6.3 小程序分享(暂时仅微信可用)
    YCLContentTypeMiniProgram  = 10
};

@interface YCLSharedModel : NSObject

/**
 分享标题
 */
@property(nonatomic,copy) NSString* title;

/**
 分享链接
 */
@property(nonatomic,copy) NSString* url;

/**
 分享内容
 */
@property(nonatomic,copy) NSString* content;

/**
 分享图片数组
 */
@property(nonatomic,strong) NSArray* imageArray;

/**
 分享类型
 */
@property(nonatomic,assign) YCLContentType type;

@end

NS_ASSUME_NONNULL_END
