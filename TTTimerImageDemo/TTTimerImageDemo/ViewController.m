//
//  ViewController.m
//  TTTimerImageDemo
//
//  Created by 梁腾 on 16/3/16.
//  Copyright © 2016年 TT. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,assign) NSUInteger page;




@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 0;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(10, 100, 350, 200)];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(150, 200, 50, 20)];
    self.scrollView.delegate = self;
  
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pageControl];
    for (int i = 0; i<3; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i+1] ofType:@"png"]];
        CGFloat W = 350;
        CGFloat H = 200;
        CGFloat X = i * W;
        CGFloat Y = 0;
        imgView.frame = CGRectMake(X, Y, W, H);
        [self.scrollView addSubview:imgView];
    }
    
    CGSize contenSize = CGSizeMake(self.scrollView.frame.size.width * 3, 0);
    self.scrollView.contentSize = contenSize;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.pageControl.numberOfPages = 3;
    
    //添加定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0f target:self selector:@selector(changeNextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    // 更新UI只能在主线程进行
    // 定时器的工作也只能在主线程进行
    // 一个线程 同一个时间,只能干一件事
    // 获得主线程对应的消息循环
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

- (void)changeNextImage{
    

    if (self.pageControl.currentPage == 2) {
       _page = 0;
        
    }else{
        _page = self.pageControl.currentPage + 1;
    }
    CGFloat offset = self.scrollView.frame.size.width*_page;
    [self.scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat scrollViewW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x+scrollViewW*0.5)/scrollViewW;
    self.pageControl.currentPage = page;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"%s", __func__);
    // 废除定时器, 一旦废除的定时器, 就重新开启不了
    [self.timer invalidate];
    self.timer = nil;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%s", __func__);
    
    // 重新开启(创建)定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(changeNextImage) userInfo:nil repeats:YES];
    
}

@end
