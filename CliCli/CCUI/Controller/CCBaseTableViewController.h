//
//  CCBaseTableViewController.h
//  CCUI
//
//  Created by Fancy
//

#import <UIKit/UIKit.h>
#import "CCEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CCBaseTableViewController : UITableViewController

@property (nullable, nonatomic, strong) CCEmptyView *emptyView;

- (void)showEmptyView;
- (void)hideEmptyView;
- (void)layoutEmptyView;

- (void)showEmptyViewWithLoading;
- (void)showEmptyViewWithText:(nullable NSString *)text
                  buttonTitle:(nullable NSString *)buttonTitle
                 buttonAction:(nullable SEL)action;

@end

@interface CCBaseTableViewController (CCUISubclassingHooks)

- (void)initTableView;

- (void)setupNavigationItems;

@end

NS_ASSUME_NONNULL_END
