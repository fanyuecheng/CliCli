//
//  CCUserRegistRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCUserRegistRequest.h"

@implementation CCUserRegistRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger code = [request.responseJSONObject[@"code"] integerValue];
        if (code == 1) {
            !success ? : success(@{@"account" : self.account, @"password" : self.password});
        } else {
            !failure ? : failure([NSError errorWithDomain:request.responseJSONObject[@"msg"] code:[request.responseJSONObject[@"code"] integerValue] userInfo:request.responseJSONObject]);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_USER_REGIST_NAME;
}

- (id)requestArgument {
    return @{@"username" : self.account,
             @"password" : self.password,
             @"invite_code" : self.inviteCode ? self.inviteCode : @""};
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end
