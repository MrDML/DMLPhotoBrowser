//
//  DMLProgressShapeLayer.m
//  DMLPhotoBrowserExample
//
//  Created by 戴明亮 on 2017/12/21.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import "DMLProgressShapeLayer.h"

@interface DMLProgressShapeLayer()<CAAnimationDelegate>

@property (nonatomic, assign) BOOL isStartAnimation;

@end

@implementation DMLProgressShapeLayer


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.frame = frame;
        self.cornerRadius = self.frame.size.width * 0.5;
        self.fillColor = [UIColor clearColor].CGColor;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineWidth = 4;
        self.lineCap = kCALineCapRound;
        self.strokeStart = 0;
        self.strokeEnd = 0.01;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5) radius:(self.frame.size.width * 0.5 - 2) startAngle:0 endAngle:2 * M_PI clockwise:YES];
        self.path = path.CGPath;
        
        // app 进入后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    
    return self;

}



- (void)applicationDidBecomeActive:(NSNotification *)notiofication
{
    if (self.isStartAnimation) {
        [self startProgressAnimation];
    }
}


/**
 开始动画
 */
- (void)startProgressAnimation
{
    self.isStartAnimation = YES;
    [self startAmintionWithAngle:M_PI];
}


- (void)startAmintionWithAngle:(CGFloat)angle
{
    self.strokeEnd = 0.4;
    
    CABasicAnimation *ani = [CABasicAnimation animation];
    ani.keyPath = @"transform.rotation.z";
    ani.toValue = @(angle);
    ani.duration = 0.4;
    //cumulative=YES的话，从上一次动画结束的位置继续动画。cumulative=NO的话又回到最开始的位置再次动画。
    ani.cumulative = YES;
    ani.repeatCount = HUGE;
    [self addAnimation:ani forKey:nil];
    
}


/**
 停止动画
 */
- (void)stopProgressAnimation
{
    self.isStartAnimation = NO;
    [self removeAllAnimations];
}


@end
