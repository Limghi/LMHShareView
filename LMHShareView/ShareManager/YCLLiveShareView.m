//
//  YCLLiveShareView.m
//  YuncaiLive
//
//  Created by yunzhou03 on 2019/5/17.
//  Copyright © 2019 yunzhouwangluo. All rights reserved.
//

#import "YCLLiveShareView.h"
#import "YCLLiveShareStatesView.h"
#import "ShareSDK/ShareSDK.h"
#import "YCLShareSDKHelper.h"
#import "YCLToastViewManager.h"
#import "QMUIKit/QMUIKit.h"
#import "YCLShareManagerHeader.h"
#import "YYKit/YYKit.h"
#import "Masonry.h"
#import "YCLGlobalConfigHeader.h"

@interface YCLLiveShareView ()

/** 背景View*/
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) NSMutableArray *itemArray;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) YCLSharedModel* model;

@end

@implementation YCLLiveShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)didTapItem:(QMUIButton *)button {
    NSLog(@"url: %@-----title: %@---content: %@",self.model.url,self.model.title,self.model.content);
    [self dismiss:NO];
    
    NSMutableDictionary * shareParams = [self shareParamsWithTag:button.tag];//nil 代表是复制
    if (![self validateWithTag:button.tag] || !shareParams) {//验证是否存在该平台 或是否是 复制
        return;
    }
    
    //有的平台要客户端分享需要加此方法，例如微博
    //    [shareParams SSDKEnableUseClientShare];
    [ShareSDK share:(SSDKPlatformType)button.tag parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         
         NSLog(@"%@", error.localizedDescription);
         
         switch (state) {
             case SSDKResponseStateSuccess: {
                 YCLLiveShareStatesView *rewardView = [[YCLLiveShareStatesView alloc] init];
                 [rewardView show:[UIApplication sharedApplication].keyWindow withAnimation:YES];
                 [self removeFromSuperview];
                 NSLog(@"分享成功！");
                 break;
             }
             case SSDKResponseStateFail: {
                 NSLog(@"分享失败！");
                 break;
             }
             case SSDKResponseStateCancel: {
                 NSLog(@"取消分享！");
                 break;
             }
             default:
                 break;
         }
     }];
}

#pragma mark - 数据处理
/**
 验证平台是否存在
 
 @param tag tag
 @return 是否存在
 */
- (BOOL)validateWithTag:(NSInteger)tag {
    if ((SSDKPlatformType)tag==SSDKPlatformSubTypeQQFriend||(SSDKPlatformType)tag==SSDKPlatformSubTypeQZone) {//判断是否安装QQ
        if (![YCLShareSDKHelper isQQInstalled]) {
            return NO;
        }
    }
    
    if ((SSDKPlatformType)tag==SSDKPlatformTypeSinaWeibo) {//判断是否安装微博
        if (![YCLShareSDKHelper isWeiboAppInstalled]) {
            return NO;
        }
    }
    
    if ((SSDKPlatformType)tag==SSDKPlatformSubTypeWechatSession||(SSDKPlatformType)tag==SSDKPlatformSubTypeWechatTimeline) {//判断是否安装微信
        if (![YCLShareSDKHelper isWXAppInstalled]) {
            return NO;
        }
    }
    return YES;
}

/**
 分享参数
 
 @param tag tag
 @return 分享参数
 */
- (NSMutableDictionary *)shareParamsWithTag:(NSInteger)tag {
    if ((SSDKPlatformType)tag==SSDKPlatformTypeUnknown) {//复制
        UIPasteboard *copy = [UIPasteboard generalPasteboard];
        [copy setString:self.model.url];
        if (self.model.url==nil||[self.model.url isEqualToString:@""]) {
            [QMUITips showError:@"复制失败" inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.5];
        }else{
            [QMUITips showSucceed:@"复制成功" inView:[UIApplication sharedApplication].keyWindow hideAfterDelay:1.5];
        }
        return nil;
    }else if ((SSDKPlatformType)tag==SSDKPlatformTypeSinaWeibo) {
        if (self.model.content) {
            self.model.content = [NSString stringWithFormat:@"%@\n%@\n%@",self.model.title,self.model.content,self.model.url];
        }else{
            self.model.content = [NSString stringWithFormat:@"%@\n%@",self.model.title,self.model.url];
        }
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:self.model.content
                                     images:self.model.imageArray
                                        url:[NSURL URLWithString:self.model.url]
                                      title:self.model.title
                                       type:(SSDKContentType)self.model.type];
    return shareParams;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[
  @{@"title":@"微信好友",@"pic":@"share_wx",@"type":@(SSDKPlatformSubTypeWechatSession)},
  @{@"title":@"朋友圈",@"pic":@"share_wx_quan",@"type":@(SSDKPlatformSubTypeWechatTimeline)},
  @{@"title":@"QQ",@"pic":@"share_qq",@"type":@(SSDKPlatformSubTypeQQFriend)},
  @{@"title":@"新浪微博",@"pic":@"share_wb",@"type":@(SSDKPlatformTypeSinaWeibo)},
  @{@"title":@"短信",@"pic":@"share_dx",@"type":@(SSDKPlatformTypeSMS)},
  @{@"title":@"复制链接",@"pic":@"share_lj",@"type":@(SSDKPlatformTypeUnknown)}
  ];
    }
    return _dataArray;
}

