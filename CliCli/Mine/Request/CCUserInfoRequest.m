//
//  CCUserInfoRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCUserInfoRequest.h"

@implementation CCUserInfoRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        CCUser *user = [CCUser yy_modelWithJSON:request.responseJSONObject[@"data"]];
        !success ? : success(user);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_USER_INFO;
}

@end
