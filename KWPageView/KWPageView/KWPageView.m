//
//  KWPageView.m
//  KWPageView
//
//  Created by 王鑫 on 16/5/30.
//  Copyright © 2016年 KW. All rights reserved.
//

#import "KWPageView.h"

@interface KWPageView()<UIScrollViewDelegate>

/** 父scrollView */
@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;
/** 右下角小圆点 */
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
/** 定时器 */
@property (nonatomic,strong) NSTimer *timer;

@end

@implementation KWPageView

/**
 * 构造方法:获取Bundle中的XIB视图
 */
+ (instancetype)pageView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}

/**
 *  初始化方法:对KWPageView视图进行一定的初始化设置
 */
- (void)setup
{
    //1 初始化设置
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.pagingEnabled = YES;
    //2 定时器初始化时默认开始
    [self startTimer];
}

/**
 *  纯代码初始化方法:KWPageView内部子控件
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //1 调用初始化方法
        [self setup];
    }
    return self;
}

/**
 *  XIB觉醒初始化方法:KWPageView内部子控件
 */
- (void)awakeFromNib
{
    //1 调用初始化方法
    [self setup];
}

/**
 *  重写3个setter方法
 *  1 images:从外部获得images数组(内部装的是图片名字符串)
 *  2 currentColor:从外部获得当前圆点的颜色
 *  3 otherColor:从外部获得其他圆点的颜色
 */
- (void)setImages:(NSArray *)images
{
    _images = images;
    
    //1 清除上次数据
    [self.pageScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //2 往pageScrollView中添加图片
    for (int i = 0 ; i < self.images.count ; i ++ )
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:self.images[i]];
        [self.pageScrollView addSubview:imageView];
    }
    
    //3 设置圆点个数
    self.pageControl.numberOfPages = self.images.count;
    // 单页时隐藏圆点
    self.pageControl.hidesForSinglePage = YES;
    
}

- (void)setCurrentColor:(UIColor *)currentColor
{
    _currentColor = currentColor;
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
}

- (void)setOtherColor:(UIColor *)otherColor
{
    _otherColor = otherColor;
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
}

/**
 *  layoutSubviews:当外部设置使frame发生改变时调用该方法
 *  此方法并不是每修改一次就调用一次，而是统筹综合调用
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    //1 设置scrollView.frame
    self.pageScrollView.frame = self.bounds;
    //  获得pageScrollView的尺寸
    CGFloat scrollW = self.pageScrollView.frame.size.width;
    CGFloat scrollH = self.pageScrollView.frame.size.height;
    //2 设置pageControl.frame
    CGFloat pageW = 100;
    CGFloat pageH = 20;
    CGFloat pageX = scrollW - pageW;
    CGFloat pageY = scrollH - pageH;
    self.pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
    //  设置scrollView.contentSize
    self.pageScrollView.contentSize = CGSizeMake(self.images.count * scrollW, 0);
    //3 设置imageView.frame
    for (int i = 0; i < self.images.count; i ++ )
    {
        UIImageView *imageView = self.pageScrollView.subviews[i];
        imageView.frame = CGRectMake(i * scrollW, 0, scrollW, scrollH);
    }
}

#pragma mark - NSTimer Method
- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

/** 下一页的方法 */
- (void)nextPage
{
    NSInteger pageIndex = self.pageControl.currentPage + 1;
    if (pageIndex == self.pageControl.numberOfPages)
    {
        pageIndex = 0;
    }
    
    CGPoint offset = self.pageScrollView.contentOffset;
    offset.x = pageIndex * self.pageScrollView.frame.size.width;
    [self.pageScrollView setContentOffset:offset animated:YES];
}

# pragma mark - UIScrollViewDelegate
/** 当scrollView开始滚动时 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 计算圆点当前所在位置
    self.pageControl.currentPage = (NSInteger)(self.pageScrollView.contentOffset.x / self.pageScrollView.frame.size.width + 0.5);
}

/** 当用户开始拖拽时 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

/** 当用户拖拽结束时 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
@end
