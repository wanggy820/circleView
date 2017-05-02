//
//  XJKBubbleLabel.m
//  TestProject
//
//  Created by wangchunxiang on 2017/4/20.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import "XJKBubbleLabel.h"

@implementation XJKBubbleLabel
{
    UIBezierPath *bezierPath;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.adjustsFontSizeToFitWidth = YES;
        
    }
    return self;
}

- (void)setText:(NSString *)text {
    if ([text isEqualToString:super.text]) {
        return;
    }
    
    [super setText:text];
    
    CGFloat width = [text boundingRectWithSize:CGSizeMake(1000, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size.width;
    if (width > ([UIScreen mainScreen].bounds.size.width - 32)) {
        width = [UIScreen mainScreen].bounds.size.width - 32;
    }
    CGRect frame = self.frame;
    frame.size.width = width + 20;
    frame.origin.x = [UIScreen mainScreen].bounds.size.width - 16 - width;
    self.frame = frame;
    
    if (bezierPath) {
        [bezierPath removeAllPoints];
    } else {
        bezierPath = [UIBezierPath bezierPath];
    }
    
    
}


@end
