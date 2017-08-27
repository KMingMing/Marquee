//
//  MarqueeScrollView.m
//  Marquee
//
//  Created by 孔志林 on 2017/8/27.
//  Copyright © 2017年 KZL. All rights reserved.
//

#import "MarqueeScrollView.h"

#define ViewWidth  self.bounds.size.width
#define ViewHeight self.bounds.size.height

@interface MarqueeScrollView ()
/**  定时器    */
@property (nonatomic, strong) CADisplayLink *timer;
/**  label的总宽度不包括间距inteval    */
@property (nonatomic, assign) CGFloat width;
/**  滚动视图的宽度    */
@property (nonatomic, assign) CGFloat scrollViewWidth;
/**  需要展示的数据数组    */
@property (nonatomic, strong) NSArray *dataArray;
/**  每条数据之间的间隔    */
@property (nonatomic, assign) CGFloat inteval;
/**  label的字体大小    */
@property (nonatomic, assign) CGFloat fontSize;

@end

@implementation MarqueeScrollView
- (instancetype)initWithFrame:(CGRect)frame inteval:(CGFloat)inteval dataSourceArray:(NSArray *)array fontSize:(CGFloat)fontSize{
    if (self = [super initWithFrame:frame]) {
        self.inteval = inteval;
        self.dataArray = array;
        self.fontSize = fontSize;
        [self initWithSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"请使用-(instancetype)initWithFrame:(CGRect)frame inteval:(CGFloat)inteval dataSourceArray:(NSArray *)array fontSize:(CGFloat)fontSize;初始化");
    return nil;
}

- (instancetype)init {
    NSAssert(NO, @"请使用-(instancetype)initWithFrame:(CGRect)frame inteval:(CGFloat)inteval dataSourceArray:(NSArray *)array fontSize:(CGFloat)fontSize;初始化");
    return nil;
}

- (void)layoutIfNeeded {
    [super layoutIfNeeded];
    [self initWithSubViews];
}

#pragma mark - Private
- (void)initWithSubViews {
    self.clipsToBounds = YES;
    _width = 0;
    _scrollViewWidth = 0;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    _scrollViewWidth = 0.0;
    CGFloat labelX = 0.0;
    if (!(self.dataArray.count > 0)) {//如果数组为空不做任何操作
        return;
    }
    for (int i = 0; i < self.dataArray.count; i++) {
        CGFloat width =  [self widthWithHeight:ViewHeight andFont:_fontSize object:self.dataArray[i]].width;
        _width = width + _width;
    }
    _scrollViewWidth = _width + (self.dataArray.count - 1) * self.inteval;
    if (_scrollViewWidth > self.bounds.size.width && self.bounds.size.width != 0) {//此时需要滚动
        self.dataArray = [self settingWithArray:self.dataArray];//对数组进行处理
    }
    _width = 0;//重新初始化为0.
    for (int i = 0; i < self.dataArray.count; i++) {
        CGFloat width =  [self widthWithHeight:ViewHeight andFont:_fontSize object:self.dataArray[i]].width;
        _width = width + _width;
        labelX = _width + i * self.inteval - width;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, width, ViewHeight)];
        [self addSubview:label];
        label.text = self.dataArray[i];
        label.font = [UIFont systemFontOfSize:_fontSize];
//        label.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.0 green:arc4random() % 255 / 255.0 blue:arc4random() % 255 / 255.0 alpha:1];
    }
    _scrollViewWidth = _width + (self.dataArray.count - 1) * self.inteval;
    self.contentSize = CGSizeMake(_scrollViewWidth, ViewHeight);
    if (self.bounds.size.width != 0 && _width > self.bounds.size.width) {
        CGFloat lastWidth = [self widthWithHeight:ViewHeight andFont:_fontSize object:self.dataArray[0]].width;
        self.contentOffset = CGPointMake(lastWidth + self.inteval, 0);
        [self startTimer];
    }
}

- (NSArray *)settingWithArray:(NSArray *)array {
    NSMutableArray *settingarray = [NSMutableArray arrayWithArray:array];
    id firstObject = [settingarray firstObject];
    id larstObject = [settingarray lastObject];
    [settingarray insertObject:firstObject atIndex:array.count];
    [settingarray insertObject:larstObject atIndex:0];
    return settingarray;
}

- (void)timerStart {
    
    CGFloat lastWidth = [self widthWithHeight:ViewHeight andFont:_fontSize object:self.dataArray[0]].width;
    CGFloat firstWidth = [self widthWithHeight:ViewHeight andFont:_fontSize object:[self.dataArray lastObject]].width;
    CGFloat rate = self.rate ? self.rate : 0.5;
    self.contentOffset = CGPointMake(self.contentOffset.x + rate, 0);
    if (self.contentOffset.x >  _scrollViewWidth - ViewWidth) {
        self.contentOffset = CGPointMake(lastWidth + self.inteval + firstWidth - ViewWidth, 0);
    }
}

/* 开启定时器 */
- (void)startTimer {
    if (!self.timer) {
        self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerStart)];
        [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        self.timer.frameInterval = 1;
    }
}

/* 关闭定时器 */
- (void)closeTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}
- (void)changeTimerState {
    self.timer.paused = !self.timer.paused;
}

#pragma mark - 计算字符串尺寸
/**
 *  计算字符串尺寸 （多行）
 *
 *  @param height 字符串的宽度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)widthWithHeight:(CGFloat)height andFont:(CGFloat)font object:(NSString *)string{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize  size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)   attributes:attribute context:nil].size;
    return size;
}
/**
 *  计算字符串高度 （多行）
 *
 *  @param width 字符串的宽度
 *  @param font  字体大小
 *
 *  @return 字符串的尺寸
 */
- (CGSize)heightWithWidth:(CGFloat)width andFont:(CGFloat)font object:(NSString *)string{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize  size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)  options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)  attributes:attribute context:nil].size;
    return size;
}


@end
