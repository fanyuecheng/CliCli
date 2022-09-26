//
//  NSDictionary+CCSafe.h
//  CCUI
//
//  Created by Fancy 
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN
 

@interface NSDictionary (CCSafe)

- (id)cc_safeObjectForKey:(id)key;
- (id)cc_safeObjectForKey:(id)key class:(Class)aClass;

- (bool)cc_boolForKey:(id)key;
- (CGFloat)cc_floatForKey:(id)key;
- (NSInteger)cc_integerForKey:(id)key;
- (int)cc_intForKey:(id)key;
- (long)cc_longForKey:(id)key;
- (NSNumber *)cc_numberForKey:(id)key;
- (NSString *)cc_stringForKey:(id)key;
- (NSDictionary *)cc_dictionaryForKey:(id)key;
- (NSArray *)cc_arrayForKey:(id)key;
- (NSMutableDictionary *)cc_mutableDictionaryForKey:(id)key;
- (NSMutableArray *)cc_mutableArrayForKey:(id)key;

@end

@interface NSMutableDictionary (CCSafe)

- (void)cc_safeSetObject:(id)anObject forKey:(id)key;
- (void)cc_safeRemoveObjectForKey:(id)key;

@end
NS_ASSUME_NONNULL_END
