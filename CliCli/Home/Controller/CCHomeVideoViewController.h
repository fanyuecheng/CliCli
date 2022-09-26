//
//  CCHomeVideoViewController.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"
#import "CCVideoNavigation.h"
#import "JXPagingView/JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCHomeVideoViewController : CCBaseViewController <JXPagerViewListViewDelegate>

@property (nonatomic, strong) CCVideoNavigation *navigation;


@end

NS_ASSUME_NONNULL_END
