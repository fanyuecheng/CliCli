//
//  UIImage+CCUI.h
//  CCUI
//
//  Created by Fancy
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CCUI)

+ (UIImage *)cc_imageWithSize:(CGSize)size
                       opaque:(BOOL)opaque
                        scale:(CGFloat)scale
                      actions:(void (^)(CGContextRef contextRef))actionBlock;

+ (UIImage *)cc_imageWithColor:(UIColor *)color;

+ (UIImage *)cc_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                  cornerRadius:(CGFloat)cornerRadius;

+ (UIImage *)cc_imageWithView:(UIView *)view;

+ (UIImage *)cc_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates;

+ (UIImage *)cc_imageWithLight:(UIImage *)light dark:(UIImage *)dark;

@end

NS_ASSUME_NONNULL_END
