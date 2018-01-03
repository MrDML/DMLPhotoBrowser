//
//  DMLPhotoItem.h
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMLPhotoItem : NSObject
- (instancetype)initWithSourceView:(UIView *)sourceView thumbImage:(UIImage *)image imageUrl:(NSURL *)url;
// 网络图片
- (instancetype)initWithSourceView:(UIImageView *)sourceView imageUrl:(NSURL *)url;
// 本地图片
- (instancetype)initWithSourceView:(UIImageView *)sourceView image:(UIImage *)image;
// 只有原图
- (instancetype)initWithOriginalImageURL:(NSURL *)originalImageURL;

/**
 图片所属视图 (可选)
 */
@property (nonatomic, strong,readonly) UIView *sourceView;

/**
 缩略图
 */
@property (nonatomic, strong,readonly) UIImage *thumbImage;

/**
 原图
 */
@property (nonatomic, strong,readonly) NSURL *imageUrl;

/**
 原图URL
 */
@property (nonatomic, strong,readonly) NSURL *originalImageURL;


/**
 缩略图URL
 */
@property (nonatomic, strong,readonly) NSURL *thumbImageURL;


/**
 相册图片
 */
@property (nonatomic, strong,readonly) UIImage *image;



@property (nonatomic, assign) BOOL finished;

@end
