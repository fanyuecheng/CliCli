//
//  CCVideoDownloadOperation.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import "CCVideoDownloadRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoDownloadOperation : NSOperation

@property (nonatomic, copy) void (^finishedBlock)(NSString * _Nullable path, NSError * _Nullable error);
@property (nonatomic, copy) void (^progressBlock)(NSProgress *progress);

@property (nonatomic, strong, readonly) CCVideoDownloadRequest *request;

- (instancetype)initWithVideoId:(NSInteger)videoId
                      videoName:(NSString *)videoName
                       videoURL:(NSString *)videoURL
                         epName:(NSString *)epName;

@end

NS_ASSUME_NONNULL_END
