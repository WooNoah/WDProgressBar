//
//  RRMyMaterialProgressBar.h
//  renrenjiekuan
//
//  Created by tb on 17/4/10.
//  Copyright © 2017年 tb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRMyMaterialProgressBar : UIView
//一共项数
@property (nonatomic,assign) CGFloat totalStepsCounts;

@property (nonatomic,strong) CAShapeLayer *firstArc;

@property (nonatomic,strong) CAShapeLayer *secondArc;

@property (nonatomic,strong) CAShapeLayer *thirdArc;

@property (nonatomic,strong) CAShapeLayer *forthArc;

//当前进度
@property (nonatomic,assign) CGFloat currentPercentage;
//渲染颜色
@property (nonatomic,strong) UIColor *progressBarTintColor;

- (instancetype)initWithFrame:(CGRect)frame totalStepsCounts:(CGFloat)steps progressBarTintColor:(UIColor *)tintClr;

@end
