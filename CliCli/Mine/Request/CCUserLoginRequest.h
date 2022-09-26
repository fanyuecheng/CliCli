//
//  CCUserLoginRequest.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCRequest.h"
#import "CCUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCUserLoginRequest : CCRequest

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;

@end

NS_ASSUME_NONNULL_END
