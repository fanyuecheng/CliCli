//
//  CCVideoInfoController.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"
#import "JXPagingView/JXPagerView.h"
#import "CCVideoDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoInfoController : CCBaseTableViewController <JXPagerViewListViewDelegate>

@property (nonatomic, strong) CCVideoDetail *detail;
@property (nonatomic, copy)   void (^episodeBlock)(NSInteger index);
@property (nonatomic, copy)   void (^downloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
