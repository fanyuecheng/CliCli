//
//  CCVideoCommentListRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoCommentListRequest.h"

@implementation CCVideoCommentListRequest

- (instancetype)init {
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <CCVideoComment *>*data = [NSArray yy_modelArrayWithClass:[CCVideoComment class] json:request.responseJSONObject[@"data"]];
        !success ? : success(data);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return self.type == CCVideoCommentTypeVideo ? CC_API_VIDEO_COMMENT : CC_API_VIDEO_REPLY;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    [argument setObject:@(self.page) forKey:@"pg"];
    if (self.videoId) {
        [argument setObject:@(self.videoId) forKey:@"vid"];
    }
    if (self.commentId) {
        [argument setObject:@(self.commentId) forKey:@"pid"];
    }
    return argument;
}
 
@end
