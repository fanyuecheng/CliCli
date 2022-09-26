//
//  NSDictionary+CCSafe.m
//  CCUI
//
//  Created by Fancy 
//

#import "NSDictionary+CCSafe.h"
#import "NSString+CCAdd.h"

@implementation NSDictionary (CCSafe)

- (id)cc_safeObjectForKey:(id)key {
    if (key == nil) {
        return nil;
    }
    id value = [self objectForKey:key];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

- (id)cc_safeObjectForKey:(id)key class:(Class)aClass {
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:aClass]) {
        return value;
    }
    return nil;
}

- (bool)cc_boolForKey:(id)key {
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value boolValue];
    }
    return NO;
}

- (CGFloat)cc_floatForKey:(id)key {
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value floatValue];
    }
    return 0;
}

- (NSInteger)cc_integerForKey:(id)key {
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value integerValue];
    }
    return 0;
}

- (int)cc_intForKey:(id)key {
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value intValue];
    }
    return 0;
}

- (long)cc_longForKey:(id)key{
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [value longValue];
    }
    return 0;
}

- (NSNumber *)cc_numberForKey:(id)key {
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    }
    if ([value respondsToSelector:@selector(cc_numberValue)]) {
        return [value cc_numberValue];
    }
    return nil;
}

- (NSString *)cc_stringForKey:(id)key {
    id value = [self cc_safeObjectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    }
    return nil;
}

- (NSArray *)cc_arrayForKey:(id)key {
    return [self cc_safeObjectForKey:key class:[NSArray class]];
}

- (NSDictionary *)cc_dictionaryForKey:(id)key {
    return [self cc_safeObjectForKey:key class:[NSDictionary class]];
}

- (NSMutableArray *)cc_mutableArrayForKey:(id)key {
    return [self cc_safeObjectForKey:key class:[NSMutableArray class]];
}

- (NSMutableDictionary *)cc_mutableDictionaryForKey:(id)key {
    return [self cc_safeObjectForKey:key class:[NSMutableDictionary class]];
}

@end

@implementation NSMutableDictionary (CCSafe)

- (void)cc_safeSetObject:(id)anObject forKey:(id)key {
    if (key && anObject) {
        [self setObject:anObject forKey:key];
    }
}

- (void)cc_safeRemoveObjectForKey:(id)key {
    if (key) {
        [self removeObjectForKey:key];
    }
}

@end

@implementation NSDictionary (CCLog)

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
    
    [desc appendString:@"{\n"];
    
    // 遍历数组,self就是当前的数组
    for (id key in self.allKeys) {
        id obj = [self objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) {
            [desc appendFormat:@"%@\t%@ = \"%@\";\n", tab, key, obj];
        } else if ([obj isKindOfClass:[NSArray class]]
                   || [obj isKindOfClass:[NSDictionary class]]
                   || [obj isKindOfClass:[NSSet class]]) {
            [desc appendFormat:@"%@\t%@ = %@;\n", tab, key, [obj descriptionWithLocale:locale indent:level + 1]];
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
                    [desc appendFormat:@"%@\t%@ = %@;\n", tab, key, str];
                } else if ([obj isKindOfClass:[NSString class]]) {
                    [desc appendFormat:@"%@\t%@ = \"%@\";\n", tab, key, result];
                }
            } else {
                @try {
                    NSString *str = [[NSString alloc] initWithData:obj encoding:NSUTF8StringEncoding];
                    if (str != nil) {
                        [desc appendFormat:@"%@\t%@ = \"%@\";\n", tab, key, str];
                    } else {
                        [desc appendFormat:@"%@\t%@ = %@;\n", tab, key, obj];
                    }
                }
                @catch (NSException *exception) {
                    [desc appendFormat:@"%@\t%@ = %@;\n", tab, key, obj];
                }
            }
        } else {
            [desc appendFormat:@"%@\t%@ = %@;\n", tab, key, obj];
        }
    }
    
    [desc appendFormat:@"%@}", tab];
    
    return desc;
}

@end
