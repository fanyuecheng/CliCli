//
//  CCVideoNavigation.h
//  CliCli
//
//  Created by Fancy
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCVideoType : NSObject

@property (nonatomic, copy) NSString *clz;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *lang;
@property (nonatomic, copy) NSString *year;
@property (nonatomic, copy) NSString *star;
@property (nonatomic, copy) NSString *director;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy, readonly) NSArray *clzArray;
@property (nonatomic, copy, readonly) NSArray *areaArray;
@property (nonatomic, copy, readonly) NSArray *langArray;
@property (nonatomic, copy, readonly) NSArray *yearArray;

@end

@interface CCVideoNavigation : NSObject

@property (nonatomic, assign) NSInteger type_id;
@property (nonatomic, copy)   NSString  *type_name;
@property (nonatomic, strong) CCVideoType *type_extend;
@property (nonatomic, assign, getter=isCustom) BOOL custom;

+ (CCVideoNavigation *)recommendNavigation;

@end

NS_ASSUME_NONNULL_END
