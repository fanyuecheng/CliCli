//
//  NSString+CCAdd.m
//  CCUI
//
//  Created by Fancy 
//

#import "NSString+CCAdd.h"

@implementation NSString (CCSafe)

- (long)cc_longValue {
    return (long)[self integerValue];
}

- (NSNumber *)cc_numberValue {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    return [formatter numberFromString:self];
}

- (CGSize)cc_sizeForFont:(UIFont *)font
                    size:(CGSize)size
                    mode:(NSLineBreakMode)lineBreakMode {
    CGSize result = CGSizeZero;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr
                                         context:nil];
        result = rect.size;
    }
    return result;
}

- (CGFloat)cc_widthForFont:(UIFont *)font {
    CGSize size = [self cc_sizeForFont:font
                                  size:CGSizeMake(HUGE, HUGE)
                                  mode:NSLineBreakByWordWrapping];
    return size.width;
}

- (CGFloat)cc_heightForFont:(UIFont *)font width:(CGFloat)width {
    CGSize size = [self cc_sizeForFont:font
                                  size:CGSizeMake(width, HUGE)
                                  mode:NSLineBreakByWordWrapping];
    return size.height;
}

@end
