//
//  JDJRCollectionViewCell.m
//  TestProject
//
//  Created by wangchunxiang on 2017/4/19.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import "JDJRCollectionViewCell.h"

@implementation JDJRCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _label.backgroundColor = [UIColor purpleColor];
        [self addSubview:_label];
        
        _label2 = [[UILabel alloc] initWithFrame:CGRectMake(375-100, 0, 100, 100)];
        _label2.backgroundColor = [UIColor purpleColor];
        [self addSubview:_label2];
        
//        NSLog(@"%s", __func__);
    }
    return self;
}

@end
