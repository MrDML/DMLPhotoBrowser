//
//  DMLPhotoCell.h
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMLPhotoScrollView.h"
#import "DMLPhotoItem.h"

@interface DMLPhotoCell : UICollectionViewCell
@property (nonatomic, strong) DMLPhotoItem *photoItem;
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

/**
 获取当前的缩放视图

 @param collectionView <#collectionView description#>
 @param page <#page description#>
 @return <#return value description#>
 */
+ (DMLPhotoScrollView *)collectionView:(UICollectionView *)collectionView PhotoScrollViewforPage:(NSInteger)page;

/**
 是否隐藏进度视图

 @param hidden <#hidden description#>
 */
- (void)progressLayerisHidden:(BOOL)hidden;
@end
