//
//  LocalShowViewController.m
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import "LocalShowViewController.h"
#import "DMLPhotoBrowser.h"
#import "DMLPhotoItem.h"
#define UISCreenWidth  [UIScreen mainScreen].bounds.size.width
#define UISCreenHeight  [UIScreen mainScreen].bounds.size.height
@interface LocalShowViewController ()
@property (nonatomic, strong) NSArray  *images;
@property (nonatomic, strong) UIView *bgview;
@end

@implementation LocalShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configLocalImagesUI];
    
    
}

- (void)configLocalImagesUI
{
    
    UILabel *la_Tip = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, UISCreenWidth, 60)];
    la_Tip.text = @"相册图片浏览";
    la_Tip.textAlignment = NSTextAlignmentCenter;
    la_Tip.font = [UIFont systemFontOfSize:18];
    la_Tip.textColor = [UIColor lightGrayColor];
    [self.view addSubview:la_Tip];
    
    UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(la_Tip.frame), UISCreenWidth, 400)];
    bgview.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:245/255.0];
    [self.view addSubview:bgview];
    
    
    
    CGFloat  marge_cow = 10;
    CGFloat  marge_row = 10;
    int item = 4;
    CGFloat  image_Width = (UISCreenWidth -  (4 -1)*marge_cow - 2 *marge_cow)/item;
    CGFloat image_Height = image_Width;
    
    
    for (int i = 0; i < self.images.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = self.images[i];
        
        CGFloat row = i  % 4;
        CGFloat cow = i / 4;
        
        CGFloat X = marge_cow + (marge_cow + image_Width)*row;
        CGFloat Y = marge_row + (marge_row + image_Height)*cow;
        
        
        imageView.frame = CGRectMake(X, Y, image_Width, image_Height);
        
        [bgview addSubview:imageView];
         self.bgview = bgview;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [imageView addGestureRecognizer:tapGesture];
    }
    
    
}



- (void)imageClick:(UIGestureRecognizer *)gesture
{
    
    UIImageView *imageView =(UIImageView *)gesture.view;
    NSLog(@"click %zd Photo",imageView.tag);

    NSMutableArray *photoItems = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in self.images) {
        
        UIImageView *imageViewSource = self.bgview.subviews[i];
        DMLPhotoItem *item = [[DMLPhotoItem alloc] initWithSourceView:imageViewSource image:image];
        [photoItems addObject:item];

        i ++;
    }
    
    DMLPhotoBrowser *Browser = [[DMLPhotoBrowser alloc] initWithPhotoItems:photoItems selectedIndex:imageView.tag];
    
    
    [Browser showPhotoBrowser];
    
    
}




-(NSArray *)images{
    
    if(_images ==nil){
        NSMutableArray *arrayM = [NSMutableArray array];
        
        for (NSUInteger i=0; i<9; i++) {
            
            UIImage *imagae =[UIImage imageNamed:[NSString stringWithFormat:@"%@",@(i+1)]];
            
            [arrayM addObject:imagae];
        }
        
        _images = arrayM;
    }
    
    return _images;
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
