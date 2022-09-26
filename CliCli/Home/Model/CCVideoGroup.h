//
//  CCVideoGroup.h
//  CliCli
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import "CCVideo.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoGroup : NSObject

@property (nonatomic, assign) NSInteger groupId;
@property (nonatomic, assign) NSInteger type_id;
@property (nonatomic, assign) BOOL      has_more;
@property (nonatomic, assign) NSInteger more_req_type;
@property (nonatomic, copy)   NSString  *more_text;
@property (nonatomic, copy)   NSString  *name;
@property (nonatomic, copy)   NSArray <CCVideo *> *vlist;

@end

NS_ASSUME_NONNULL_END
