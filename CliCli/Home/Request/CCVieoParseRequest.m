//
//  CCVieoParseRequest.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVieoParseRequest.h"

@implementation CCVieoParseRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            CCVideoParse *parse = nil;
            if (request.responseJSONObject[@"data"]) {
                NSArray *data = request.responseJSONObject[@"data"];
                parse = [CCVideoParse yy_modelWithJSON:data.firstObject];
            } else {
                parse = [CCVideoParse yy_modelWithJSON:request.responseJSONObject];
            }
            !success ? : success(parse);
        } else {
            !failure ? : failure([NSError errorWithDomain:@"视频解析失败" code:-999 userInfo:nil]);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return [NSString stringWithFormat:@"%@%@", self.parseApi, self.url];
}

@end
