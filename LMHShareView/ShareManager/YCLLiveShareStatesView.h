//
//  YCLLiveShareStatesView.h
//  YuncaiLive
//
//  Created by yunzhou03 on 2019/5/17.
//  Copyright © 2019 yunzhouwangluo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YCLLiveShareStatesView : UIView

- (void)show:(UIView *)view  withAnimation:(BOOL)animate;
- (void)dismiss:(BOOL)animate;

@end

NS_ASSUME_NONNULL_END
