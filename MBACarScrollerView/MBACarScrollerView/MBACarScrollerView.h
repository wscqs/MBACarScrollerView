//
//  MBACarScrollerView.h
//  MBACarScrollerView
//
//  Created by mba on 2018/2/28.
//  Copyright © 2018年 cqs. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenW [[UIScreen mainScreen] bounds].size.width

#define kcarScrollerHeight 125.0

@class MBACarScrollerView;
@protocol MBACarScrollerViewDelegate <NSObject>

@optional
- (void)carScroller:(MBACarScrollerView *)carScroller didSelectItemAtIndex:(NSInteger)index;
- (void)carScroller:(MBACarScrollerView *)carScroller didEndScrollingAtIndex:(NSInteger)index;

@end


@interface MBACarScrollerView : UIView

@property (nonatomic, assign, readwrite) id<MBACarScrollerViewDelegate> delegate;

- (void)setCurrentItemIndex:(NSInteger)index; //默认已选中0
@property (strong, nonatomic) NSMutableArray *mArray;

@end
