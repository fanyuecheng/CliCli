//
//  CCBaseTabBarController.m
//  CCUI
//
//  Created by Fancy
//

#import "CCBaseTabBarController.h"

@interface CCBaseTabBarController ()

@end

@implementation CCBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
     
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    }
}

#pragma mark - 方向
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
