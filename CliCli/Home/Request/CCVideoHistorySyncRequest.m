//
//  CCVideoHistorySyncRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoHistorySyncRequest.h"

@implementation CCVideoHistorySyncRequest

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
    return CC_API_VIDEO_HISTORY_SYNC;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    [argument setObject:self.historyList.count ? self.historyList : @[] forKey:@"history_list"];
    return argument;
}


@end
