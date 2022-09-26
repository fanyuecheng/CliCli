//
//  CCVideoDetail.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import "CCVideoInfo.h"
#import "CCVideoHistory.h"
#import "CCVideoPermission.h"
#import "CCVideoAdvert.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoDetail : NSObject

@property (nonatomic, strong) CCVideoInfo    *vod_info;
@property (nonatomic, strong) CCVideoHistory *vod_history;
@property (nonatomic, strong) CCVideoPermission *permission_info;
@property (nonatomic, strong) CCVideoAdvert   *advert_info;
@property (nonatomic, assign) BOOL           is_collect;
@property (nonatomic, assign) NSInteger      comment_count;

@end

NS_ASSUME_NONNULL_END
