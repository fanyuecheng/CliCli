//
//  UIImage+CCUI.m
//  CCUI
//
//  Created by Fancy
//

#import "UIImage+CCUI.h"
#import "CCUIDefines.h"

@implementation UIImage (CCUI)

+ (UIImage *)cc_imageWithColor:(UIColor *)color {
    return [UIImage cc_imageWithColor:color size:CGSizeMake(4, 4) cornerRadius:0];
}

+ (UIImage *)cc_imageWithColor:(UIColor *)color
                          size:(CGSize)size
                  cornerRadius:(CGFloat)cornerRadius {
    size = CGSizeFlatted(size);
    if (size.width <= 0 ||
        size.height <= 0 ||
        isinf(size.width) ||
        isinf(size.height) ||
        isnan(size.width) ||
        isnan(size.height)) {
        return nil;
    }
    
    color = color ? color : UIColor.clearColor;
    BOOL opaque = (cornerRadius == 0.0);
    UIImage *result = [UIImage cc_imageWithSize:size opaque:opaque scale:0 actions:^(CGContextRef contextRef) {
        CGContextSetFillColorWithColor(contextRef, color.CGColor);
        if (cornerRadius > 0) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
            [path addClip];
            [path fill];
        } else {
            CGContextFillRect(contextRef, CGRectMake(0, 0, size.width, size.height));
        }
    }];
    return result;
}

+ (UIImage *)cc_imageWithSize:(CGSize)size
                       opaque:(BOOL)opaque
                        scale:(CGFloat)scale
                      actions:(void (^)(CGContextRef contextRef))actionBlock {
    if (!actionBlock || size.width <= 0 || size.height <= 0) {
        return nil;
    }
    UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
    format.scale = scale;
    format.opaque = opaque;
    UIGraphicsImageRenderer *render = [[UIGraphicsImageRenderer alloc] initWithSize:size format:format];
    UIImage *imageOut = [render imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextRef context = rendererContext.CGContext;
        actionBlock(context);
    }];
    return imageOut;
}

+ (UIImage *)cc_imageWithView:(UIView *)view {
    CGSize size = view.bounds.size;
    if (size.width <= 0 ||
        size.height <= 0 ||
        isinf(size.width) ||
        isinf(size.height) ||
        isnan(size.width) ||
        isnan(size.height)) {
        return nil;
    }
    return [UIImage cc_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view.layer renderInContext:contextRef];
    }];
}

+ (UIImage *)cc_imageWithView:(UIView *)view afterScreenUpdates:(BOOL)afterUpdates {
    CGSize size = view.bounds.size;
    if (size.width <= 0 ||
        size.height <= 0 ||
        isinf(size.width) ||
        isinf(size.height) ||
        isnan(size.width) ||
        isnan(size.height)) {
        return nil;
    }
    return [UIImage cc_imageWithSize:view.bounds.size opaque:NO scale:0 actions:^(CGContextRef contextRef) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:afterUpdates];
    }];
}

+ (UIImage *)cc_imageWithLight:(UIImage *)light dark:(UIImage *)dark {
    if (@available(iOS 13.0, *)) {
        if (light && dark) {
            UITraitCollection *const scaleTraitCollection = [UITraitCollection currentTraitCollection];
            UITraitCollection *const darkUnscaledTraitCollection = [UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark];
            UITraitCollection *const darkScaledTraitCollection = [UITraitCollection traitCollectionWithTraitsFromCollections:@[scaleTraitCollection, darkUnscaledTraitCollection]];
            UIImage *image = [light imageWithConfiguration:[light.configuration configurationWithTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight]]];
            dark = [dark imageWithConfiguration:[dark.configuration configurationWithTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark]]];
            [image.imageAsset registerImage:dark withTraitCollection:darkScaledTraitCollection];
            return image;
        } else if (light) {
            return light;
        } else if (dark) {
            return dark;
        } else {
            return nil;
        }
    } else {
        return light;
    }
}


@end
