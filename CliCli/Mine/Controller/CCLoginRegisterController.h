//
//  CCLoginRegisterController.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCUI.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CCAccountAction) {
    CCAccountActionLogin,
    CCAccountActionRegister
};

@interface CCLoginRegisterController : CCBaseViewController

- (instancetype)initWithAction:(CCAccountAction)action;

@end

NS_ASSUME_NONNULL_END
