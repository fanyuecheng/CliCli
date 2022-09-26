//
//  CCUserLogoutRequest.m
//  CliCli
//
//  Created by Fancy
//

#import "CCUserLogoutRequest.h"

@implementation CCUserLogoutRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger code = [request.responseJSONObject[@"code"] integerValue];
        if (code == 1) {
            [CCUser deleteFromLocal];
            [[NSNotificationCenter defaultCenter] postNotificationName:CC_NOTIFICATION_LOGIN_STATUS object:nil];
            !success ? : success(request.responseJSONObject);
        } else {
            !failure ? : failure([NSError errorWithDomain:request.responseJSONObject[@"msg"] code:[request.responseJSONObject[@"code"] integerValue] userInfo:request.responseJSONObject]);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_USER_LOGOUT;
}
 
- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end
