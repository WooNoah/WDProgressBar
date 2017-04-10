//
//  ViewController.m
//  WDProgressBar
//
//  Created by Noah on 17/4/10.
//  Copyright © 2017年 Noah. All rights reserved.
//

#import "ViewController.h"

#import "RRMyMaterialProgressBar.h"
#import "UIColor+Additional.h"
#import <Masonry.h>

#define UIScreenSize [UIScreen mainScreen].bounds.size
// 字体颜色16进制0x
#define DDHexColor(hexStr) [UIColor colorWithHexColorString:hexStr]
#define RandomColor [UIColor colorWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:1]

@interface ViewController ()

@property (nonatomic,strong) RRMyMaterialProgressBar *progress;
    
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.progress = [[RRMyMaterialProgressBar alloc]initWithFrame:CGRectMake(12, 100, UIScreenSize.width * 470/750, 20) totalStepsCounts:4 progressBarTintColor:DDHexColor(@"f79e07")];
    self.progress.layer.cornerRadius = 10.f;
    self.progress.layer.masksToBounds = YES;
    self.progress.backgroundColor = DDHexColor(@"dddddd");
    [self.view addSubview:self.progress];
    
    
    UIButton *button = [[UIButton alloc]init];
    [button setTitle:@"change" forState:UIControlStateNormal];
    button.backgroundColor = RandomColor;
    [button addTarget:self action:@selector(changeAnimate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progress.mas_bottom).offset(20);
        make.left.equalTo(self.progress);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.progress.currentPercentage = 0.21;
}
    
- (void)changeAnimate {
    CGFloat xiaoshu = arc4random()%101/100.0;
    
    self.progress.currentPercentage = xiaoshu;
}

    

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
