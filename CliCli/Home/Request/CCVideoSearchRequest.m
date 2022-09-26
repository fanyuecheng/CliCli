//
//  CCVideoSearchRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoSearchRequest.h"

@implementation CCVideoSearchRequest

- (instancetype)init {
    if (self = [super init]) {
        self.page = 1;
    }
    return self;
}

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
    return self.type == CCVideoSearchTypeDefault ? CC_API_VIDEO_SEARCH : CC_API_VIDEO_SEARCH_TOPIC;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    [argument setObject:@(self.page) forKey:@"pg"];
    [argument setObject:self.searchKey ? self.searchKey : @"" forKey:@"text"];
    return argument;
}


@end
