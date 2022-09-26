//
//  CCVideoSearchResultController.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"
#import "JXPagingView/JXPagerView.h"
#import "CCVideoSearchRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoSearchResultController : CCBaseTableViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) NSString *searchKey;

- (instancetype)initWithType:(CCVideoSearchType)type;
 
@end

NS_ASSUME_NONNULL_END
