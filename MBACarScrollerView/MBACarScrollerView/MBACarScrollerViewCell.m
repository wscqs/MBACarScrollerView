//
//  MBACarScrollerViewCell.m
//  MBACarScrollerView
//
//  Created by mba on 2018/2/28.
//  Copyright © 2018年 cqs. All rights reserved.
//

#import "MBACarScrollerViewCell.h"
#import "MBACarScrollerView.h"

#define mImageViewW 60

@interface MBACarScrollerViewCell()

@end

@implementation MBACarScrollerViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.mImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.mLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:self.mImageView];
    [self addSubview:self.mLabel];
    
    self.mImageView.image = [UIImage imageNamed:@"avator2"];
    self.mLabel.text =  @"1";
    
    self.scale = 1;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


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

@end
