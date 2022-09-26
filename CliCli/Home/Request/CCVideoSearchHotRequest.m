//
//  CCVideoSearchHotRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoSearchHotRequest.h"

@implementation CCVideoSearchHotRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSString *keyString = request.responseJSONObject[@"data"][@"keys"];
        NSArray *keyArray = [keyString componentsSeparatedByString:@","];
        !success ? : success(keyArray);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_VIDEO_SEARCH_HOT;
}

@end
