//
//  MBACarScrollerView.m
//  MBACarScrollerView
//
//  Created by mba on 2018/2/28.
//  Copyright © 2018年 cqs. All rights reserved.
//

#import "MBACarScrollerView.h"
#import "MBACarScrollerViewCell.h"

#define cellTag 1000
#define kScrollViewContentOffset kScreenW/3
#define kItemW kScreenW/3

@interface MBACarScrollerView()<UIScrollViewDelegate>

@property (nonatomic, assign, readwrite) NSInteger      currentIndex;
@property (nonatomic, strong, readwrite) UIScrollView   *scrollView;
@property (nonatomic, strong, readwrite) NSMutableArray *items;
@property (nonatomic, assign, readwrite) BOOL           isTapDetected;
@property (nonatomic, assign, readwrite) CGPoint        scrollViewContentOffset;
@end

@implementation MBACarScrollerView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.items = [NSMutableArray array];
    [self setupScrollView];
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:_scrollView];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.delegate = self;
    _scrollView.contentInset = UIEdgeInsetsMake(0, kScrollViewContentOffset, 0, kScrollViewContentOffset);
}


- (void)setCurrentItemIndex:(NSInteger)index
{
    if (index >= 0 && index < self.mArray.count) {
        self.currentIndex = index;
        CGPoint point = CGPointMake(kItemW * index - kScrollViewContentOffset, 0);
        [self.scrollView setContentOffset:point animated:true];
    }
}

-(void)setMArray:(NSMutableArray *)mArray{
    _mArray = mArray;
 
    [self initScrollViewItem];
    [self setCurrentIndex:0];
    
    [self adjustScrollView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

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

- (void)adjustScrollViewItemShow{

    for (int i =0; i<self.items.count; i++) {
        MBACarScrollerViewCell *cell = self.items[i];
        if (i == self.currentIndex) {
            cell.scale = 1.5;
        }else{
            cell.scale = 1;
        }        
    }
}

#pragma mark - Tap Detection

- (void)tapDetected:(UITapGestureRecognizer *)tapGesture
{
    NSInteger tag = tapGesture.view.tag;
    NSInteger index = tag - cellTag;
    [self setCurrentItemIndex:index];
    if ([self.delegate respondsToSelector:@selector(carScroller:didSelectItemAtIndex:)]) {
        [self.delegate carScroller:self didSelectItemAtIndex:index];
        return;
    }
}

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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self adjustScrollViewItemShow];
    [self performSelector:@selector(carScrollerDidEndScrolling) withObject:nil afterDelay:0.1];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self adjustScrollViewItemShow];
    if (!CGPointEqualToPoint(self.scrollViewContentOffset, self.scrollView.contentOffset)) {
        if (self.isTapDetected) {
            self.isTapDetected = NO;
            [self.scrollView setContentOffset:self.scrollViewContentOffset animated:YES];
        }
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self carScrollerDidEndScrolling];
        });
    }
}


#pragma mark - end scrolling handling

- (void)carScrollerDidEndScrolling
{
    if ([self.delegate respondsToSelector:@selector(carScroller:didEndScrollingAtIndex:)]) {
        [self.delegate carScroller:self didEndScrollingAtIndex: self.currentIndex];
    }

}

@end
