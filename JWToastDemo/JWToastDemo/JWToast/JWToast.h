//
//  JWToast.h
//  JWToastDemo
//
//  Created by wangjun on 2017/11/1.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JWToastPosition) {
    JWToastPositionTop,             /* 顶部 */
    JWToastPositionBelowStatusBar,  /* StatusBar下方 */
    JWToastPositionCenter,          /* 中间 */
    JWToastPositionBottom           /* 底部 */
};

typedef NS_ENUM(NSUInteger, JWToastType) {
    JWToastAutoCalculation,         /* 宽高自动计算 */
    JWToastEqualWidthToScreen,      /* 与屏幕等宽 */
    JWToastEqualWidthWithPadding,   /* 等宽两边留有边距 */
};

@interface JWToast : UIView

@property (nonatomic, assign) JWToastPosition position; /* default is JWToastPositionCenter */
@property (nonatomic, assign) JWToastType type;         /* default is JWToastAutoCalculation */
@property (nonatomic, strong) UIColor *bgColor;         /* default is [UIColor darkGrayColor] */
@property (nonatomic, strong) UIColor *titleColor;      /* default is [UIColor whiteColor] */
@property (nonatomic, assign) BOOL autoDismiss;         /* 是否自动隐藏 default is YES */
@property (nonatomic, assign) NSTimeInterval duration;  /* 展示时间 default is 1s */

- (instancetype)init DEPRECATED_IN_MAC_OS_X_VERSION_10_0_AND_LATER;

- (instancetype)initWithMessage:(NSString *)message;

- (instancetype)initWithImage:(UIImage *)image message:(NSString *)message;

- (void)show;

- (void)show:(void(^)(void))complete;

- (void)dismiss;

@end
