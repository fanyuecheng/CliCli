//
//  CCUserAvatarViewController.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCUserAvatarViewController : CCBaseViewController

@property (nonatomic, copy) void (^avatarBlock)(NSString *url);

@end

NS_ASSUME_NONNULL_END
