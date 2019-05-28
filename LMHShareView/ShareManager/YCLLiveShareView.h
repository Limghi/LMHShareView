//
//  YCLLiveShareView.h
//  YuncaiLive
//
//  Created by yunzhou03 on 2019/5/17.
//  Copyright © 2019 yunzhouwangluo. All rights reserved.
//

#import "YCLSharedModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCLLiveShareView : UIView

/**
 分享
 
 @param model 分享内容   com.86cp.www.YuncaiLive
 @return self
 */
- (instancetype)initWithModel:(YCLSharedModel *)model;

- (void)show:(UIView *)view  withAnimation:(BOOL)animate;
- (void)dismiss:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
