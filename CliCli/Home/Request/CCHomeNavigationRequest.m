//
//  CCHomeNavigationRequest.m
//  CliCli
//
//  Created by Fancy
//

#import "CCHomeNavigationRequest.h"

@implementation CCHomeNavigationRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <CCVideoNavigation *>*data = [NSArray yy_modelArrayWithClass:[CCVideoNavigation class] json:request.responseJSONObject[@"data"]];
        !success ? : success(data);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_HOME_NAVIGATION;
}

@end
