//
//  CCIconFont.m
//  AFNetworking
//
//  Created by Fancy
//

#import "CCIconFont.h"
#import "UIImage+CCUI.h"

@interface CCIconFont ()

@end

@implementation CCIconFont

- (instancetype)initWithUnicode:(NSString *)unicode {
    if (self = [super init]) {
        _unicode = unicode;
    }
    return self;
}

+ (CCIconFont *)recordFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8ad"];
}

+ (CCIconFont *)shareFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8b0"];
}

+ (CCIconFont *)memberFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8b1"];
}

+ (CCIconFont *)rankFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8b3"];
}

+ (CCIconFont *)settingFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8b7"];
}

+ (CCIconFont *)downloadFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8b8"];
}

+ (CCIconFont *)collectionFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8b9"];
}

+ (CCIconFont *)homeFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8ba"];
}

+ (CCIconFont *)mineFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e682"];
}

+ (CCIconFont *)eyeFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e666"];
}

+ (CCIconFont *)eyecloseFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e66f"];
}

+ (CCIconFont *)searchFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8bb"];
}

+ (CCIconFont *)topFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e681"];
}

+ (CCIconFont *)commentFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e668"];
}

+ (CCIconFont *)arrowFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e666"];
}

+ (CCIconFont *)deleteFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e665"];
}

+ (CCIconFont *)hotFont {
    return [[CCIconFont alloc] initWithUnicode:@"\U0000e8c9"];
}

- (UIImage *)imageWithColor:(UIColor *)color
                       size:(CGFloat)size {
    UILabel *label = [[UILabel alloc] init];
    UIFont *font = [UIFont fontWithName:@"iconfont" size:size];
    label.font = font;
    if (color) {
        label.textColor = [color resolvedColorWithTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight]];
    }
    label.text = self.unicode;
    [label sizeToFit];
    
    UIImage *light = [UIImage cc_imageWithView:label];
    if (color) {
        label.textColor = [color resolvedColorWithTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark]];
    }
    UIImage *dark = [UIImage cc_imageWithView:label];
    
    return [UIImage cc_imageWithLight:light dark:dark];
}

@end
