//
//  ViewController.m
//  Marquee
//
//  Created by 孔志林 on 2017/8/27.
//  Copyright © 2017年 KZL. All rights reserved.
//

#import "ViewController.h"
#import "MarqueeScrollView.h"
@interface ViewController ()
/**  滚动视图    */
@property (nonatomic, strong) MarqueeScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = CGRectMake(20, 60, [UIScreen mainScreen].bounds.size.width - 40,30);
    [self.scrollView layoutIfNeeded];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (MarqueeScrollView *)scrollView {
    if (!_scrollView) {
//        NSArray *oneArray = @[@"只有一条数据，字数不多，不会滚动"];
        NSArray *twoArray = @[@"只有一条数据，但是字数超过了范围展示不下，此时会滚动哦😝😝😝"];
//        NSArray *threeArray = @[@"有两条数据",@"有3条数据数据数据数据数据数据,有3条数据"];
        _scrollView = [[MarqueeScrollView alloc] initWithFrame: CGRectZero inteval:20 dataSourceArray:twoArray fontSize:16];
        _scrollView.backgroundColor = [UIColor redColor];
    }
    return _scrollView;
}
@end
