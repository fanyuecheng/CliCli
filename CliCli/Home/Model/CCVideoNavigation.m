//
//  CCVideoNavigation.m
//  CliCli
//
//  Created by Fancy
//

#import "CCVideoNavigation.h"

@interface CCVideoType ()

@property (nonatomic, copy) NSArray *clzArray;
@property (nonatomic, copy) NSArray *areaArray;
@property (nonatomic, copy) NSArray *langArray;
@property (nonatomic, copy) NSArray *yearArray;

@end

@implementation CCVideoType

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"clz" : @"class"};
}

- (NSDictionary *)modelCustomWillTransformFromDictionary:(NSDictionary *)dic {
    NSMutableDictionary *custom = [NSMutableDictionary dictionaryWithDictionary:dic];
    [custom.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = custom[obj];
        if (value.length == 0) {
            [custom removeObjectForKey:obj];
        }
    }];
    
    return custom;
}

- (NSArray *)clzArray {
    if (_clzArray) {
        return _clzArray;
    }
    if (self.clz) {
        _clzArray = [self.clz componentsSeparatedByString:@","];
    }
    return _clzArray ? _clzArray : @[];
}

- (NSArray *)areaArray {
    if (_areaArray) {
        return _areaArray;
    }
    if (self.area) {
        _areaArray = [self.area componentsSeparatedByString:@","];
    }
    return _areaArray ? _areaArray : @[];
}

- (NSArray *)langArray {
    if (_langArray) {
        return _langArray;
    }
    if (self.lang) {
        _langArray = [self.lang componentsSeparatedByString:@","];
    }
    return _langArray ? _langArray : @[];
}

- (NSArray *)yearArray {
    if (_yearArray) {
        return _yearArray;
    }
    if (self.year) {
        _yearArray = [self.year componentsSeparatedByString:@","];
    }
    return _yearArray ? _yearArray : @[];
}

@end

@implementation CCVideoNavigation

+ (CCVideoNavigation *)recommendNavigation {
    CCVideoNavigation *navigation = [[CCVideoNavigation alloc] init];
    navigation.type_name = @"推荐";
    navigation.type_id = -1;
    navigation.custom = YES;
    return navigation;
}

@end
