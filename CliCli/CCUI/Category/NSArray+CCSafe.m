//
//  NSArray+CCSafe.m
//  CCUI
//
//  Created by Fancy 
//

#import "NSArray+CCSafe.h"
#import "NSString+CCAdd.h"

@implementation NSArray (CCSafe)

- (id)cc_safeObjectAtIndex:(NSUInteger)index {
    if (index >= [self count]) {
        return nil;
    }
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

- (id)cc_safeObjectAtIndex:(NSUInteger)index class:(Class)aClass {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:aClass]) {
        return value;
    }
    return nil;
}

- (bool)cc_boolAtIndex:(NSUInteger)index {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}

- (CGFloat)cc_floatAtIndex:(NSUInteger)index {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return 0;
}

- (NSInteger)cc_integerAtIndex:(NSUInteger)index {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    }
    return 0;
}

- (int)cc_intAtIndex:(NSUInteger)index {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (long)cc_longAtIndex:(NSUInteger)index {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longValue];
    }
    return 0;
}

- (NSNumber *)cc_numberAtIndex:(NSUInteger)index {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    if ([value respondsToSelector:@selector(cc_numberValue)]) {
        return [value cc_numberValue];
    }
    return nil;
}

- (NSString *)cc_stringAtIndex:(NSUInteger)index {
    id value = [self cc_safeObjectAtIndex:index];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    }
    return nil;
}

- (NSArray *)cc_arrayAtIndex:(NSUInteger)index {
    return [self cc_safeObjectAtIndex:index class:[NSArray class]];
}

- (NSDictionary *)cc_dictionaryAtIndex:(NSUInteger)index {
    return [self cc_safeObjectAtIndex:index class:[NSDictionary class]];
}

- (NSMutableArray *)cc_mutableArrayAtIndex:(NSUInteger)index {
    return [self cc_safeObjectAtIndex:index class:[NSMutableArray class]];
}

- (NSMutableDictionary *)cc_mutableDictionaryAtIndex:(NSUInteger)index {
    return [self cc_safeObjectAtIndex:index class:[NSMutableDictionary class]];
}

@end

@implementation NSMutableArray (CCSafe)

- (void)cc_safeAddObject:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void)cc_safeInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        [self insertObject:anObject atIndex:index];
    }
}

- (void)cc_safeReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (anObject && index < self.count) {
        [self replaceObjectAtIndex:index withObject:anObject];
    }
}

- (void)cc_safeRemoveObjectAtIndex:(NSUInteger)index {
    if (index < self.count) {
        [self removeObjectAtIndex:index];
    }
}

- (void)cc_safeRemoveObject:(id)anObject {
    if (anObject != nil) {
        [self removeObject:anObject];
    }
}

@end

@implementation NSArray (CCLog)
 
// 取自 DoraemonKit
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; i++) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    [desc appendString:@"(\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@,\n", tab, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    
    [desc appendFormat:@"%@)", tab];
    
    NSRange range = [desc rangeOfString:@",\n" options:NSBackwardsSearch];
    
    if (range.location == NSNotFound) {
        return desc;
    } else {
        return [desc stringByReplacingOccurrencesOfString:@",\n" withString:@"\n" options:NSBackwardsSearch range:range];
    }
}


@end

@implementation NSSet(CCLog)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *desc = [NSMutableString string];
    
    NSMutableString *tabString = [[NSMutableString alloc] initWithCapacity:level];
    for (NSUInteger i = 0; i < level; i++) {
        [tabString appendString:@"\t"];
    }
    
    NSString *tab = @"";
    if (level > 0) {
        tab = tabString;
    }
    [desc appendString:@"{(\n"];
    
    for (id obj in self) {
        if ([obj isKindOfClass:[NSDictionary class]]
            || [obj isKindOfClass:[NSArray class]]
            || [obj isKindOfClass:[NSSet class]]) {
            NSString *str = [((NSDictionary *)obj) descriptionWithLocale:locale indent:level + 1];
            [desc appendFormat:@"%@\t%@,\n", tab, str];
        } else if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t\"%@\",\n", tab, obj];
        } else if ([obj isKindOfClass:[NSData class]]) {
            // 如果是NSData类型，尝试去解析结果，以打印出可阅读的数据
            NSError *error = nil;
            NSObject *result =  [NSJSONSerialization JSONObjectWithData:obj
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&error];
            // 解析成功
            if (error == nil && result != nil) {
                if ([result isKindOfClass:[NSDictionary class]]
                    || [result isKindOfClass:[NSArray class]]
                    || [result isKindOfClass:[NSSet class]]) {
                    NSString *str = [((NSDictionary *)result) descriptionWithLocale:locale indent:level + 1];
                    [desc appendFormat:@"%@\t%@,\n", tab, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t\"%@\",\n", tab, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t\"%@\",\n", tab, str];
                    } else {
                        [desc appendFormat:@"%@\t%@,\n", tab, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@,\n", tab, obj];
                }
            }
        } else {
            [desc appendFormat:@"%@\t%@,\n", tab, obj];
        }
    }
    
    [desc appendFormat:@"%@)}", tab];
    
    NSRange range = [desc rangeOfString:@",\n" options:NSBackwardsSearch];
    
    if (range.location == NSNotFound) {
        return desc;
    } else {
        return [desc stringByReplacingOccurrencesOfString:@",\n" withString:@"\n" options:NSBackwardsSearch range:range];
    }
}


@end
