//
//  EditingSelectedFundCell.h
//  JDMobile
//
//  Created by wangchunxiang on 2017/1/3.
//  Copyright © 2017年 jr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FundSelectedEditingCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *wapper;
- (void)renderFundName:(NSString *)fundName fundNum:(NSString *)fundNum  isLastRow:(BOOL)isLastRow;

@end
