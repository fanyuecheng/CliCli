//
//  UIView+CCLayout.m
//  CCUI
//
//  Created by Fancy
//

#import "UIView+CCLayout.h"

@implementation UIView (CCLayout)
 
- (CGFloat)cc_top {
    return CGRectGetMinY(self.frame);
}

- (void)setCc_top:(CGFloat)top {
    self.frame = CGRectSetY(self.frame, top);
}

- (CGFloat)cc_left {
    return CGRectGetMinX(self.frame);
}

- (void)setCc_left:(CGFloat)left {
    self.frame = CGRectSetX(self.frame, left);
}

- (CGFloat)cc_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setCc_bottom:(CGFloat)bottom {
    self.frame = CGRectSetY(self.frame, bottom - CGRectGetHeight(self.frame));
}

- (CGFloat)cc_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setCc_right:(CGFloat)right {
    self.frame = CGRectSetX(self.frame, right - CGRectGetWidth(self.frame));
}

- (CGFloat)cc_width {
    return CGRectGetWidth(self.frame);
}

- (void)setCc_width:(CGFloat)width {
    self.frame = CGRectSetWidth(self.frame, width);
}

- (CGFloat)cc_height {
    return CGRectGetHeight(self.frame);
}

- (void)setCc_height:(CGFloat)height {
    self.frame = CGRectSetHeight(self.frame, height);
}

- (CGSize)cc_size {
    return self.frame.size;
}

- (void)setCc_size:(CGSize)ccui_size {
    self.frame = CGRectSetSize(self.frame, ccui_size);
}

@end
