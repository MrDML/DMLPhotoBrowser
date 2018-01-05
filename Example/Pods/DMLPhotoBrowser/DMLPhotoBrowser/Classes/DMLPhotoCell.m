//
//  DMLPhotoCell.m
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import "DMLPhotoCell.h"

@interface DMLPhotoCell ()
@property (nonatomic, strong)DMLPhotoScrollView *photoScrollView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong)DMLProgressShapeLayer *progressLayer;
@end


@implementation DMLPhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photoScrollView = [[DMLPhotoScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_photoScrollView];
        
        _progressLayer  = [[DMLProgressShapeLayer alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _progressLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
        _progressLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _progressLayer.hidden = YES;
        [self.layer addSublayer:_progressLayer];
       
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _photoScrollView.bounds = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _photoScrollView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
}


- (void)setPhotoItem:(DMLPhotoItem *)photoItem
{
    _photoItem = photoItem;
    
    _photoScrollView.photoItem =photoItem;

   __weak typeof(self)weakSelf = self;
    _photoScrollView.progressBlock = ^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            double progress = (double)receivedSize / expectedSize;
            strongSelf.progressLayer.hidden = NO;
            strongSelf.progressLayer.strokeEnd = MAX(progress, 0.01);
        });
    };
    
    _photoScrollView.completedBolck = ^(UIImage *image, NSURL *imageURL) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.progressLayer.hidden = YES;
            [weakSelf.progressLayer stopProgressAnimation];
        });
    };
    
}

/* 快速创建collectionCell */
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    
    DMLPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"indetifire" forIndexPath:indexPath];
    
    CGRect rect = cell.frame;
    rect.size.width = collectionView.frame.size.width - 20;
    cell.frame = rect;
    
    cell.collectionView = collectionView;
    // 设置标志
//    cell.photoView.tag = indexPath.item;
    return cell;
}


+ (DMLPhotoScrollView *)collectionView:(UICollectionView *)collectionView PhotoScrollViewforPage:(NSInteger)page
{
    
     [collectionView layoutIfNeeded];
    // 有时候返回 nil，有时候成功。 在调用之前调用[collectionView layoutIfNeeded];
    DMLPhotoCell *cell = (DMLPhotoCell*)[collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0]];
    return cell.photoScrollView;
    
}


- (void)progressLayerisHidden:(BOOL)hidden
{
    self.progressLayer.hidden = hidden;
}




@end
