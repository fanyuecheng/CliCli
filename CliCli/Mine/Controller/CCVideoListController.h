//
//  CCVideoListController.h
//  CliCli
//
//  Created by Fancy
//

#import "CCUI.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCVideoListType) {
    CCVideoListTypeHistory,
    CCVideoListTypeCollection
};

@interface CCVideoListController : CCBaseTableViewController

- (instancetype)initWithType:(CCVideoListType)type;

@end

NS_ASSUME_NONNULL_END
