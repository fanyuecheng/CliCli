//
//  CCVideoListRequest.m
//  CliCli
//
//  Created by Fancy
//

#import "CCVideoListRequest.h"

@implementation CCVideoListRequest

- (instancetype)init {
    if (self = [super init]) {
        self.page = 1;
    }
    return self;
}

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray *data = nil;
        if (self.type == CCVideoListTypeHistory) {
            data = [NSArray yy_modelArrayWithClass:[CCVideoHistory class] json:request.responseJSONObject[@"data"]];
        } else {
            data = [NSArray yy_modelArrayWithClass:[CCVideoInfo class] json:request.responseJSONObject[@"data"]];
        }
        !success ? : success(data);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return self.type == CCVideoListTypeHistory ? CC_API_VIDEO_HISTORY_LIST : CC_API_VIDEO_COLLECTION_LIST;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    if (self.page) {
        [argument setObject:@(self.page) forKey:@"pg"];
    }
    return argument;
}

@end
