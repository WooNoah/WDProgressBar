//
//  RRMyMaterialProgressBar.m
//  renrenjiekuan
//
//  Created by tb on 17/4/10.
//  Copyright © 2017年 tb. All rights reserved.
//

#import "RRMyMaterialProgressBar.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RandomColor [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:1]

@interface RRMyMaterialProgressBar()

@property (nonatomic,strong) CALayer *backColorLayer;

@property (nonatomic,strong) CAShapeLayer *middleDarkArcLayer;

@property (nonatomic,strong) CAShapeLayer *foregroundMaskLayer;

//上一次的比例
@property (nonatomic,assign) CGFloat lastPercentage;

@end

@implementation RRMyMaterialProgressBar

- (instancetype)initWithFrame:(CGRect)frame totalStepsCounts:(CGFloat)steps progressBarTintColor:(UIColor *)tintClr{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.progressBarTintColor = tintClr;
        self.totalStepsCounts = steps;
        [self setupSubLayersWithFrame:frame];
        
    }
    return self;
}


- (void)setupSubLayersWithFrame:(CGRect)rect {
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    
    //左右两侧的距离
    CGFloat padding = 10.f;
    //外圆的半径
    CGFloat arcRadius = 7.f;
    //中间线的线宽
    CGFloat middleLineWidth = 1.f;
    //内层圆按钮半径
    CGFloat innerArcRadius = 4.f;
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    
    
    double arcSinValue = middleLineWidth/arcRadius;
    double radian = asin(arcSinValue);
    
    double tanValue = tan(radian);
    
    CGFloat arcTanLength = middleLineWidth/tanValue;
    
    CGFloat middleLineDistance = (viewWidth - 2 * padding - arcRadius * 2 - (self.totalStepsCounts * 2 - 2) * arcTanLength)/(self.totalStepsCounts - 1);
    
    
    self.middleDarkArcLayer = [CAShapeLayer layer];
    UIBezierPath *middleDrakColorPath = [UIBezierPath bezierPath];
    [middleDrakColorPath moveToPoint:CGPointMake(padding, viewHeight/2)];
    [middleDrakColorPath addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:arcRadius startAngle:M_PI endAngle:2*M_PI - radian clockwise:YES];
    [middleDrakColorPath addLineToPoint:CGPointMake(padding + arcRadius +arcTanLength + middleLineDistance, viewHeight/2 - middleLineWidth/2)];
    [middleDrakColorPath addArcWithCenter:CGPointMake(padding + arcRadius +arcTanLength * 2 + middleLineDistance, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:2 * M_PI - radian clockwise:YES];
    [middleDrakColorPath addLineToPoint:CGPointMake(padding + arcRadius + 3 * arcTanLength + middleLineDistance * 2, viewHeight/2 - middleLineWidth/2)];
    [middleDrakColorPath addArcWithCenter:CGPointMake(padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:2 * M_PI - radian clockwise:YES];
    [middleDrakColorPath addLineToPoint:CGPointMake(padding + arcRadius + 5 * arcTanLength + middleLineDistance * 3, viewHeight/2 - middleLineWidth/2)];
    [middleDrakColorPath addArcWithCenter:CGPointMake(padding + arcRadius + 6 * arcTanLength + middleLineDistance * 3, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:3 * M_PI - radian clockwise:YES];
    [middleDrakColorPath addLineToPoint:CGPointMake(padding + arcRadius + 5 * arcTanLength + middleLineDistance * 2, viewHeight/2 + middleLineWidth/2)];
    [middleDrakColorPath addArcWithCenter:CGPointMake(padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
    [middleDrakColorPath addLineToPoint:CGPointMake(padding + arcRadius + 3 * arcTanLength + middleLineDistance, viewHeight/2 + middleLineWidth/2)];
    [middleDrakColorPath addArcWithCenter:CGPointMake(padding + arcRadius + 2 * arcTanLength + middleLineDistance, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
    [middleDrakColorPath addLineToPoint:CGPointMake(padding + arcRadius + arcTanLength, viewHeight/2 + middleLineWidth/2)];
    [middleDrakColorPath addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
    [middleDrakColorPath closePath];
    
    self.middleDarkArcLayer.fillColor = RGB(203, 204, 205).CGColor;
    self.middleDarkArcLayer.path = middleDrakColorPath.CGPath;
    [self.layer addSublayer:self.middleDarkArcLayer];

    
    //MARK: 颜色层layer
    self.backColorLayer = [CALayer layer];
    self.backColorLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
    self.backColorLayer.backgroundColor = self.progressBarTintColor.CGColor;
    self.backColorLayer.position = CGPointMake(0, viewHeight/2);
    self.backColorLayer.anchorPoint = CGPointMake(0, 0.5);
    [self.layer addSublayer:self.backColorLayer];
    
 
    self.foregroundMaskLayer = [CAShapeLayer layer];
    //MARK: 使用UIBezierPath 绘制遮挡VIEW的路径
    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, rect.size.width, rect.size.height) cornerRadius:rect.size.height/2];
    
    UIBezierPath *colorPath = [UIBezierPath bezierPath];
    [colorPath moveToPoint:CGPointMake(padding, viewHeight/2)];
    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:arcRadius startAngle:M_PI endAngle:2*M_PI - radian clockwise:YES];
    [colorPath addLineToPoint:CGPointMake(padding + arcRadius +arcTanLength + middleLineDistance, viewHeight/2 - middleLineWidth/2)];
    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius +arcTanLength * 2 + middleLineDistance, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:2 * M_PI - radian clockwise:YES];
    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 3 * arcTanLength + middleLineDistance * 2, viewHeight/2 - middleLineWidth/2)];
    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:2 * M_PI - radian clockwise:YES];
    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 5 * arcTanLength + middleLineDistance * 3, viewHeight/2 - middleLineWidth/2)];
    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 6 * arcTanLength + middleLineDistance * 3, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:3 * M_PI - radian clockwise:YES];
    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 5 * arcTanLength + middleLineDistance * 2, viewHeight/2 + middleLineWidth/2)];
    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 3 * arcTanLength + middleLineDistance, viewHeight/2 + middleLineWidth/2)];
    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 2 * arcTanLength + middleLineDistance, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + arcTanLength, viewHeight/2 + middleLineWidth/2)];
    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
    
    [outerPath appendPath:colorPath];
    [outerPath setUsesEvenOddFillRule:YES];

    
    self.foregroundMaskLayer.path = outerPath.CGPath;
    self.foregroundMaskLayer.fillRule = kCAFillRuleEvenOdd;
    self.foregroundMaskLayer.fillColor = RGB(221, 221, 221).CGColor;
    [self.layer addSublayer:self.foregroundMaskLayer];

    //MARK: 第一个内部圆
    self.firstArc = [CAShapeLayer layer];
    UIBezierPath *arcPath1 = [UIBezierPath bezierPath];
    [arcPath1 addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
    self.firstArc.path = arcPath1.CGPath;
    self.firstArc.fillColor = RGB(221, 221, 221).CGColor;
    [self.layer addSublayer:self.firstArc];
    
    
    //MARK: 第二个内部圆
    self.secondArc = [CAShapeLayer layer];
    UIBezierPath *arcPath2 = [UIBezierPath bezierPath];
    [arcPath2 addArcWithCenter:CGPointMake(padding + arcRadius + arcTanLength + middleLineDistance + arcTanLength, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
    self.secondArc.path = arcPath2.CGPath;
    self.secondArc.fillColor = RGB(221, 221, 221).CGColor;
    [self.layer addSublayer:self.secondArc];
    
    
    //MARK: 第三个内部圆
    self.thirdArc = [CAShapeLayer layer];
    UIBezierPath *arcPath3 = [UIBezierPath bezierPath];
    [arcPath3 addArcWithCenter:CGPointMake(padding + arcRadius + arcTanLength + middleLineDistance + arcTanLength + arcTanLength + middleLineDistance + arcTanLength, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
    self.thirdArc.path = arcPath3.CGPath;
    self.thirdArc.fillColor = RGB(221, 221, 221).CGColor;
    [self.layer addSublayer:self.thirdArc];
    
    
    //MARK: 第四个内部圆
    self.forthArc = [CAShapeLayer layer];
    UIBezierPath *arcPath4 = [UIBezierPath bezierPath];
    [arcPath4 addArcWithCenter:CGPointMake(padding + arcRadius + arcTanLength + middleLineDistance + arcTanLength + arcTanLength + middleLineDistance + arcTanLength + arcTanLength + middleLineDistance + arcTanLength, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
    self.forthArc.path = arcPath4.CGPath;
    self.forthArc.fillColor = RGB(221, 221, 221).CGColor;
    [self.layer addSublayer:self.forthArc];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
////    self.layer.backgroundColor = RGB(204, 204, 204).CGColor;
//    self.layer.backgroundColor = [UIColor redColor].CGColor;
//    
//    //左右两侧的距离
//    static const CGFloat padding = 10.f;
//    //外圆的半径
//    static const CGFloat arcRadius = 7.f;
//    //中间线的线宽
//    static const CGFloat middleLineWidth = 1.f;
//    //内层圆按钮半径
//    static const CGFloat innerArcRadius = 4.f;
//    CGFloat viewWidth = rect.size.width;
//    CGFloat viewHeight = rect.size.height;
//    
//    
//    //MARK: 底层layer
//    self.backColorLayer = [CAShapeLayer layer];
//    self.backColorLayer.frame = CGRectMake(0, 0, viewWidth, viewHeight);
//    self.backColorLayer.fillColor = self.progressBarTintColor.CGColor;
//    self.backColorLayer.position = CGPointMake(0, viewHeight/2);
//    self.backColorLayer.anchorPoint = CGPointMake(0, 0.5);
//    UIBezierPath *backPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:viewHeight/2];
//    self.backColorLayer.path = backPath.CGPath;
//    [self.layer addSublayer:self.backColorLayer];
//
//    
//    double arcSinValue = middleLineWidth/arcRadius;
//    double radian = asin(arcSinValue);
//    
//    double tanValue = tan(radian);
//    
//    CGFloat arcTanLength = middleLineWidth/tanValue;
//    
//    CGFloat middleLineDistance = (viewWidth - 2 * padding - arcRadius * 2 - (self.totalStepsCounts * 2 - 2) * arcTanLength)/(self.totalStepsCounts - 1);
//
// 
//    //MAKR: 使用Core Graphics开始绘图
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(ctx, padding, viewHeight/2);
//    CGContextAddArc(ctx, padding + arcRadius, viewHeight/2, arcRadius, M_PI, 2*M_PI - radian , 0);
//    CGContextAddLineToPoint(ctx, padding + arcRadius +arcTanLength + middleLineDistance, viewHeight/2 - middleLineWidth/2);
//    CGContextAddArc(ctx, padding + arcRadius +arcTanLength * 2 + middleLineDistance, viewHeight/2, arcRadius, M_PI + radian, 2 * M_PI - radian, 0);
//    CGContextAddLineToPoint(ctx, padding + arcRadius + 3 * arcTanLength + middleLineDistance * 2, viewHeight/2 - middleLineWidth/2);
//    CGContextAddArc(ctx, padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2, arcRadius, M_PI + radian, 2 * M_PI - radian, 0);
//    CGContextAddLineToPoint(ctx, padding + arcRadius + 5 * arcTanLength + middleLineDistance * 3, viewHeight/2 - middleLineWidth/2);
//    CGContextAddArc(ctx, padding + arcRadius + 6 * arcTanLength + middleLineDistance * 3, viewHeight/2, arcRadius, M_PI + radian, 3 * M_PI - radian, 0);
//    CGContextAddLineToPoint(ctx, padding + arcRadius + 5 * arcTanLength + middleLineDistance * 2, viewHeight/2 + middleLineWidth/2);
//    CGContextAddArc(ctx, padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2, arcRadius, radian, M_PI - radian, 0);
//    CGContextAddLineToPoint(ctx, padding + arcRadius + 3 * arcTanLength + middleLineDistance, viewHeight/2 + middleLineWidth/2);
//    CGContextAddArc(ctx, padding + arcRadius + 2 * arcTanLength + middleLineDistance, viewHeight/2, arcRadius, radian, M_PI - radian, 0);
//    CGContextAddLineToPoint(ctx, padding + arcRadius + arcTanLength, viewHeight/2 + middleLineWidth/2);
//    CGContextAddArc(ctx, padding + arcRadius, viewHeight/2, arcRadius, radian, M_PI - radian, 0);
//    
//    CGContextClosePath(ctx);
//    
//    CGContextSetFillColorWithColor(ctx, RGB(204, 204, 204).CGColor);
////    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
//    CGContextFillPath(ctx);
//    
//    
//    
//
//    
//    self.foregroundMaskLayer = [CAShapeLayer layer];
//    //MARK: 使用UIBezierPath 绘制遮挡VIEW的路径
//    UIBezierPath *outerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0,0, rect.size.width, rect.size.height) cornerRadius:rect.size.height/2];
//    
//    UIBezierPath *colorPath = [UIBezierPath bezierPath];
//    [colorPath moveToPoint:CGPointMake(padding, viewHeight/2)];
//    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:arcRadius startAngle:M_PI endAngle:2*M_PI - radian clockwise:YES];
//    [colorPath addLineToPoint:CGPointMake(padding + arcRadius +arcTanLength + middleLineDistance, viewHeight/2 - middleLineWidth/2)];
//    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius +arcTanLength * 2 + middleLineDistance, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:2 * M_PI - radian clockwise:YES];
//    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 3 * arcTanLength + middleLineDistance * 2, viewHeight/2 - middleLineWidth/2)];
//    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:2 * M_PI - radian clockwise:YES];
//    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 5 * arcTanLength + middleLineDistance * 3, viewHeight/2 - middleLineWidth/2)];
//    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 6 * arcTanLength + middleLineDistance * 3, viewHeight/2) radius:arcRadius startAngle:M_PI + radian endAngle:3 * M_PI - radian clockwise:YES];
//    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 5 * arcTanLength + middleLineDistance * 2, viewHeight/2 + middleLineWidth/2)];
//    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 4 * arcTanLength + middleLineDistance * 2, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
//    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + 3 * arcTanLength + middleLineDistance, viewHeight/2 + middleLineWidth/2)];
//    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius + 2 * arcTanLength + middleLineDistance, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
//    [colorPath addLineToPoint:CGPointMake(padding + arcRadius + arcTanLength, viewHeight/2 + middleLineWidth/2)];
//    [colorPath addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:arcRadius startAngle:radian endAngle:M_PI - radian clockwise:YES];
//    [colorPath closePath];
//    
//    [outerPath appendPath:colorPath];
//    [outerPath setUsesEvenOddFillRule:YES];
//    
//    self.foregroundMaskLayer.fillColor = RGB(221, 221, 221).CGColor;
//    self.foregroundMaskLayer.path = outerPath.CGPath;
//    self.foregroundMaskLayer.fillRule = kCAFillRuleEvenOdd;
//    [self.layer addSublayer:self.foregroundMaskLayer];
//    
//    //MARK: 第一个内部圆
//    self.firstArc = [CAShapeLayer layer];
//    UIBezierPath *arcPath1 = [UIBezierPath bezierPath];
//    [arcPath1 addArcWithCenter:CGPointMake(padding + arcRadius, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
//    self.firstArc.path = arcPath1.CGPath;
//    self.firstArc.fillColor = RGB(221, 221, 221).CGColor;
//    [self.layer addSublayer:self.firstArc];
//    
//    
//    //MARK: 第二个内部圆
//    self.secondArc = [CAShapeLayer layer];
//    UIBezierPath *arcPath2 = [UIBezierPath bezierPath];
//    [arcPath2 addArcWithCenter:CGPointMake(padding + arcRadius + arcTanLength + middleLineDistance + arcTanLength, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
//    self.secondArc.path = arcPath2.CGPath;
//    self.secondArc.fillColor = RGB(221, 221, 221).CGColor;
//    [self.layer addSublayer:self.secondArc];
//    
//    
//    //MARK: 第三个内部圆
//    self.thirdArc = [CAShapeLayer layer];
//    UIBezierPath *arcPath3 = [UIBezierPath bezierPath];
//    [arcPath3 addArcWithCenter:CGPointMake(padding + arcRadius + arcTanLength + middleLineDistance + arcTanLength + arcTanLength + middleLineDistance + arcTanLength, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
//    self.thirdArc.path = arcPath3.CGPath;
//    self.thirdArc.fillColor = RGB(221, 221, 221).CGColor;
//    [self.layer addSublayer:self.thirdArc];
//    
//    
//    //MARK: 第四个内部圆
//    self.forthArc = [CAShapeLayer layer];
//    UIBezierPath *arcPath4 = [UIBezierPath bezierPath];
//    [arcPath4 addArcWithCenter:CGPointMake(padding + arcRadius + arcTanLength + middleLineDistance + arcTanLength + arcTanLength + middleLineDistance + arcTanLength + arcTanLength + middleLineDistance + arcTanLength, viewHeight/2) radius:innerArcRadius startAngle:0 endAngle:2 * M_PI clockwise:1];
//    self.forthArc.path = arcPath4.CGPath;
//    self.forthArc.fillColor = RGB(221, 221, 221).CGColor;
//    
//    [self.layer addSublayer:self.forthArc];
//    
//}

- (void)setCurrentPercentage:(CGFloat)currentPercentage {
    _currentPercentage = currentPercentage;
    
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    animate.fromValue = self.lastPercentage == 0 ? @(0) : @(self.lastPercentage);        
    animate.toValue = @(currentPercentage);
    animate.repeatCount = 1;
    animate.autoreverses = NO;
    animate.duration = 1.f;
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    [self.backColorLayer addAnimation:animate forKey:@"progressAnimation"];
    
    self.lastPercentage = currentPercentage;

}

@end
