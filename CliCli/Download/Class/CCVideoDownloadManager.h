//
//  CCVideoDownloadManager.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import "CCVideoDownloadOperation.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoDownloadManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)localPathVideoId:(NSInteger)videoId
                     videoName:(NSString *)videoName
                        epName:(NSString *)epName;

- (CCVideoDownloadOperation *)downloadWithVideoId:(NSInteger)videoId
                                        videoName:(NSString *)videoName
                                         videoURL:(NSString *)videoURL
                                           epName:(NSString *)epName;
- (NSArray *)downloadVideoPathArray;

- (NSString *)downloadRootDirectory;
  
@end

NS_ASSUME_NONNULL_END
