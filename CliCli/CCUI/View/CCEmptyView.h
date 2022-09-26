//
//  CCEmptyView.h
//  CCUI
//
//  Created by Fancy
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCEmptyView : UIView

@property (nonatomic, strong, readonly) UIView                  *contentView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong, readonly) UILabel                 *titleLabel;
@property (nonatomic, strong, readonly) UIButton                *actionButton;

- (void)showLoading;
- (void)showLoadingWithText:(nullable NSString *)text;
- (void)showText:(nullable NSString *)text;
- (void)showText:(nullable NSString *)text
     actionTitle:(nullable NSString *)title;

@end

NS_ASSUME_NONNULL_END
