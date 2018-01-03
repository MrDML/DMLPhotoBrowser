//
//  DMLPhotoBrowser.m
//  DMLPhotoBrowserDemo
//
//  Created by 戴明亮 on 2017/12/27.
//  Copyright © 2017年 戴明亮. All rights reserved.
//

#import "DMLPhotoBrowser.h"
#import "DMLPhotoItem.h"
#import "DMLPhotoCell.h"
#import "DMLPhotoImageView.h"
#import <Photos/Photos.h>
#define  kUIScreen_Width  [UIScreen mainScreen].bounds.size.width
#define  kUIScreen_Height [UIScreen mainScreen].bounds.size.height

@interface DMLPhotoBrowser ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CAAnimationDelegate>{
    CGPoint _startLocation;
}

/**图片模型数据*/
@property (nonatomic, strong) NSArray <DMLPhotoItem *>*photoItems;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIWindow *window;

/**选中索引*/
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) DMLPhotoScrollView *selectPhotoScrollView;

/**显示分页控制器eg:....*/
@property (nonatomic, strong) UIPageControl *pageControl;

/**显示分页数字eg:3/10*/
@property (nonatomic, strong) UILabel *pageLabel;

@property (nonatomic, strong) UIView *topToolView;

@property (nonatomic, strong) UIView *bottomToolView;

@property (nonatomic, strong) UIButton *saveButton;

@end

@implementation DMLPhotoBrowser

// 类方法
+ (instancetype)browserWithPhotoItems:(NSArray<DMLPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    DMLPhotoBrowser *browser = [[DMLPhotoBrowser alloc] initWithPhotoItems:photoItems selectedIndex:selectedIndex];
    return browser;
}

// 对象方法
- (instancetype)initWithPhotoItems:(NSArray<DMLPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex {
    self = [super init];
    if (self) {
        _photoItems = [NSArray array];
        _photoItems = photoItems;
        _selectedIndex = selectedIndex;
        _pageStyel = kBrowserPagingStyleDot;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加子视图
    [self addSubViews];
    // 注册手势
    [self registGestureRecognizer];
}


- (void)addSubViews
{
     [self.view addSubview:self.collectionView];
     [self.collectionView registerClass:[DMLPhotoCell class] forCellWithReuseIdentifier:@"indetifire"];
    
    [self.view addSubview:self.topToolView];
    
     [self.view addSubview:self.bottomToolView];
    
    // 当图片大于9张时默认呈现text样式
    if (_pageStyel == kBrowserPagingStyleDot) {
        if (self.photoItems.count > 9) {
            [self.bottomToolView addSubview:self.pageLabel];
        }else{
            [self.bottomToolView addSubview:self.pageControl];
            _pageControl.numberOfPages = self.photoItems.count;
            _pageControl.currentPage = _selectedIndex;
        }
    }else{
        [self.bottomToolView addSubview:self.pageLabel];
    }
    
    [self.topToolView addSubview:self.saveButton];
    
}




- (void)showPhotoBrowser
{
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kUIScreen_Width, kUIScreen_Height)];
    self.window = window;
    window.windowLevel = UIWindowLevelAlert;
    window.rootViewController = self;
    window.backgroundColor = [UIColor blackColor];
    [window makeKeyAndVisible];
    self.view.hidden = YES;
    window.hidden = NO;
    self.collectionView.alpha = 0.0;
    
     DMLPhotoItem *photoItem = self.photoItems[_selectedIndex];

    if (_selectedIndex > self.photoItems.count) {
        return;
    }
    
    if (photoItem.sourceView != nil) {
        [self showPhotoBrowserFromsourceView:photoItem];
    }else{
        [self showPhotoBrowserFromWindow:photoItem];
    }
}


- (void)showPhotoBrowserFromsourceView:(DMLPhotoItem *)photoItem
{
    if (photoItem.thumbImage == nil) {
        return;
    }
    
    CGRect currentRect = [photoItem.sourceView convertRect:photoItem.sourceView.bounds toView:self.window];
    DMLPhotoImageView *tempImageView = [[DMLPhotoImageView alloc] init];
    tempImageView.image = photoItem.thumbImage;
    tempImageView.frame = currentRect;
    [self.window addSubview:tempImageView];
    
    [UIView animateWithDuration:0.2f animations:^{
        CGFloat width = kUIScreen_Width;
        CGFloat height = kUIScreen_Width * (tempImageView.image.size.height / tempImageView.image.size.width);
        tempImageView.bounds = CGRectMake(0, 0, width, height);
        tempImageView.center = CGPointMake(kUIScreen_Width * 0.5, kUIScreen_Height * 0.5);
        self.collectionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        tempImageView.hidden = YES;
        [tempImageView removeFromSuperview];
        self.window.backgroundColor = [UIColor clearColor];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor blackColor];
        self.view.hidden = NO;
        
        self.collectionView.hidden = NO;
        [self.collectionView reloadData];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self scrollViewDidScroll:self.collectionView];
    }];
    
}


