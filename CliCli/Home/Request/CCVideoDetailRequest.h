//
//  CCVideoDetailRequest.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCRequest.h"
#import "CCVideoDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoDetailRequest : CCRequest

@property (nonatomic, assign) NSInteger videoId;

@end

NS_ASSUME_NONNULL_END
