//
//  EditingSelectedFundCell.m
//  JDMobile
//
//  Created by wangchunxiang on 2017/1/3.
//  Copyright © 2017年 jr. All rights reserved.
//

#import "FundSelectedEditingCell.h"
//#import <AudioToolbox/AudioToolbox.h>

@implementation FundSelectedEditingCell 
{
    UILabel *fundNameLabel;
    UILabel *fundNumLabel;
    CALayer *line;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier]) {
        self.wapper = [[UIView alloc] initWithFrame:CGRectMake(55, 0, 375 - 55 - 103.5, 65)];
        [self addSubview:self.wapper];
        
        fundNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, 375 - 55 - 103.5, 20)];
        fundNameLabel.textColor = [UIColor redColor];
        fundNameLabel.font = [UIFont systemFontOfSize:14];
        [self.wapper addSubview:fundNameLabel];
        
        fundNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, 375 - 55 - 103.5, 14.5)];
        fundNumLabel.textColor = [UIColor grayColor];
        fundNumLabel.font = [UIFont systemFontOfSize:12];
        [self.wapper addSubview:fundNumLabel];
        
        line = [CALayer layer];
        line.frame = CGRectMake(16, 65 - 0.5, 375 -16, 0.5);
        line.backgroundColor = [UIColor purpleColor].CGColor;
        [self.layer addSublayer:line];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


//pragma mark 长按手势方法
- (void)longPressGestureRecognized:(id)sender {
    if (![self.nextResponder.nextResponder isKindOfClass:[UITableView class]]) {
        return;
    }
    UITableView *tableView = (UITableView *)self.nextResponder.nextResponder;
    tableView.scrollEnabled = NO;
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    CGPoint location = [longPress locationInView:self];
    location = CGPointMake(location.x, location.y + self.frame.origin.y);
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:location];
    static UIView       *snapshot = nil;
    static NSIndexPath  *sourceIndexPath = nil;
    
    switch (state) {
            // 已经开始按下
        case UIGestureRecognizerStateBegan: {
            // 判断是不是按在了cell上面
            if (indexPath) {
                sourceIndexPath = indexPath;
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                // 为拖动的cell添加一个快照
                snapshot = [self customSnapshoFromView:self];
                // 添加快照至tableView中
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [tableView addSubview:snapshot];
                // 按下的瞬间执行动画
                [UIView animateWithDuration:0.25 animations:^{
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
            // 移动过程中
        case UIGestureRecognizerStateChanged: {
            // 这里保持数组里面只有最新的两次触摸点的坐标

            CGPoint center = snapshot.center;
            // 快照随触摸点y值移动（当然也可以根据触摸点的y轴移动量来移动）
            center.y = location.y;

            snapshot.center = center;
            
            NSLog(@"%@", NSStringFromCGRect(snapshot.frame));
            // 是否移动了
            if (indexPath && sourceIndexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // 把cell移动至指定行
                [tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // 存储改变后indexPath的值，以便下次比较
                sourceIndexPath = indexPath;
            }
            break;
        }
            // 长按手势取消状态
        default: {
            // 清除操作
            // 清空数组，非常重要，不然会发生坐标突变！
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            // 将快照恢复到初始状态
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            tableView.scrollEnabled = YES;
            break;
        }
    }
    
}

-(void)setAlpha:(CGFloat)alpha
{
    alpha = 1.0;
    [super setAlpha:alpha];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


- (void)renderFundName:(NSString *)fundName fundNum:(NSString *)fundNum isLastRow:(BOOL)isLastRow {
    fundNameLabel.text = fundName;
    fundNumLabel.text = fundNum;
    line.hidden = isLastRow;
}

#pragma mark 创建cell的快照
- (UIView *)customSnapshoFromView:(UIView *)inputView {
    // 用cell的图层生成UIImage，方便一会显示
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 自定义这个快照的样子（下面的一些参数可以自己随意设置）
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.frame = inputView.bounds;
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    snapshot.backgroundColor = [UIColor whiteColor];
    
    return snapshot;
}

@end
