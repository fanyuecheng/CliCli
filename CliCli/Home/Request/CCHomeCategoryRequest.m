//
//  CCHomeCategoryRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCHomeCategoryRequest.h"
#import "CCVideo.h"

@implementation CCHomeCategoryRequest

- (instancetype)init {
    if (self = [super init]) {
        _page = 1;
    }
    return self;
}

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray <CCVideo *>*data = [NSArray yy_modelArrayWithClass:[CCVideo class] json:request.responseJSONObject[@"data"]];
        NSInteger totalPage = [request.responseJSONObject[@"pagecount"] integerValue];
        !success ? : success(@{@(totalPage) : data});
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return CC_API_HOME_CATEGOTY;
}

- (id)requestArgument {
    NSMutableDictionary *argument = [NSMutableDictionary dictionaryWithDictionary:[super requestArgument]];
    if (self.page) {
        [argument setValue:@(self.page) forKey:@"pg"];
    }
    if (self.tid) {
        [argument setValue:@(self.tid) forKey:@"tid"];
    }
    if (self.type) {
        [argument setValue:self.type forKey:@"class"];
    }
    if (self.area) {
        [argument setValue:self.type forKey:@"area"];
    }
    if (self.language) {
        [argument setValue:self.type forKey:@"lang"];
    }
    if (self.year) {
        [argument setValue:self.year forKey:@"year"];
    }
    return argument;
}

@end
