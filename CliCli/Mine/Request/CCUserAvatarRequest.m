//
//  CCUserAvatarRequest.m
//  CliCli
//
//  Created by Fancy
//

#import "CCUserAvatarRequest.h"

@implementation CCUserAvatarRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *data = [NSArray yy_modelArrayWithClass:[CCUserAvatar class] json:request.responseJSONObject[@"data"]];
        !success ? : success(data);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_USER_AVATAR;
}

@end
