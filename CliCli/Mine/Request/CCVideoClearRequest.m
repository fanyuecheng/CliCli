//
//  CCVideoCollectionClearRequest.m
//  CliCli
//
//  Created by Fancy
//

#import "CCVideoClearRequest.h"

@implementation CCVideoClearRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger code = [request.responseJSONObject[@"code"] integerValue];
        if (code == 1) {
            !success ? : success(request.responseJSONObject);
        } else {
            !failure ? : failure([NSError errorWithDomain:request.responseJSONObject[@"msg"] code:[request.responseJSONObject[@"code"] integerValue] userInfo:request.responseJSONObject]);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return self.type == CCVideoListTypeHistory ? CC_API_VIDEO_HISTORY_CLEAR : CC_API_VIDEO_COLLECTION_CLEAR;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end
