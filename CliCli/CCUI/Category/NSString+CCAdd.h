//
//  NSString+CCAdd.h
//  CCUI
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CCAdd)

- (long)cc_longValue;

- (NSNumber *)cc_numberValue;

- (CGSize)cc_sizeForFont:(UIFont *)font
                    size:(CGSize)size
                    mode:(NSLineBreakMode)lineBreakMode;

- (CGFloat)cc_widthForFont:(UIFont *)font;

- (CGFloat)cc_heightForFont:(UIFont *)font width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
