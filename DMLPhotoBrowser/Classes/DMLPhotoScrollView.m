//
//  DMLPhotoScrollView.m
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import "DMLPhotoScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"
#import "SDWebImageManager.h"
#import "FLAnimatedImageView.h"


const CGFloat kDMLhotoViewPadding = 10;
const CGFloat kDMLhotoViewMaxScale = 3;
@interface DMLPhotoScrollView ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@end
@implementation DMLPhotoScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bouncesZoom = YES;
        self.maximumZoomScale = kDMLhotoViewMaxScale;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.multipleTouchEnabled = YES;
        self.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue] > 11.0f) {
            if (@available(iOS 11.0, *)) {
                self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }if (@available(iOS 11.0, *)) {
                self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            } else {
                // Fallback on earlier versions
            }
        }
        FLAnimatedImageView *imageViewTemp = [[FLAnimatedImageView alloc] init];
        imageViewTemp.backgroundColor = [UIColor blackColor];
        imageViewTemp.contentMode = UIViewContentModeScaleAspectFill;
        imageViewTemp.clipsToBounds = YES;
        [self addSubview:imageViewTemp];
        [self adjustImageViewSize];
        self.imageView = imageViewTemp;
        
    }
    return self;
}



- (void)setPhotoItem:(DMLPhotoItem *)photoItem
{
    
    if (_photoItem != photoItem) {
        _photoItem = photoItem;
    }
    
    [_imageView sd_cancelCurrentImageLoad];
    
    if (_photoItem) {
        
        if (_photoItem.image) {
            _imageView.image = _photoItem.image;
            _photoItem.finished = YES;
            _progressLayer.hidden = YES;
            // 调整视图
            [self adjustImageViewSize];
            return;
        }
        _imageView.image = _photoItem.thumbImage;
        [self adjustImageViewSize];
        __strong typeof(self) weakSelf = self;
        [_imageView sd_setImageWithURL:photoItem.imageUrl placeholderImage:_photoItem.thumbImage options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            if (_progressBlock) {
                _progressBlock(receivedSize, expectedSize, targetURL);
            }
        } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
             [weakSelf adjustImageViewSize];
            if (_completedBolck) {
                _completedBolck(image,imageURL);
            }
             [_imageView startAnimating];
        }];
    }else{
        [_progressLayer stopProgressAnimation];
        _progressLayer.hidden = YES;
        _imageView.image = nil;
    }
    
    
    
}

- (void)adjustImageViewSize
{
    if (_imageView.image) {

        CGSize imageSize = _imageView.image.size;
        CGFloat width = self.frame.size.width;
        if (_imageView.image.size.width < 80) {
            width = _imageView.image.size.width;
        }
        CGFloat height = width * (imageSize.height / imageSize.width);

        CGRect imageViewFrame = CGRectMake(0, 0, width, height);

        _imageView.frame = imageViewFrame;
        if (height >= self.bounds.size.height) {
            _imageView.center = CGPointMake(self.bounds.size.width * 0.5, height * 0.5);

        }else{
            _imageView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
        }

    }else{
        CGFloat width = self.frame.size.width - 2 * kDMLhotoViewPadding;
        _imageView.bounds = CGRectMake(0, 0, width, width * 2.0 / 3);
        _imageView.center = CGPointMake(self.bounds.size.width * 0.5 , self.bounds.size.height * 0.5);
    }

    self.contentSize = _imageView.frame.size;
    
}

- (BOOL)currentScrollViewIsTopOrBottom
{
   
    CGPoint translation = [self.panGestureRecognizer translationInView:self];
    if (translation.y > 0 && self.contentOffset.y <= 0) {
        return YES;
    }
    CGFloat offsetY = floor(self.contentSize.height - self.bounds.size.height);
    if (translation.y < 0 && self.contentOffset.y >= offsetY) {
        return YES;
    }
    return NO;
}

- (void)cancelCurrentImageLoad
{
    [_imageView sd_cancelCurrentImageLoad];
}

#pragma Mark -- UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{

    CGFloat offsetX = 0.f;
    if (scrollView.bounds.size.width > scrollView.contentSize.width) {
        offsetX = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    }else{
        offsetX = 0.f;
    }
    CGFloat offsetY = 0.f;
    if (scrollView.bounds.size.height > scrollView.contentSize.height) {
        offsetY = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    }else{
        offsetY = 0.f;
    }
    
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
    
}

#pragma Mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
            if ([self currentScrollViewIsTopOrBottom]) {
                return NO;
            }
        }
    }
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