- (void)showPhotoBrowserFromWindow:(DMLPhotoItem *)photoItem
{

    [UIView animateWithDuration:0.2 animations:^{
        self.collectionView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.view.hidden = NO;
        self.view.backgroundColor = [UIColor blackColor];
        self.window.backgroundColor = [UIColor clearColor];
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.hidden = NO;

        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [self scrollViewDidScroll:self.collectionView];
        
    }];
    
}



/**
 目前只支持竖直方向

 @return <#return value description#>
 */

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
     return UIInterfaceOrientationMaskPortrait;
}

#pragma mark 保存图片
- (void)savePhoto
{
    
    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusAuthorized: {
                    //  保存图片到相册
                    [self saveImageIntoAlbum];
                    break;
                }
                case PHAuthorizationStatusDenied: {
                    if (oldStatus == PHAuthorizationStatusNotDetermined) return;
                    NSLog(@"提醒用户打开相册的访问开关");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法保存"        message:@"请在iPhone的“设置-隐私-照片”选项中，允许访问你的照片。" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
                    [alert show];
                    break;
                }
                case PHAuthorizationStatusRestricted: {
                    break;
                }
                default:
                    break;
            }
        });
    }];
    
}



// 获得刚才添加到相机胶卷中的图片
-(PHFetchResult<PHAsset *> *)createdAssets
{
    __block NSString *createdAssetId = nil;
   
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdAssetId = [PHAssetChangeRequest creationRequestForAssetFromImage:self.selectPhotoScrollView.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } error:nil];
    if (createdAssetId == nil) return nil;
 
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[createdAssetId] options:nil];
}

//获得自定义相册
-(PHAssetCollection *)createdCollection
{

    NSString *title = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
 
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }
    __block NSString *createdCollectionId = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    if (createdCollectionId == nil) return nil;
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionId] options:nil].firstObject;
}



//保存图片到相册
-(void)saveImageIntoAlbum
{
    PHFetchResult<PHAsset *> *createdAssets = self.createdAssets;
    PHAssetCollection *createdCollection = self.createdCollection;
    if (createdAssets == nil || createdCollection == nil) {
        return;
    }
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];
    NSString *msg = nil ;
    if(error){
        msg = @"图片保存失败！";
    }else{
        msg = @"已成功保存到系统相册";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"  message:msg delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}




#pragma mark -- 添加手势
- (void)registGestureRecognizer {
    
    // 单击手势
    UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;
    
    // 双击手势
    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleRecognizer];
    
    // 如果双击确定检测失败才会触发单击
    [singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
    [self.view addGestureRecognizer:singleRecognizer];
    
    // 移动手势
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.view addGestureRecognizer:panRecognizer];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    [self hideBrowser];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
   
    if (self.selectPhotoScrollView.zoomScale > 1) {
        [self.selectPhotoScrollView setZoomScale:1 animated:YES];
    } else {
        CGPoint location = [tap locationInView:self.view];
        CGFloat maxZoomScale = self.selectPhotoScrollView.maximumZoomScale;
        CGFloat width = self.view.bounds.size.width / maxZoomScale;
        CGFloat height = self.view.bounds.size.height / maxZoomScale;
        // 以点击的目标点为中心的一个矩形
        [self.selectPhotoScrollView zoomToRect:CGRectMake(location.x - width/2, location.y - height/2, width, height) animated:YES];
    }
}


- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    if (self.selectPhotoScrollView.zoomScale > 1.1) {
        return;
    }
    // 平移 ->缩放效果
   [self handleScaleWithPanRecognizer:pan];
    
}

- (void)handleScaleWithPanRecognizer:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.view];
    CGPoint location = [pan locationInView:self.view];
    CGPoint velocity = [pan velocityInView:self.view];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            _startLocation = location;
            [self handlePaRecognizernBegin];
            break;
        case UIGestureRecognizerStateChanged: {
            double percent = 1 - fabs(point.y) / self.view.frame.size.height;
            percent = MAX(percent, 0);
            double s = MAX(percent, 0.5);
            CGAffineTransform translation = CGAffineTransformMakeTranslation(point.x/s, point.y/s);
            CGAffineTransform scale = CGAffineTransformMakeScale(s, s);
            self.selectPhotoScrollView.imageView.transform = CGAffineTransformConcat(translation, scale);
            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:percent];
            self.collectionView.alpha = percent;
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            if (fabs(point.y) > 100 || fabs(velocity.y) > 500) {
                [self hideBrowser];
            } else {
                [self cancelGestureRecognizerAnimation];
            }
        }
            break;
            
        default:
            break;
    }
}


/**
 取消手势动画恢复图片的原始状态
 */
