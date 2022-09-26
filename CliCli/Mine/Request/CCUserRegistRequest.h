//
//  CCUserRegistRequest.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCUserRegistRequest : CCRequest

@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *inviteCode;

@end

NS_ASSUME_NONNULL_END
