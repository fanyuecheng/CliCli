//
//  UIView+CCLayout.h
//  CCUI
//
//  Created by Fancy
//

#import <UIKit/UIKit.h>
#import "CCUIDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CCLayout)

/// 等价于 CGRectGetMinY(frame)
@property(nonatomic, assign) CGFloat cc_top;

/// 等价于 CGRectGetMinX(frame)
@property(nonatomic, assign) CGFloat cc_left;

/// 等价于 CGRectGetMaxY(frame)
@property(nonatomic, assign) CGFloat cc_bottom;

/// 等价于 CGRectGetMaxX(frame)
@property(nonatomic, assign) CGFloat cc_right;

/// 等价于 CGRectGetWidth(frame)
@property(nonatomic, assign) CGFloat cc_width;

/// 等价于 CGRectGetHeight(frame)
@property(nonatomic, assign) CGFloat cc_height;

/// 等价于 self.frame.size
@property(nonatomic, assign) CGSize cc_size;

@end

NS_ASSUME_NONNULL_END
