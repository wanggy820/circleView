//
//  JRCircleView.m
//  TestProject
//
//  Created by wangchunxiang on 2017/4/19.
//  Copyright © 2017年 wangchunxiang. All rights reserved.
//

#import "JRCircleView.h"

@interface JRCircleView()

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger lastPage;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JRCircleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.pagingEnabled = YES;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:YES];
        [self addSubview:self.collectionView];
        
        CGFloat height = 30;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - height, width, height)];
        [self addSubview:self.pageControl];
        self.pageControl.backgroundColor = [UIColor brownColor];
        
        self.needAutoScroll = YES;
        self.interval = 3.0f;
    }
    return self;
}

- (void)dealloc {
    [self timerStop];
}

- (void)timerFire {
    [self timerStop];
    if (!self.needAutoScroll) {
        return;
    }
    if (self.numberOfPages < 2) {
        return;
    }
    if (!self.timer) {
        NSMethodSignature  *signature = [JRCircleView instanceMethodSignatureForSelector:@selector(timerRun)];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        //设置方法调用者
        invocation.target = self;
        invocation.selector = @selector(timerRun);
        //3、调用invoke方法
        [invocation invoke];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval invocation:invocation repeats:YES];
        [self.timer fire];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)timerRun {
//    NSLog(@"%s", __func__);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x+width, 0) animated:YES];
}

- (void)timerStop {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier{
    NSAssert([cellClass isSubclassOfClass:[UICollectionViewCell class]], @"cellClass should isSubclassOfClass UICollectionViewCell");
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndexPage:(NSInteger)indexPage {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:[NSIndexPath indexPathForRow:indexPage inSection:0]];
}

- (void)reloadData {
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:NO];
}

#pragma mark ------------collectionView dataSource--------------------
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.numberOfPages = [self.delegate circleView:self];
    self.pageControl.numberOfPages = self.numberOfPages;
    self.collectionView.scrollEnabled = (self.pageControl.numberOfPages > 1);
    self.pageControl.hidden = (self.pageControl.numberOfPages <= 1);
    [self timerFire];
    return self.numberOfPages + 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSInteger page = indexPath.row - 1;
    if (page < 0) {
        page = self.numberOfPages - 1;
    } else if (page >= self.numberOfPages) {
        page = 0;
    }
    
    UICollectionViewCell *cell = [self.delegate circleView:self cellForItemAtIndexPage:page];
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(circleView:didSelectItemAtIndexPage:)]) {
        [self.delegate circleView:self didSelectItemAtIndexPage:self.currentPage];
    }
}

#pragma mark ------------scrollView delegate--------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.currentPage = (self.collectionView.contentOffset.x - width/2)/width;
    if (self.currentPage >= (self.numberOfPages)) {
        self.currentPage = 0;
    }
    self.pageControl.currentPage = self.currentPage;
    if (scrollView.contentOffset.x <= 0) {
        [self.collectionView setContentOffset:CGPointMake(width*self.numberOfPages, 0) animated:NO];
    }else if(scrollView.contentOffset.x >= (self.numberOfPages*width + width)){
        [self.collectionView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width, 0) animated:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.lastPage == self.currentPage) {
        return;
    }
    self.lastPage = self.currentPage;
    if ([self.delegate respondsToSelector:@selector(circleView:didMoveItemToIndexPage:)]) {
        [self.delegate circleView:self didMoveItemToIndexPage:self.currentPage];
    }
}


@end
