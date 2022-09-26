//
//  CCModalView.h
//  CliCli
//
//  Created by Fancy 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCModalView : UIView

@property (nonatomic, strong) UILabel   *titleLabel;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIView    *customView;
@property (nonatomic, copy)   void (^closeBlock)(CCModalView *view);

- (void)didInitialize;

@end

NS_ASSUME_NONNULL_END
