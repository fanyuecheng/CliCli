//
//  CCUserLoginRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCUserLoginRequest.h"
#import <YTKNetwork/YTKNetworkPrivate.h>

@implementation CCUserLoginRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *data = request.responseJSONObject[@"data"];
        if (data) {
            CCUser *user = [CCUser yy_modelWithJSON:request.responseJSONObject[@"data"]];
            [user saveToLocal];
            [[NSNotificationCenter defaultCenter] postNotificationName:CC_NOTIFICATION_LOGIN_STATUS object:user];
            !success ? : success(user);
        } else {
            !failure ? : failure([NSError errorWithDomain:request.responseJSONObject[@"msg"] code:[request.responseJSONObject[@"code"] integerValue] userInfo:request.responseJSONObject]);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_USER_LOGIN;
}

- (id)requestArgument {
    return @{@"account" : self.account, @"password" : [self md5:self.password]};
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSString *)md5:(NSString *)string {
    return [YTKNetworkUtils md5StringFromString:string];
}

@end
