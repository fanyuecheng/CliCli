//
//  CCHomeCategoryRequest.h
//  CliCli
//
//  Created by Fancy 
//

#import "CCRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCHomeCategoryRequest : CCRequest

@property (nonatomic, copy)   NSString *type;
@property (nonatomic, copy)   NSString *area;
@property (nonatomic, copy)   NSString *language;
@property (nonatomic, copy)   NSString *year;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger tid;

@end

NS_ASSUME_NONNULL_END
