//
//  ViewController.m
//  MBACarScrollerView
//
//  Created by mba on 2018/2/28.
//  Copyright © 2018年 cqs. All rights reserved.
//

#import "ViewController.h"
#import "MBACarScrollerView.h"

@interface ViewController ()<MBACarScrollerViewDelegate>
@property (strong, nonatomic) MBACarScrollerView *mCarScrollerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.mCarScrollerView = [[MBACarScrollerView alloc]initWithFrame:CGRectMake(0, 100, kScreenW, 150)];
    [self.view addSubview:self.mCarScrollerView];
    
//    self.mCarScrollerView.mArray = @[@"1",@"2",@"3",@"4",@"5",@"6"];
    self.mCarScrollerView.mArray = @[@"1",@"2"];

    
    self.mCarScrollerView.delegate = self;
//    [self.mCarScrollerView setCurrentItemIndex:3];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)carScroller:(MBACarScrollerView *)carScroller didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"index--%ld",index);
}

-(void)carScroller:(MBACarScrollerView *)carScroller didEndScrollingAtIndex:(NSInteger)index{
    NSLog(@"index--%ld",index);
}


@end
