//
//  CCVideoListRequest.h
//  CliCli
//
//  Created by Fancy
//

#import "CCRequest.h"
#import "CCVideoInfo.h"
#import "CCVideoHistory.h" 
#import "CCVideoListController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoListRequest : CCRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) CCVideoListType type;

@end

NS_ASSUME_NONNULL_END
