//
//  ViewController.m
//  JWToastDemo
//
//  Created by wangjun on 2017/11/1.
//  Copyright © 2017年 wangjun. All rights reserved.
//

#import "ViewController.h"

#import "JWToast/JWToast.h"

@interface ViewController ()

@property (nonatomic, assign) JWToastPosition position;
@property (nonatomic, assign) JWToastType type;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)positionChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.position = JWToastPositionTop;
            break;
        case 1:
            self.position = JWToastPositionBelowStatusBar;
            break;
        case 2:
            self.position = JWToastPositionCenter;
            break;
        case 3:
            self.position = JWToastPositionBottom;
            break;
        default:
            break;
    }
}

- (IBAction)typeChanged:(UISegmentedControl *)sender {
    
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            self.type = JWToastAutoCalculation;
            break;
        case 1:
            self.type = JWToastEqualWidthToScreen;
            break;
        case 2:
            self.type = JWToastEqualWidthWithPadding;
            break;
        default:
            break;
    }
}
- (IBAction)show:(id)sender {
    
//    JWToast *toast = [[JWToast alloc] initWithMessage:@"Toast 测试"];
//    toast.position = self.position;
//    toast.type = self.type;
//    [toast show];
    
    JWToast *toast = [[JWToast alloc] initWithImage:[UIImage imageNamed:@"icon_toast_success"] message:@"Toast 测试"];
    toast.position = self.position;
    toast.type = self.type;
    [toast show];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
