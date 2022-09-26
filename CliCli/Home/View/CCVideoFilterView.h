//
//  CCVideoFilterView.h
//  CliCli
//
//  Created by Fancy 
//

#import <UIKit/UIKit.h>
#import "CCVideoNavigation.h"

NS_ASSUME_NONNULL_BEGIN
 
@interface CCVideoFilterView : UIView

@property (nonatomic, strong) CCVideoType *type;
@property (nonatomic, copy)   void (^filterBlock)(NSInteger index, NSString *value);

- (instancetype)initWithType:(CCVideoType *)type;

@end

NS_ASSUME_NONNULL_END
