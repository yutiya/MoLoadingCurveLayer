//
//  ViewController.m
//  MoLoadingCurveLayer
//
//  Created by admin on 15/11/24.
//  Copyright © 2015年 Meone. All rights reserved.
//

#import "ViewController.h"
#import "MoView.h"

@interface ViewController ()

@property (nonatomic, weak) MoView *moview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MoView *moview = [[MoView alloc] initWithFrame:CGRectMake(90, 300, 0, 0)];
    [self.view addSubview:moview];
    self.moview = moview;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 80, 200, 20)];
    [button setTitle:@"startAnimation" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *sbutton = [[UIButton alloc] initWithFrame:CGRectMake(35, 110, 100, 20)];
    [sbutton setTitle:@"success" forState:UIControlStateNormal];
    [sbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:sbutton];
    [sbutton addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *ebutton = [[UIButton alloc] initWithFrame:CGRectMake(160, 110, 100, 20)];
    [ebutton setTitle:@"error" forState:UIControlStateNormal];
    [ebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:ebutton];
    [ebutton addTarget:self action:@selector(error) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction
{
    if (self.moview) {
        [self.moview startLoading];
    }
}

- (void)success
{
    [self.moview success:^{
        NSLog(@"controller完成");
    }];
}

- (void)error
{
    [self.moview error:^{
        NSLog(@"controller失败");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
