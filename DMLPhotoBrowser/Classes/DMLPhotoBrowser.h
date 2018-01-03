//
//  DMLPhotoBrowser.h
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 指示器样式

 - kBrowserPagingStyleDot: 。。。
 - kBrowserPagingStyleText: 4/5
 */
typedef NS_ENUM(NSInteger, kBrowserPagingStyle){
    kBrowserPagingStyleDot,
    kBrowserPagingStyleText
};

@class DMLPhotoItem;

@interface DMLPhotoBrowser : UIViewController

/**
 pageStyle default:kBrowserPagingStyleDot
 */
@property (nonatomic, assign) kBrowserPagingStyle pageStyel;

+ (instancetype)browserWithPhotoItems:(NSArray<DMLPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (instancetype)initWithPhotoItems:(NSArray<DMLPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex;
- (void)showPhotoBrowser;
@end
