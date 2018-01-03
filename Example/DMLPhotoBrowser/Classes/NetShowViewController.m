//
//  NetShowViewController.m
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import "NetShowViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "FLAnimatedImageView.h"
#import "DMLPhotoBrowser.h"
#import "DMLPhotoItem.h"
#define UISCreenWidth  [UIScreen mainScreen].bounds.size.width
#define UISCreenHeight  [UIScreen mainScreen].bounds.size.height
@interface NetShowViewController ()
@property (nonatomic, strong) NSMutableArray *thumbnailURLs;
@property (nonatomic, strong) NSMutableArray *originalURLs;
@property (nonatomic, strong) NSMutableArray *imageViewSource;
@property (nonatomic, strong) UIView *bgview;
@end

@implementation NetShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
     NSMutableArray *thumbnailURLs = [NSMutableArray array];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owjch9vj20j60kdags.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owjjexyj20j60nsguu.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owjfk07j20j60n0wkc.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owkza37j20j60nzam1.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owlotmqg209w05kaug.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owjojaxj20j60nz7fc.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owjn6taj20j60kr450.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owk4tjlj20j60juq8x.jpg"];
    [thumbnailURLs addObject:@"https://wx3.sinaimg.cn/thumbnail/684e8299gy1fm2owl6yxvj20j60mf460.jpg"];
    self.thumbnailURLs = thumbnailURLs;
    
    

    NSMutableArray *originalURLs = [NSMutableArray array];

    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjch9vj20j60kdags.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjjexyj20j60nsguu.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjfk07j20j60n0wkc.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owkza37j20j60nzam1.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owlotmqg209w05kaug.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjojaxj20j60nz7fc.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owjn6taj20j60kr450.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owk4tjlj20j60juq8x.jpg"];
    [originalURLs addObject:@"https://wx3.sinaimg.cn/large/684e8299gy1fm2owl6yxvj20j60mf460.jpg"];
    
    self.originalURLs = originalURLs;
    

    [self configNetPhototUI];
    
    _imageViewSource = [NSMutableArray array];
    
}


- (void)configNetPhototUI
{
    

    UILabel *la_Tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, UISCreenWidth, 60)];
    la_Tip.text = @"网络图片浏览";
    la_Tip.textAlignment = NSTextAlignmentCenter;
    la_Tip.font = [UIFont systemFontOfSize:18];
    la_Tip.textColor = [UIColor lightGrayColor];
    [self.view addSubview:la_Tip];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(la_Tip.frame), UISCreenWidth, 400)];
    bgview.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:245/255.0];
    [self.view addSubview:bgview];
    self.bgview = bgview;
    
    
    CGFloat  marge_cow = 10;
    CGFloat  marge_row = 10;
    int item = 4;
    CGFloat  image_Width = (UISCreenWidth -  (4 -1)*marge_cow - 2 *marge_cow)/item;
    CGFloat image_Height = image_Width;
    
    
    for (int i = 0; i < self.thumbnailURLs.count; i ++) {
        FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        NSString *str = self.thumbnailURLs[i];
        CGFloat row = i  % 4;
        CGFloat cow = i / 4;
        
        CGFloat X = marge_cow + (marge_cow + image_Width)*row;
        CGFloat Y = marge_row + (marge_row + image_Height)*cow;
        imageView.frame = CGRectMake(X, Y, image_Width, image_Height);
        [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
        [bgview addSubview:imageView];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [imageView addGestureRecognizer:tapGesture];
        [_imageViewSource addObject:imageView];
    }
    
    
}



- (void)imageClick:(UIGestureRecognizer *)gesture
{
    
    FLAnimatedImageView *imageView =(FLAnimatedImageView *)gesture.view;
    NSLog(@"click %ld Photo",imageView.tag);

    NSMutableArray *photoItems = [NSMutableArray array];
    int i = 0;
    for (NSString *url in self.originalURLs) {
        
        FLAnimatedImageView *imageViewSource = self.bgview.subviews[i];
        
        DMLPhotoItem *item = [[DMLPhotoItem alloc] initWithSourceView:imageViewSource thumbImage:imageViewSource.image imageUrl:[NSURL URLWithString:url]];
        [photoItems addObject:item];
   
        i ++;
    }
    
    DMLPhotoBrowser *Browser = [[DMLPhotoBrowser alloc] initWithPhotoItems:photoItems selectedIndex:imageView.tag];
    
    
    [Browser showPhotoBrowser];
    
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
