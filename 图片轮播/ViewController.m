//
//  ViewController.m
//  图片轮播
//
//  Created by PodiMac on 16/7/29.
//  Copyright © 2016年 com.puyang.liveVideo. All rights reserved.
//

#import "ViewController.h"
#import "PYCarouselView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet PYCarouselView *carouselView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.carouselView.imageUrlArr=@[@"img_home_banner",@"img_home_banner02"];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
