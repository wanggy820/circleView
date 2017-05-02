//
//  JRCircleView.h
//  TestProject
//
//  Created by wangchunxiang on 2017/4/19.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRCircleView;

@protocol JRCircleViewDelegate <NSObject>

@required
/**
 返回几个cell

 @param circleView <#circleView description#>
 @return cell个数
 */
- (NSInteger)circleView:(JRCircleView *)circleView;
- (UICollectionViewCell *)circleView:(JRCircleView *)circleView cellForItemAtIndexPage:(NSInteger )indexPage;

@optional
- (void)circleView:(JRCircleView *)circleView didSelectItemAtIndexPage:(NSInteger )indexPage;
- (void)circleView:(JRCircleView *)circleView didMoveItemToIndexPage:(NSInteger )indexPage;

@end

@interface JRCircleView : UIView <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

//是否允许自动滚动 默认允许自动滚动
@property (nonatomic, assign) BOOL needAutoScroll;

/**
 时间间隔  默认 3s
 */
@property (nonatomic, assign) NSTimeInterval interval;
@property (assign, nonatomic) NSInteger numberOfPages;
@property (assign, nonatomic) NSInteger currentPage;

@property (nonatomic, weak) id<JRCircleViewDelegate> delegate;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPage:(NSInteger)indexPage;
- (void)reloadData;

@end
