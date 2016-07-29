//
//  PYCarouselView.m
//  图片轮播
//
//  Created by PodiMac on 16/7/29.
//  Copyright © 2016年 com.puyang.liveVideo. All rights reserved.
//

#import "PYCarouselView.h"
#import "UIImageView+WebCache.h"
#define  ZSPlaceHOLDERIMAGE @""

@interface PYCarouselView()<UIScrollViewDelegate>
@property (weak, nonatomic)UIScrollView *scrollView;
@property (weak, nonatomic)UIPageControl *pageView;
@property (strong, nonatomic)NSTimer *timer;
@end
@implementation PYCarouselView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        //        [self prepareScollView];
        //        [self preparePageView];
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    //    [self prepareScollView];
    //    [self preparePageView];
}
-(void)setImageUrlArr:(NSArray *)imageUrlArr
{
    if (_imageUrlArr)
    {
        for (UIView *view in [self subviews])
        {
            [view removeFromSuperview];
        }
    }
    _imageUrlArr=imageUrlArr;
    [self prepareScollView];
    [self preparePageView];
}
- (void)prepareScollView {
    CGFloat scrollW = [UIScreen mainScreen].bounds.size.width;
    CGFloat scrollH = self.bounds.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, scrollW, scrollH)];
    scrollView.delegate = self;
    for (int i = 0; i < self.imageUrlArr.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *name = [self.imageUrlArr objectAtIndex:i];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        if ([name hasPrefix:@"http://"]||[name hasPrefix:@"https://"])
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:ZSPlaceHOLDERIMAGE]];
        }else
        {
            imageView.image = [UIImage imageNamed:name];
        }
        
        CGFloat imageX = scrollW * (i + 1);
        imageView.frame = CGRectMake(imageX, 0, scrollW, scrollH);
        [scrollView addSubview:imageView];
    }
    
    UIImageView *firstImage = [[UIImageView alloc] init];
    NSString *firstname = [self.imageUrlArr lastObject];
    [firstImage setContentMode:UIViewContentModeScaleAspectFill];
    if ([firstname hasPrefix:@"http://"]||[firstname hasPrefix:@"https://"])
    {
        [firstImage sd_setImageWithURL:[NSURL URLWithString:firstname] placeholderImage:[UIImage imageNamed:ZSPlaceHOLDERIMAGE]];
    }else
    {
        firstImage.image = [UIImage imageNamed:firstname];
    }
    firstImage.frame = CGRectMake(0, 0, scrollW, scrollH);
    [scrollView addSubview:firstImage];
    scrollView.contentOffset = CGPointMake(scrollW, 0);
    
    UIImageView *lastImage = [[UIImageView alloc] init];
    NSString*  lastName=[self.imageUrlArr firstObject];
    [lastImage setContentMode:UIViewContentModeScaleAspectFill];
    if ([lastName hasPrefix:@"http://"]||[lastName hasPrefix:@"https://"])
    {
        [lastImage sd_setImageWithURL:[NSURL URLWithString:firstname] placeholderImage:[UIImage imageNamed:ZSPlaceHOLDERIMAGE]];
    }else
    {
        lastImage.image = [UIImage imageNamed:firstname];
    }
    lastImage.frame = CGRectMake((self.imageUrlArr.count + 1) * scrollW, 0, scrollW, scrollH);
    [scrollView addSubview:lastImage];
    scrollView.contentSize = CGSizeMake((self.imageUrlArr.count + 2) * scrollW, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    if (self.imageUrlArr.count>1)
    {
        [self addTimer];
        self.pageView.hidden=NO;
    }else
    {
        self.pageView.hidden=YES;
    }
    
}

- (void)addTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)nextImage {
    CGFloat width = self.scrollView.frame.size.width;
    NSInteger index = self.pageView.currentPage;
    if (index == self.imageUrlArr.count + 1) {
        index = 0;
    } else {
        index++;
    }
    [self.scrollView setContentOffset:CGPointMake((index + 1) * width, 0)animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat width = self.scrollView.frame.size.width;
    int index = (self.scrollView.contentOffset.x + width * 0.5) / width;
    if (index == self.imageUrlArr.count + 2) {
        index = 1;
    } else if(index == 0) {
        index = (int)self.imageUrlArr.count;
    }
    self.pageView.currentPage = index - 1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.imageUrlArr.count>1)
    {
        [self addTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = self.scrollView.frame.size.width;
    int index = (self.scrollView.contentOffset.x + width * 0.5) / width;
    if (index == self.imageUrlArr.count + 1)
    {
        [self.scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
    } else if (index == 0)
    {
        [self.scrollView setContentOffset:CGPointMake(self.imageUrlArr.count * width, 0) animated:NO];
    }
}

-(void)preparePageView {
    CGFloat width = self.bounds.size.width;
    CGFloat pageW = self.bounds.size.width;
    UIPageControl *pageView = [[UIPageControl alloc] initWithFrame:CGRectMake((width - pageW) * 0.5, self.bounds.size.height-10, pageW, 4)];
    pageView.numberOfPages = self.imageUrlArr.count;
    pageView.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageView.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageView.currentPage = 0;
    [self addSubview:pageView];
    self.pageView = pageView;
    if (self.imageUrlArr.count>1)
    {
        self.pageView.hidden=NO;
    }else
    {
        self.pageView.hidden=YES;
    }
}
@end
