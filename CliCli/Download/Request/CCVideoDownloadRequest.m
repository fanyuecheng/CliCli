//
//  CCVideoDownloadRequest.m
//  CliCli
//
//  Created by Fancy on 2022/8/30.
//

#import "CCVideoDownloadRequest.h"

@implementation CCVideoDownloadRequest

- (void)sendRequest:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure {
    [super sendRequest:success failure:failure];
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"%@", request.responseObject);
        !success ? : success(request.responseObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        !failure ? : failure(request.error);
    }];
}

- (NSString *)requestUrl {
    return self.videoURL;  
}

- (NSString *)resumableDownloadPath {
    NSString *cacheDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    return [cacheDir stringByAppendingPathComponent:[NSString stringWithFormat:@"CCVideo/%@_%@/%@.%@", self.videoId, self.videoName, self.epName, self.videoURL.pathExtension]];
}

@end
