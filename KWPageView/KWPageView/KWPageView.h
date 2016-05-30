//
//  KWPageView.h
//  KWPageView
//
//  Created by 王鑫 on 16/5/30.
//  Copyright © 2016年 KW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWPageView : UIView

/** 图片数组 */
@property (nonatomic,strong) NSArray *images;
/** 当前圆点的颜色 */
@property (nonatomic,strong) UIColor *currentColor;
/** 其他圆点的颜色 */
@property (nonatomic,strong) UIColor *otherColor;

/** 构造方法 */
+ (instancetype)pageView;

@end
