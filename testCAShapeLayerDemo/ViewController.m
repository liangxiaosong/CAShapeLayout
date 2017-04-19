//
//  ViewController.m
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/18.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "ViewController.h"
#import "LXSDrawView.h"
#import "LXSBottomControllerView.h"
#import "LXSTopControllerView.h"
#import "ReactiveObjC.h"

@interface ViewController ()
{
    LXSDrawView *drawView;
    UIImageView *bgImgView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    LXSTopControllerView *topView = [[LXSTopControllerView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 50)];
    [self.view addSubview:topView];

    //画板
    drawView = [[LXSDrawView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame), UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 50 - 50 - 20)];
    drawView.brushColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00];
    drawView.brushWidth = 3;
    drawView.shapeType = LXSShapeCurve;
    [self.view insertSubview:drawView atIndex:0];

    //底部 工具栏
    LXSBottomControllerView *bottomView = [[LXSBottomControllerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(drawView.frame), UI_SCREEN_WIDTH, 50)];
    [self.view addSubview:bottomView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
