//
//  CCVideoRankRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoRankRequest.h"

@implementation CCVideoRankRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
       NSArray <CCVideoInfo *>*data = [NSArray yy_modelArrayWithClass:[CCVideoInfo class] json:request.responseJSONObject[@"data"]];
       !success ? : success(data);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_VIDEO_RANK;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    [argument setObject:@(1) forKey:@"id"];
    return argument;
}

@end
