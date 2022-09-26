//
//  CCUserInfoUpdateRequest.m
//  CliCli
//
//  Created by Fancy
//

#import "CCUserInfoUpdateRequest.h"

@implementation CCUserInfoUpdateRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger code = [request.responseJSONObject[@"code"] integerValue];
        if (code == 1) {
            CCUser *user = [CCUser userFromLocal];
            user.user_portrait = self.avatar;
            user.user_nick_name = self.nickName;
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
    return CC_API_USER_INFO_UPDATE;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    if (self.avatar) {
        [argument setObject:self.avatar forKey:@"user_portrait"];
    }
    if (self.nickName) {
        [argument setObject:self.nickName forKey:@"user_nick_name"];
    }
    return argument;
}

@end

