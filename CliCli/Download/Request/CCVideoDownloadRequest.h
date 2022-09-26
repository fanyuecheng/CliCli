//
//  CCVideoDownloadRequest.h
//  CliCli
//
//  Created by Fancy on 2022/8/30.
//

#import "CCRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoDownloadRequest : CCRequest

@property (nonatomic, copy) NSString *videoURL;
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *videoId;
@property (nonatomic, copy) NSString *epName;

@end

NS_ASSUME_NONNULL_END
