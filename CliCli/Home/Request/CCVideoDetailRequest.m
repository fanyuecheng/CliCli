//
//  CCVideoDetailRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoDetailRequest.h"

@implementation CCVideoDetailRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        CCVideoDetail *detail = [CCVideoDetail yy_modelWithJSON:request.responseJSONObject[@"data"]];
        !success ? : success(detail);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_VIDEO_DETAIL;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    if (self.videoId) {
        [argument setValue:@(self.videoId) forKey:@"id"];
    }
    return argument;
}

@end
