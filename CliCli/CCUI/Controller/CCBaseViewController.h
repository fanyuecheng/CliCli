//
//  CCBaseViewController.h
//  CCUI
//
//  Created by Fancy
//

#import <UIKit/UIKit.h>
#import "CCEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCBaseViewController : UIViewController

@property (nullable, nonatomic, strong) CCEmptyView *emptyView;

- (void)didInitialize NS_REQUIRES_SUPER;

- (void)showEmptyView;
- (void)hideEmptyView;
- (void)layoutEmptyView;

- (void)showEmptyViewWithLoading;
- (void)showEmptyViewWithText:(nullable NSString *)text
                  buttonTitle:(nullable NSString *)buttonTitle
                 buttonAction:(nullable SEL)action;


@end

@interface CCBaseViewController (CCUISubclassingHooks)

- (void)initSubviews NS_REQUIRES_SUPER;

- (void)setupNavigationItems NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
