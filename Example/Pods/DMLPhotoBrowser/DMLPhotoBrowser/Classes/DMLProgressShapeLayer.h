//
//  DMLProgressShapeLayer.h
//  DMLPhotoBrowserExample
//
//  Created by 戴明亮 on 2017/12/21.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface DMLProgressShapeLayer : CAShapeLayer


/**
 实例方法

 @param frame <#frame description#>
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame;
/**
 开始动画
 */
- (void)startProgressAnimation;
/**
 停止动画
 */
- (void)stopProgressAnimation;

@end
