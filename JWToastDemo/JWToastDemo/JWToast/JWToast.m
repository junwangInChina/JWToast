//
//  JWToast.m
//  JWToastDemo
//
//  Created by wangjun on 2017/11/1.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "JWToast.h"

#define JW_SCREEN_WIDTH         ([UIScreen mainScreen].bounds.size.width)
#define JW_SCREEN_HEIGHT        ([UIScreen mainScreen].bounds.size.height)
#define JW_STATUSBAR_HEIGHT     ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define JW_HORIZONTAL_PADDING   10
#define JW_VERTICAL_PADDING     10

@interface JWToast ()

@property (nonatomic, strong) UIImage *alertImage;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSMutableArray *toastArray;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIImageView *alertImageView;
@property (nonatomic, assign) CGSize messageSize;
@property (nonatomic, assign) CGRect toastShowFrame;
@property (nonatomic, assign) CGRect toastHideFrame;

@property (nonatomic, copy) void(^complete)(void);

@end

@implementation JWToast

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithMessage:(NSString *)message
{
    self = [super init];
    if (self)
    {
        self.message = message;
        
        NSAssert(message.length > 0, @"提示内容不能为空");
        
        [self configDefault];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image message:(NSString *)message
{
    self = [super init];
    if (self)
    {
        self.alertImage = image;
        self.message = message;
        
        NSAssert(message.length > 0, @"提示内容不能为空");
        
        [self configDefault];
    }
    return self;
}

- (void)configDefault
{
    self.position = JWToastPositionCenter;
    self.type = JWToastAutoCalculation;
    self.bgColor = self.alertImage ? [[UIColor blackColor] colorWithAlphaComponent:0.5] :  [UIColor blackColor];
    self.titleColor = [UIColor whiteColor];
    self.autoDismiss = YES;
    self.duration = 2;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.alertImage)
    {
        self.alertImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - 50)/2.0, 30, 50, 50);
    }
    self.messageLabel.frame = CGRectMake((self.alertImage ? (CGRectGetWidth(self.frame) - self.messageSize.width)/2.0 : JW_HORIZONTAL_PADDING),
                                         (self.alertImage ? CGRectGetMaxY(self.alertImageView.frame) + 20 : JW_VERTICAL_PADDING),
                                         self.messageSize.width,
                                         self.messageSize.height);
    [self configDatas];
}

#pragma mark - Lazy loading
- (UILabel *)messageLabel
{
    if (!_messageLabel)
    {
        self.messageLabel = [UILabel new];
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _messageLabel.textAlignment = NSTextAlignmentLeft;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font = [UIFont systemFontOfSize:15.f];
        _messageLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_messageLabel];
    }
    return _messageLabel;
}

- (UIImageView *)alertImageView
{
    if (!_alertImageView)
    {
        self.alertImageView = [UIImageView new];
        _alertImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_alertImageView];
    }
    return _alertImageView;
}

- (NSMutableArray *)toastArray
{
    if (!_toastArray)
    {
        self.toastArray = [NSMutableArray array];
    }
    return _toastArray;
}

#pragma mark - helper
- (void)layoutToastView
{
    [self calculationSize];
    
    switch (self.type)
    {
        case JWToastAutoCalculation:
        case JWToastEqualWidthWithPadding:
        {
            self.layer.cornerRadius = 5;
            self.layer.masksToBounds = YES;
        }
            break;
        case JWToastEqualWidthToScreen:
        {
            self.layer.cornerRadius = 0;
        }
            break;
        default:
            break;
    }
    
    switch (self.position)
    {
        case JWToastPositionTop:
        case JWToastPositionBelowStatusBar:
        {
            [self configSwipeGesture];
        }
            break;
            
        default:
            break;
    }
    
    self.alpha = 0.0f;
    self.frame = self.toastHideFrame;
}