- (void)cancelGestureRecognizerAnimation
{
    [UIView animateWithDuration:0.5 animations:^{
        self.selectPhotoScrollView.imageView.transform = CGAffineTransformIdentity;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.alpha = 1.0;
        self.view.backgroundColor = [UIColor blackColor];
        self.view.alpha = 1.0;
        [self.collectionView reloadData];
        
    } completion:^(BOOL finished) {
        DMLPhotoItem *photoItem =  [self.photoItems objectAtIndex:self.selectedIndex];
        photoItem.sourceView.alpha = 1;
    }];
}



/**
 手势开始时
 */
- (void)handlePaRecognizernBegin {
    // 取消当前加载图片请求
    [self.selectPhotoScrollView cancelCurrentImageLoad];
    DMLPhotoItem *photoItem = [self.photoItems objectAtIndex:_selectedIndex];
    photoItem.sourceView.alpha = 0;
    [self.collectionView layoutIfNeeded];
    DMLPhotoCell *cell = (DMLPhotoCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0]];
    [cell progressLayerisHidden:YES];
}



/**
 单击手势隐藏视图
 */
- (void)hideBrowser
{
    
    DMLPhotoItem *photoItem =  [self.photoItems objectAtIndex:self.selectedIndex];
     [self handlePaRecognizernBegin];
    if (photoItem.sourceView != nil) {
        // 获取当前的视图
        DMLPhotoImageView *tempImageView = self.selectPhotoScrollView.imageView;
        photoItem.sourceView.alpha = 0;
        CGRect currentRect = [photoItem.sourceView.superview convertRect:photoItem.sourceView.frame toView:self.window];
        [UIView animateWithDuration:0.5 animations:^{
            tempImageView.frame = currentRect;
            self.collectionView.backgroundColor = [UIColor clearColor];
            self.view.backgroundColor = [UIColor clearColor];
            self.window.backgroundColor = [UIColor clearColor];
            if (!CGRectIntersectsRect(currentRect, [UIScreen mainScreen].bounds)) { // 超出范围，不缩放，直接渐变消失
                tempImageView.hidden = YES;
            }
        } completion:^(BOOL finished) {
            tempImageView.hidden = YES;
            [self endBrowser];
        }];
    }else{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self endBrowser];
        }];
    }
    
    
    
}

- (void)endBrowser
{
    [self.collectionView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
     DMLPhotoItem *photoItem =  [self.photoItems objectAtIndex:self.selectedIndex];
    self.window.rootViewController = nil;
    self.window.hidden = YES;
    self.collectionView.hidden = YES;
    self.view.hidden = YES;
    self.collectionView = nil;
    [self.collectionView removeFromSuperview];
    photoItem.sourceView.alpha = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionViewDelegate 、UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoItems.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLPhotoCell *cell =  [DMLPhotoCell cellWithCollectionView:collectionView indexPath:indexPath];
    DMLPhotoItem *photoItem = self.photoItems[indexPath.row];
    cell.photoItem = photoItem;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.bounds.size.width - 20, [UIScreen mainScreen].bounds.size.height);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = self.collectionView.contentOffset.x / self.collectionView.frame.size.width + 0.5;
    self.selectedIndex = page;
    DMLPhotoScrollView *photoScrollView = [DMLPhotoCell collectionView:self.collectionView PhotoScrollViewforPage:page];
    self.selectPhotoScrollView = photoScrollView;
    
    [self configCurrentDidScrollforCurrentPage:page];

}


- (void)configCurrentDidScrollforCurrentPage:(NSInteger)currentPage
{
    if (_pageStyel == kBrowserPagingStyleDot) {
        _pageControl.currentPage = currentPage;
    }else{
        _pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",(currentPage+1),self.photoItems.count];
    }
    
}


#pragma mark -- lazy
- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.minimumLineSpacing = 20;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

- (UICollectionView *)collectionView
{

    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width + 20, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:self.layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 20);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
    }
    
    return _collectionView;
}

- (UIView *)topToolView
{
    if (_topToolView == nil) {
        _topToolView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kUIScreen_Width, 64)];
        _topToolView.backgroundColor = [UIColor clearColor];
    }
    return _topToolView;
}

- (UIView *)bottomToolView
{
    if (_bottomToolView == nil) {
        _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreen_Height - 64, kUIScreen_Width, 64)];
        _bottomToolView.backgroundColor = [UIColor clearColor];
    }
    return _bottomToolView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 20, self.bottomToolView.frame.size.width, 20)];
    }
    
    return _pageControl;
}


- (UILabel *)pageLabel
{
    if (_pageLabel == nil) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bottomToolView.frame.size.width, 20)];
        _pageLabel.font = [UIFont systemFontOfSize:16];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _pageLabel;
}




- (UIButton *)saveButton
{
    if (_saveButton == nil) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.backgroundColor = [UIColor clearColor];
        _saveButton.frame = CGRectMake(self.topToolView.frame.size.width - 80, 0, 80, 40);
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_saveButton addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _saveButton.frame.size.width, _saveButton.frame.size.height) cornerRadius:10];
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = path.CGPath;
        
        _saveButton.layer.mask = layer;
        
    }
    return _saveButton;
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
