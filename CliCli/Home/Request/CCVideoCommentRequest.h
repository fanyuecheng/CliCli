//
//  CCVideoCommentRequest.h
//  CliCli
//
//  Created by Fancy
//

#import "CCRequest.h"
#import "CCVideoComment.h"
#import "CCVideoCommentController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoCommentRequest : CCRequest

@property (nonatomic, assign) NSInteger videoId;
@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, copy)   NSString  *content;
@property (nonatomic, assign) CCVideoCommentType type;


@end

NS_ASSUME_NONNULL_END
