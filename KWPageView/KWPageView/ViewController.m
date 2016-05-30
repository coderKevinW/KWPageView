//
//  ViewController.m
//  KWPageView
//
//  Created by 王鑫 on 16/5/30.
//  Copyright © 2016年 KW. All rights reserved.
//

#import "ViewController.h"
#import "KWPageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    KWPageView *pageView = [KWPageView pageView];
    pageView.frame = CGRectMake(0, 100, 300, 200);
    pageView.images = @[@"img_00", @"img_01", @"img_02", @"img_03", @"img_04"];
    pageView.currentColor = [UIColor redColor];
    pageView.otherColor = [UIColor whiteColor];
    [self.view addSubview:pageView];
}
@end
