//
//  CCVideoCommentCell.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"
#import "CCVideoComment.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoCommentCell : CCBaseTableViewCell

@property (nonatomic, strong) CCVideoComment *comment;
@property (nonatomic, copy)   void (^replyBlock)(CCVideoComment *comment);

@end

NS_ASSUME_NONNULL_END
