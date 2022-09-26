//
//  CCVideoComment.m
//  CliCli
//
//  Created by Fancy 
//

#import "CCVideoComment.h"
#import "NSString+CCAdd.h"
#import "CCUI.h"

@interface CCVideoComment ()

@property (nonatomic, assign) CGFloat rowHeight;

@end

@implementation CCVideoComment

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"reply_list" : @"CCVideoComment"};
}

- (CGFloat)rowHeight {
    if (_rowHeight) {
        return _rowHeight;
    }
    CGFloat rowHeight = 0;
    rowHeight += 15;
    rowHeight += [self.user_name cc_heightForFont:UIFontBoldMake(14) width:CGFLOAT_MAX];
    rowHeight += 10;
    rowHeight += [self.comment_content cc_heightForFont:UIFontMake(13) width:SCREEN_WIDTH - 85];
    rowHeight += 10;
    rowHeight += [self.comment_time cc_heightForFont:UIFontMake(12) width:CGFLOAT_MAX];
    
    CCVideoComment *reply1 = [self.reply_list cc_safeObjectAtIndex:0];
    CCVideoComment *reply2 = [self.reply_list cc_safeObjectAtIndex:1];
    if (reply1) {
        rowHeight += 10 + 20;
        rowHeight += [[NSString stringWithFormat:@"%@：%@", reply1.comment_name, reply1.comment_content] cc_heightForFont:UIFontMake(12) width:SCREEN_WIDTH - 105];
    }
    if (reply2) {
        rowHeight += 5;
        rowHeight += [[NSString stringWithFormat:@"%@：%@", reply2.comment_name, reply2.comment_content] cc_heightForFont:UIFontMake(12) width:SCREEN_WIDTH - 105];
        rowHeight += 5 + 26;
    }
    rowHeight += 15;
    
    _rowHeight = rowHeight;
    return _rowHeight ;
}

@end
