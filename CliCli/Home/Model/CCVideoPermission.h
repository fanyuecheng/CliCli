//
//  CCVideoPermission.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoPermission : NSObject

@property (nonatomic, assign) NSInteger play_permission;
@property (nonatomic, assign) NSInteger download_permission;
@property (nonatomic, assign) NSInteger trysee_permission;
@property (nonatomic, assign) NSInteger play_need_permission;
@property (nonatomic, assign) NSInteger download_need_permission;
@property (nonatomic, assign) NSInteger load_advert;
@property (nonatomic, copy)   NSString  *trysee;

@end

NS_ASSUME_NONNULL_END
