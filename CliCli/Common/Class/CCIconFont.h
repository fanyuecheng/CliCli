//
//  CCIconFont.h
//  AFNetworking
//
//  Created by Fancy
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CCIconFont : NSObject

@property (class, nonatomic, readonly) CCIconFont *recordFont;
@property (class, nonatomic, readonly) CCIconFont *shareFont;
@property (class, nonatomic, readonly) CCIconFont *memberFont;
@property (class, nonatomic, readonly) CCIconFont *rankFont;
@property (class, nonatomic, readonly) CCIconFont *settingFont;
@property (class, nonatomic, readonly) CCIconFont *downloadFont;
@property (class, nonatomic, readonly) CCIconFont *collectionFont;
@property (class, nonatomic, readonly) CCIconFont *homeFont;
@property (class, nonatomic, readonly) CCIconFont *mineFont;
@property (class, nonatomic, readonly) CCIconFont *eyeFont;
@property (class, nonatomic, readonly) CCIconFont *eyecloseFont;
@property (class, nonatomic, readonly) CCIconFont *searchFont;
@property (class, nonatomic, readonly) CCIconFont *topFont;
@property (class, nonatomic, readonly) CCIconFont *commentFont;
@property (class, nonatomic, readonly) CCIconFont *arrowFont;
@property (class, nonatomic, readonly) CCIconFont *deleteFont;
@property (class, nonatomic, readonly) CCIconFont *hotFont;
    
@property (nonatomic, copy, readonly)  NSString *unicode;

- (UIImage *)imageWithColor:(nullable UIColor *)color
                       size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
