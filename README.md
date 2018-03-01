前言：有需求需要实现卡片式滚动视图，在网上想找此功能的框架，好像没有刚好符合产品的需求。

#### 先上效果图

![b.gif](http://upload-images.jianshu.io/upload_images/1140622-a9ad8c3af082ab12.gif?imageMogr2/auto-orient/strip)

![c.gif](http://upload-images.jianshu.io/upload_images/1140622-3c149d3e7a7cf5de.gif?imageMogr2/auto-orient/strip)

-------------
#### 实现
1. 既然是滚动视图，要嘛用UIcollectionView，要嘛用UIscrollerView。我才用了第二种方式UIscrollerView。主要需要传mArray设置值，可选：delegate代理与setCurrentItemIndex
```
@interface MBACarScrollerView : UIView

@property (nonatomic, assign, readwrite) id<MBACarScrollerViewDelegate> delegate;

- (void)setCurrentItemIndex:(NSInteger)index; //默认已选中0
@property (strong, nonatomic) NSMutableArray *mArray;

@end
```

2. 考虑代理需要回调什么？ 无非就是选中某个item
```
@class MBACarScrollerView;
@protocol MBACarScrollerViewDelegate <NSObject>

@optional
- (void)carScroller:(MBACarScrollerView *)carScroller didSelectItemAtIndex:(NSInteger)index;
- (void)carScroller:(MBACarScrollerView *)carScroller didEndScrollingAtIndex:(NSInteger)index;

@end
```

3. 初始化UIScrollerView后，并不知道真正的contentSize多大，所以在-(void)setMArray:(NSMutableArray *)mArray 里面设置cellItem
```
-(void)setMArray:(NSMutableArray *)mArray{
    _mArray = mArray;
 
    [self initScrollViewItem];
    [self setCurrentIndex:0];
    
    [self adjustScrollView];
}
```

```
-(void)initScrollViewItem{
    NSInteger allCount = self.mArray.count;
    CGFloat itemW = kScreenW/3;
    CGFloat itemH = self.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(itemW *allCount, itemH);
    
    for (int i = 0; i<self.mArray.count; i++) {
        MBACarScrollerViewCell *cell = [[MBACarScrollerViewCell alloc]initWithFrame:CGRectMake(itemW * i, 0, itemW, itemH)];
        cell.tag = 1000 + i;
        [self.scrollView addSubview:cell];
        
        cell.mLabel.text = [NSString stringWithFormat:@"--%d--",i];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        [cell addGestureRecognizer:tapGesture];
        [self.items addObject:cell];
        cell.scale = 1;
    }
}
```

4. cell自动缩放，选中cell放大的效果实现

    4.1  scrollerview代理控制
```
#pragma mark - UIScrollViewDelegate
//cellItem 过度动画
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemW =(int)kItemW;
    NSInteger index = (scrollView.contentOffset.x+ kScrollViewContentOffset + kItemW/2) / itemW;
    index = MIN(self.mArray.count - 1, MAX(0, index));

    if (self.currentIndex != index) {
        self.currentIndex = index;
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(carScrollerDidEndScrolling) object:nil];
    
    [self adjustScrollView];
}

//cellItem 保证居中
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    int itemW =(int)kItemW;
    NSInteger index = (targetContentOffset->x + kScrollViewContentOffset + kItemW/2) / itemW;
    targetContentOffset->x = kItemW * index - kScrollViewContentOffset;
}
```

  4.2  adjustScrollView调整scrollerview
   
```
- (void)adjustScrollView
{
    int itemW =(int)kItemW;
    NSInteger index = self.currentIndex;
    CGFloat scale = (self.scrollView.contentOffset.x  + kScrollViewContentOffset - itemW * self.currentIndex) / itemW;
    if (self.mArray.count > 0) {
        scale = 1 - MIN(1.0, ABS(scale));
        scale = scale + 0.5;
        MBACarScrollerViewCell *cell = self.items[index];
        cell.scale = scale;
    }
}
```

   4.3 MBACarScrollerViewCell 里面控制
```
-(void)setScale:(CGFloat)scale{
    _scale = scale;
    
    
    CGFloat imageViewW = mImageViewW * scale;
    CGFloat itemW = kScreenW /3;
    CGFloat itemH = self.bounds.size.height;
    self.mImageView.frame = CGRectMake(0, 0, imageViewW, imageViewW);
    self.mImageView.center = CGPointMake(itemW/2, itemH/2 - 20);
    self.mImageView.alpha = scale - 0.5;
    
    
    self.mLabel.font = [UIFont systemFontOfSize:30 * (scale -1)];
    [self.mLabel sizeToFit];
    self.mLabel.center = CGPointMake(itemW/2, itemH/2 +imageViewW/2);
    self.mLabel.hidden = !(scale -1);
}
```
