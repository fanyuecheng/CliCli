//
//  CCVideoCommentController.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"
#import "JXPagingView/JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCVideoCommentType) {
    CCVideoCommentTypeVideo,
    CCVideoCommentTypeReply
};

@interface CCVideoCommentController : CCBaseViewController <JXPagerViewListViewDelegate>

@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, assign) NSInteger videoId;

- (instancetype)initWithVideoId:(NSInteger)videoId;
- (instancetype)initWithCommentId:(NSInteger)commentId; 

@end

NS_ASSUME_NONNULL_END
