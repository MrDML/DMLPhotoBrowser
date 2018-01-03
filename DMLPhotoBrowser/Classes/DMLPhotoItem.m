//
//  DMLPhotoItem.m
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import "DMLPhotoItem.h"

@interface DMLPhotoItem ()
@property (nonatomic, strong,readwrite) UIView *sourceView;
@property (nonatomic, strong,readwrite) UIImage *thumbImage;
@property (nonatomic, strong,readwrite) NSURL *imageUrl;
@property (nonatomic, strong,readwrite) NSURL *originalImageURL;
@property (nonatomic, strong,readwrite) NSURL *thumbImageURL;
@property (nonatomic, strong,readwrite) UIImage *image;
@end

@implementation DMLPhotoItem

- (instancetype)initWithSourceView:(UIView *)sourceView thumbImage:(UIImage *)image imageUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _sourceView = sourceView;
        _thumbImage = image;
        _imageUrl = url;
    }
    return self;
}

// 网络图片
- (instancetype)initWithSourceView:(UIImageView *)sourceView imageUrl:(NSURL *)url {
    return [self initWithSourceView:sourceView thumbImage:sourceView.image imageUrl:url];
}

// 本地图片
- (instancetype)initWithSourceView:(UIImageView *)sourceView image:(UIImage *)image {
    self = [super init];
    if (self) {
        _sourceView = sourceView;
        _thumbImage = image;
        _imageUrl = nil;
        _image = image;
    }
    return self;
}

// 只有原图和缩略图 不存在图片的归属图片
- (instancetype)initWithOriginalImageURL:(NSURL *)originalImageURL
{
    self = [super init];
    if (self) {
        _imageUrl = originalImageURL;
        _originalImageURL = originalImageURL;
    }
    return self;
}





@end
