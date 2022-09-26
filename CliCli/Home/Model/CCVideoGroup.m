//
//  CCVideoGroup.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoGroup.h"

@implementation CCVideoGroup

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"groupId" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"vlist" : @"CCVideo"};
}

@end
