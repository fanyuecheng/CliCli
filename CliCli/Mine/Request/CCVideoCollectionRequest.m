//
//  CCVideoCollectionRequest.m
//  CliCli
//
//  Created by Fancy  
//

#import "CCVideoCollectionRequest.h"

@implementation CCVideoCollectionRequest

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
    return self.operation == 0 ? CC_API_VIDEO_COLLECTION_SAVE : CC_API_VIDEO_COLLECTION_CANCEL;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    if (self.videoId) {
        [argument setObject:@(self.videoId) forKey:@"vod_id"];
    }
    return argument;
}

@end
