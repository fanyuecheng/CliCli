//
//  NSArray+CCSafe.h
//  CCUI
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CCSafe)

- (id)cc_safeObjectAtIndex:(NSUInteger)index;
- (id)cc_safeObjectAtIndex:(NSUInteger)index class:(Class)aClass;

- (bool)cc_boolAtIndex:(NSUInteger)index;
- (CGFloat)cc_floatAtIndex:(NSUInteger)index;
- (NSInteger)cc_integerAtIndex:(NSUInteger)index;
- (int)cc_intAtIndex:(NSUInteger)index;
- (long)cc_longAtIndex:(NSUInteger)index;
- (NSNumber *)cc_numberAtIndex:(NSUInteger)index;
- (NSString *)cc_stringAtIndex:(NSUInteger)index;
- (NSDictionary *)cc_dictionaryAtIndex:(NSUInteger)index;
- (NSArray *)cc_arrayAtIndex:(NSUInteger)index;
- (NSMutableDictionary *)cc_mutableDictionaryAtIndex:(NSUInteger)index;
- (NSMutableArray *)cc_mutableArrayAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (CCSafe)

- (void)cc_safeAddObject:(id)anObject;
- (void)cc_safeInsertObject:(id)anObject atIndex:(NSUInteger)index;
- (void)cc_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject;
- (void)cc_safeRemoveObjectAtIndex:(NSUInteger)index;
- (void)cc_safeRemoveObject:(id)anObject;

@end

NS_ASSUME_NONNULL_END
