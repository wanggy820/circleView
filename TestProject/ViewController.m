//
//  ViewController.m
//  TestProject
//
//  Created by wangchunxiang on 2017/4/13.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import "ViewController.h"
#import "JRCircleView.h"
#import "JDJRCollectionViewCell.h"
#import "XJKBubbleLabel.h"
#import "FundSelectedEditingCell.h"


@interface ViewController ()<JRCircleViewDelegate>

@end

@implementation ViewController

int cc(int a) {
    return ++a;
};



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JRCircleView *circleView = [[JRCircleView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
    [circleView registerClass:[JDJRCollectionViewCell class] forCellWithReuseIdentifier:@"JDJRCollectionViewCell"];
    circleView.delegate = self;
    [self.view addSubview:circleView];
}




- (NSInteger)circleView:(JRCircleView *)circleView {
    return 3;
}

- (UICollectionViewCell *)circleView:(JRCircleView *)circleView cellForItemAtIndexPage:(NSInteger)indexPage {
    JDJRCollectionViewCell *cell = [circleView dequeueReusableCellWithReuseIdentifier:@"JDJRCollectionViewCell" forIndexPage:indexPage];
    if (indexPage%2 == 1) {
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor greenColor];
    }
    cell.label.text = @(indexPage).stringValue;
    cell.label2.text = @(indexPage).stringValue;
    return cell;
}

- (void)circleView:(JRCircleView *)circleView didSelectItemAtIndexPage:(NSInteger)indexPage {
    NSLog(@"%@  %ld", circleView, indexPage);
}

- (void)circleView:(JRCircleView *)circleView didMoveItemToIndexPage:(NSInteger)indexPage {
    NSLog(@">>>>%@  %ld", circleView, indexPage);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
