//
//  CCVideoClearRequest.h
//  CliCli
//
//  Created by Fancy
//

#import "CCRequest.h"
#import "CCVideoListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoClearRequest : CCRequest

@property (nonatomic, assign) CCVideoListType type;

@end

NS_ASSUME_NONNULL_END
