无限循环轮播

每个页面能复用
子视图继承UICollectionViewCell

JRCircleView *circleView = [[JRCircleView alloc] initWithFrame:CGRectMake(0, 0, 375, 300)];
[circleView registerClass:[JDJRCollectionViewCell class] forCellWithReuseIdentifier:@"JDJRCollectionViewCell"];
circleView.delegate = self;
[self.view addSubview:circleView];


并实现相应的代理方法