- (void)calculationSize
{
    CGFloat temp_message_max_width = self.alertImage ? (124 - 20) : (self.type == JWToastEqualWidthToScreen) ? JW_SCREEN_WIDTH : (JW_SCREEN_WIDTH - JW_HORIZONTAL_PADDING * 2 - JW_HORIZONTAL_PADDING * 2);
    self.messageSize = [self sizeFromString:self.message
                                       font:self.messageLabel.font
                                   maxWidth:temp_message_max_width];
    
    CGFloat temp_toast_show_x, temp_toast_show_y, temp_toast_hide_x, temp_toast_hide_y, temp_toast_w, temp_toast_h;
    temp_toast_h = self.messageSize.height + JW_VERTICAL_PADDING * 2;
    
    switch (self.position)
    {
        case JWToastPositionTop:
        {
            temp_toast_show_y = 0;
            temp_toast_hide_y = -temp_toast_h;
        }
            break;
        case JWToastPositionBelowStatusBar:
        {
            temp_toast_show_y = JW_STATUSBAR_HEIGHT;
            temp_toast_hide_y = -(temp_toast_h + JW_STATUSBAR_HEIGHT);
            
        }
            break;
        case JWToastPositionCenter:
        {
            temp_toast_show_y = (JW_SCREEN_HEIGHT - temp_toast_h)/2.0;
            temp_toast_hide_y = (JW_SCREEN_HEIGHT - temp_toast_h)/2.0;
        }
            break;
        case JWToastPositionBottom:
        {
            temp_toast_show_y = JW_SCREEN_HEIGHT - temp_toast_h - JW_VERTICAL_PADDING * 4;
            temp_toast_hide_y = JW_SCREEN_HEIGHT - temp_toast_h - JW_VERTICAL_PADDING * 4;
        }
            break;
        default:
            break;
    }
    
    switch (self.type) {
        case JWToastAutoCalculation:
        {
            temp_toast_w = self.messageSize.width + JW_HORIZONTAL_PADDING * 2;
            temp_toast_show_x = (JW_SCREEN_WIDTH - temp_toast_w)/2.0;
            temp_toast_hide_x = (JW_SCREEN_WIDTH - temp_toast_w)/2.0;
        }
            break;
        case JWToastEqualWidthToScreen:
        {
            temp_toast_w = JW_SCREEN_WIDTH;
            temp_toast_show_x = 0;
            temp_toast_hide_x = 0;
        }
            break;
        case JWToastEqualWidthWithPadding:
        {
            temp_toast_w = JW_SCREEN_WIDTH - JW_HORIZONTAL_PADDING * 2;
            temp_toast_show_x = JW_HORIZONTAL_PADDING;
            temp_toast_hide_x = JW_HORIZONTAL_PADDING;
        }
            break;
        default:
            break;
    }
    
    self.toastShowFrame = CGRectMake(temp_toast_show_x, temp_toast_show_y, temp_toast_w, temp_toast_h);
    self.toastHideFrame = CGRectMake(temp_toast_hide_x, temp_toast_hide_y, temp_toast_w, temp_toast_h);
    if (self.alertImage)
    {
        self.toastShowFrame = CGRectMake((JW_SCREEN_WIDTH - 130)/2.0, (JW_SCREEN_HEIGHT - (120 + self.messageSize.height))/2.0, 130, 120 + self.messageSize.height);
        self.toastHideFrame = CGRectMake((JW_SCREEN_WIDTH - 130)/2.0, 0, 130, 120 + self.messageSize.height);
    }
}

- (void)configDatas
{
    self.backgroundColor = self.bgColor;
    self.messageLabel.textColor = self.titleColor;
    self.messageLabel.text = self.message;
    if (self.alertImage)
    {
        self.alertImageView.image = self.alertImage;
    }
}

- (void)configSwipeGesture
{
    self.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeGesture];
}

- (void)configTapGesture
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture
{
    !self.complete?:self.complete();
    [self dismiss];
}

- (CGSize)sizeFromString:(NSString *)string font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    if (!string || string.length <= 0)
    {
        return CGSizeMake(0, 0);
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    
    CGSize contentSize = [string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSParagraphStyleAttributeName : paragraphStyle,
                                                        NSFontAttributeName : font}
                                              context:nil].size;
    
    return contentSize;
}

#pragma mark - Public Method
- (void)show
{
    [self layoutToastView];
    
    // 展示之前，先隐藏掉尚未消失的前一个Toast
    if (self.toastArray.count != 0)
    {
        [self performSelectorOnMainThread:@selector(dismiss) withObject:nil waitUntilDone:YES];
    }
    
    @synchronized (self.toastArray) {
        
        /**
         * 这里将Toast的View添加到，delegate.window而不是keyWindow
         * [UIApplication sharedApplication].delegate.window
         * [UIApplication sharedApplication].keyWindow
         * 是因为弹框，不管是系统的UIAlertView还是自定义的各种Alert控件，一般都是添加到keyWindow上面的。
         * 当如果出现这个场景，先弹框，然后点击弹框上按钮，再toast提示，此时toast会添加到Alert所在的window上去，而alert此时点了按钮，即将被回收，此时的toast可能就是一闪而过
         */
        UIWindow *tempWindow = [UIApplication sharedApplication].delegate.window;
        
        // 先移除旧的View
        for (UIView *tempView in tempWindow.subviews)
        {
            if ([tempView isKindOfClass:[self class]])
            {
                [tempView removeFromSuperview];
            }
        }
        // 再把当前View加上去
        [tempWindow addSubview:self];
        
        [UIView animateWithDuration:0.5f
                              delay:0
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0.5f
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.frame = self.toastShowFrame;
                             self.alpha = 0.7f;
                         } completion:^(BOOL finished) {
                             if (finished)
                             {
                                 [self.toastArray addObject:self];
                                 if (self.autoDismiss)
                                 {
                                     [self performSelector:@selector(dismiss)
                                                withObject:nil
                                                afterDelay:self.duration];
                                 }
                             }
                         }];
    }
}

- (void)show:(void (^)(void))complete
{
    self.complete = complete;
    [self show];
    if (complete)
    {
        self.complete = complete;
        [self configTapGesture];
    }
}

- (void)dismiss
{
    if (self.toastArray.count > 0)
    {
        @synchronized (self.toastArray)
        {
            JWToast *tempToast = self.toastArray[0];
            [NSRunLoop cancelPreviousPerformRequestsWithTarget:tempToast];
            [self.toastArray removeObject:tempToast];
            
            [UIView animateWithDuration:0.2 animations:^{
                self.frame = self.toastHideFrame;
                self.alpha = 0.0f;
            } completion:^(BOOL finished) {
                if (finished)
                {
                    [tempToast removeFromSuperview];
                }
            }];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
