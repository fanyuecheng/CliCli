//
//  SceneDelegate.m
//  CliCli
//
//  Created by Fancy
//

#import "SceneDelegate.h"
#import "AppDelegate.h"
#import "CCUI.h"
#import "CCIconFont.h"
#import "CCHomeViewController.h"
#import "CCVideoRankViewController.h"
#import "CCMineViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "CCVideoDownloadRequest.h"
@interface SceneDelegate ()

@property (nonatomic, strong) CCBaseTabBarController *tabBarController;
@property (nonatomic, strong) CCHomeViewController   *homeController;
@property (nonatomic, strong) CCVideoRankViewController *rankController;
@property (nonatomic, strong) CCMineViewController   *mineController;

@end

@implementation SceneDelegate

- (void)scene:(UIWindowScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    [self configAppearance];
     
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithWindowScene:scene];
    }
    self.window.frame = UIScreen.mainScreen.bounds;
    self.window.backgroundColor = UIColor.systemBackgroundColor;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).window = self.window;
}

- (void)sceneDidDisconnect:(UIScene *)scene {

}

- (void)sceneDidBecomeActive:(UIScene *)scene {

}

- (void)sceneWillResignActive:(UIScene *)scene {

}


- (void)sceneWillEnterForeground:(UIScene *)scene {

}


- (void)sceneDidEnterBackground:(UIScene *)scene {

}

#pragma mark - Method
- (void)configAppearance {
    UITabBarAppearance *tabBarAppearance = [[UITabBarAppearance alloc] init];
    [tabBarAppearance configureWithDefaultBackground];
     
    UINavigationBarAppearance *navigationBarAppearance = [[UINavigationBarAppearance alloc] init];
    [navigationBarAppearance configureWithDefaultBackground];
    navigationBarAppearance.buttonAppearance.normal.titleTextAttributes = @{NSFontAttributeName : UIFontMake(15)};
    
    [UITabBar appearance].standardAppearance = tabBarAppearance;
    [UINavigationBar appearance].standardAppearance = navigationBarAppearance;
    if (@available(iOS 15.0, *)) {
        [UITabBar appearance].scrollEdgeAppearance = tabBarAppearance;
        [UINavigationBar appearance].scrollEdgeAppearance = navigationBarAppearance;
    }
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
}

#pragma mark - Get
 
- (CCBaseTabBarController *)tabBarController {
    if (!_tabBarController) {
        _tabBarController = [[CCBaseTabBarController alloc] init];
        CCBaseNavigationController *home = [[CCBaseNavigationController alloc] initWithRootViewController:self.homeController];
        home.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[CCIconFont homeFont] imageWithColor:nil size:22] tag:0];
        
        CCBaseNavigationController *rank = [[CCBaseNavigationController alloc] initWithRootViewController:self.rankController];
        rank.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"排行" image:[[CCIconFont rankFont] imageWithColor:nil size:22] tag:0];
        
        CCBaseNavigationController *mine = [[CCBaseNavigationController alloc] initWithRootViewController:self.mineController];
        mine.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[CCIconFont mineFont] imageWithColor:nil size:22] tag:0];
        
        _tabBarController.viewControllers = @[home, rank, mine];
        
    }
    return _tabBarController;
}

- (CCHomeViewController *)homeController {
    if (!_homeController) {
        _homeController = [[CCHomeViewController alloc] init];
        _homeController.hidesBottomBarWhenPushed = NO;
    }
    return _homeController;
}

- (CCVideoRankViewController *)rankController {
    if (!_rankController) {
        _rankController = [[CCVideoRankViewController alloc] init];
        _rankController.hidesBottomBarWhenPushed = NO;
    }
    return _rankController;
}

- (CCMineViewController *)mineController {
    if (!_mineController) {
        _mineController = [[CCMineViewController alloc] init];
        _mineController.hidesBottomBarWhenPushed = NO;
    }
    return _mineController;
}

@end
