//
//  YCLLiveShareStatesView.m
//  YuncaiLive
//
//  Created by yunzhou03 on 2019/5/17.
//  Copyright © 2019 yunzhouwangluo. All rights reserved.
//

#import "YCLLiveShareStatesView.h"
#import "YCLShareManagerHeader.h"
#import "Masonry.h"
#import "QMUIKit/QMUIKit.h"
#import "YYKit.h"
#import "YCLGlobalConfigHeader.h"

#define font_M_14 [UIFont fontWithName:PFM size:14*kScaleWidth]
#define font_M_15 [UIFont fontWithName:PFM size:15*kScaleWidth]
@interface YCLLiveShareStatesView ()

/** 背景View*/
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *cancleBtn;

@end

@implementation YCLLiveShareStatesView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, YCLShareScreenWidth, YCLShareScreenHeight);
        [self setupUI];
    }
    return self;
}

//设置界面
- (void)setupUI {
    self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.5);
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.frame = CGRectMake(0, YCLShareScreenHeight-230, YCLShareScreenWidth, 230);
    _bgView.alpha = 0;
    [self addSubview:_bgView];
    [self setRectCorner:_bgView withCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    _headView = [[UIView alloc] init];
    _headView.backgroundColor = UIColorHex(0xFF0000);
    [_bgView addSubview:_headView];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.tag = 0;
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_cancleBtn setImage:[UIImage imageNamed:@"YCLLive_cancle"] forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_cancleBtn];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = UIColorHex(333333);
    [_bgView addSubview:_titleLabel];
    
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"YCLPopPaymentSuccess"]];
    [_bgView addSubview:_imageView];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.backgroundColor = UIColorHex(0xFF4E00);
    _button.titleLabel.font = [UIFont systemFontOfSize:14];
    _button.layer.masksToBounds = YES;
    _button.layer.cornerRadius = 3;
    _button.tag = 1;
    [_button setTitle:@"好的" forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_button];
    
    self.titleLabel.text = @"分享成功！";
    
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(230*kScaleWidth);
    }];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(40*kScaleWidth);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView);
        make.right.equalTo(self.headView).offset(-15*kScaleWidth);
        make.size.mas_equalTo(CGSizeMake(20*kScaleWidth, 20*kScaleWidth));
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(20*kScaleWidth);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(34*kScaleWidth, 34*kScaleWidth));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.imageView.mas_bottom).offset(29*kScaleWidth);
    }];
    
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView).offset(([self isIPhoneXSeries]?-40:-20*kScaleWidth));
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(75*kScaleWidth,25*kScaleWidth));
    }];
    
    [super updateConstraints];
}

- (void)buttonClick:(UIButton *)button {
    [self dismiss:YES];
}

- (void)show:(UIView *)view  withAnimation:(BOOL)animate {
    if (view) {
        [view addSubview:self];
    }else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bgView.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        self.bgView.alpha = 1;
    }
}

- (void)dismiss:(BOOL)animate {
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else {
        [self removeFromSuperview];
    }
}

- (void)setRectCorner:(UIView *)view withCorner:(UIRectCorner)rectCorner {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (BOOL)isIPhoneXSeries {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

@end