- (NSMutableArray *)itemArray {
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}

- (instancetype)initWithModel:(YCLSharedModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = UIColorMakeWithRGBA(0, 0, 0, 0.5);
    self.frame = CGRectMake(0, 0, YCLShareScreenWidth, YCLShareScreenHeight);
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.frame = CGRectMake(0, YCLShareScreenHeight, YCLShareScreenWidth, [self calculationHeight]);
    [self addSubview:_bgView];
    [self setRectCorner:_bgView withCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
    
    _headView = [[UIView alloc] init];
    _headView.backgroundColor = UIColorHex(0xFF0000);
    [_bgView addSubview:_headView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"选择分享平台";
    [_headView addSubview:_titleLabel];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_cancleBtn setImage:[UIImage imageNamed:@"YCLLive_cancle"] forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_cancleBtn];
    
    NSInteger i=0;
    for (NSDictionary *dict in self.dataArray) {
        QMUIButton *button = [[QMUIButton alloc] qmui_initWithImage:[UIImage imageNamed:dict[@"pic"]] title:dict[@"title"]];
        button.tag = [dict[@"type"] integerValue];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.imagePosition = QMUIButtonImagePositionTop;
        button.spacingBetweenImageAndTitle = 12;
        [button setTitleColor:UIColorHex(333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didTapItem:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:button];
        [self.itemArray addObject:button];
        
        i++;
    }
    
    [self setNeedsUpdateConstraints];
}

- (void)cancleBtnClick {
    [self dismiss:YES];
}

- (void)updateConstraints {
    CGSize size = [@"在线用户" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * kScaleWidth]}];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bgView);
        make.height.mas_equalTo(40*kScaleWidth);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headView);
        make.right.equalTo(self.headView).offset(-15*kScaleWidth);
        make.size.mas_equalTo(CGSizeMake(20*kScaleWidth, 20*kScaleWidth));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.headView);
    }];
    
    NSInteger i = 0;
    UIView *seleBtn;
    for (UIView *button in self.itemArray) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i<3) {
                make.top.equalTo(self.headView.mas_bottom).offset(15*kScaleWidth);
                if (seleBtn) {
                    make.left.equalTo(seleBtn.mas_right).offset(68*kScaleWidth);
                }else {
                    make.left.equalTo(self.bgView).offset(45*kScaleWidth);
                }
            }else {
                if (i!=3) {
                    make.left.equalTo(seleBtn.mas_right).offset(68*kScaleWidth);
                    make.top.equalTo(seleBtn);
                }else {
                    make.left.equalTo(self.bgView).offset(45*kScaleWidth);
                    make.top.equalTo(seleBtn.mas_bottom).offset(15*kScaleWidth);
                }
            }
            make.size.mas_equalTo(CGSizeMake((ceil(size.width)>(50)?ceil(size.width):50), 50 + 12*kScaleWidth +size.height));
        }];
        
        seleBtn = button;
        i++;
    }
    
    [super updateConstraints];
}

- (void)setRectCorner:(UIView *)view withCorner:(UIRectCorner)rectCorner {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

- (CGFloat)calculationHeight {
    CGSize size = [@"在线用户" sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 * kScaleWidth]}];
    return ((15+12+15+12+12+40)*kScaleWidth + size.height*2 + 50*2 + ([self isIPhoneXSeries]?43:0));
}

- (void)show:(UIView *)view  withAnimation:(BOOL)animate {
    if (view) {
        [view addSubview:self];
    }else {
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    
    if (animate) {
        [UIView animateWithDuration:0.25 animations:^{
            self.bgView.qmui_top = kScreenHeight - self.bgView.qmui_height;
        } completion:^(BOOL finished) {
            
        }];
    }else {
        self.bgView.qmui_top = kScreenHeight - self.bgView.qmui_height;
    }
}

- (void)dismiss:(BOOL)animate {
    if (animate) {
        [UIView animateWithDuration:0.2 animations:^{
            self.bgView.qmui_top = kScreenHeight;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else {
        [self removeFromSuperview];
    }
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
