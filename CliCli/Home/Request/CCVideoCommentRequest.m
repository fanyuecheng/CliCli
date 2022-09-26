//
//  CCVideoCommentRequest.m
//  CliCli
//
//  Created by Fancy
//

#import "CCVideoCommentRequest.h"

@implementation CCVideoCommentRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger code = [request.responseJSONObject[@"code"] integerValue];
        if (code == 1 || code == 3) {
            !success ? : success(request.responseJSONObject);
        } else {
            !failure ? : failure([NSError errorWithDomain:request.responseJSONObject[@"msg"] code:[request.responseJSONObject[@"code"] integerValue] userInfo:request.responseJSONObject]);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return self.type == CCVideoCommentTypeVideo ? CC_API_VIDEO_COMMENT_SAVE : CC_API_VIDEO_REPLY_SAVE;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    if (self.content) {
        [argument setObject:self.content forKey:@"content"];
    }
    if (self.videoId) {
        [argument setObject:@(self.videoId) forKey:@"vid"];
    }
    if (self.commentId) {
        [argument setObject:@(self.commentId) forKey:@"pid"];
    }
    return argument;
}
 
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end
