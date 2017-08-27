//
//  MarqueeScrollView.h
//  Marquee
//
//  Created by 孔志林 on 2017/8/27.
//  Copyright © 2017年 KZL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarqueeScrollView : UIScrollView
/**
 请使用这个方法初始化
 
 @param frame frame
 @param inteval 两个label之间的距离
 @param array 字符串数组，传入你想展示的字符串
 @param fontSize label的字体大小
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame inteval:(CGFloat)inteval dataSourceArray:(NSArray *)array fontSize:(CGFloat)fontSize;
/**
 关闭定时器
 */
- (void)closeTimer;
/**  暂停或者重启定时器    */
- (void)changeTimerState;
/**  控制滚动跳的速度 默认为0.5 越大越快 建议不超过1.5    */
@property (nonatomic, assign) CGFloat rate;

@end
