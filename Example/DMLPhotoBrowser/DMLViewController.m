//
//  DMLViewController.m
//  DMLPhotoBrowser
//
//  Created by MrDML on 01/03/2018.
//  Copyright (c) 2018 MrDML. All rights reserved.
//

#import "DMLViewController.h"
#import "SDWebImageManager.h"

@interface DMLViewController ()

@end

@implementation DMLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clearPictureMemory:(UIButton *)sender {
    
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
}

    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
