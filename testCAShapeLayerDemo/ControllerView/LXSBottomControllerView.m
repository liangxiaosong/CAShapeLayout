//
//  LXSControllerView.m
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/19.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSBottomControllerView.h"

@interface LXSBottomControllerView ()

@property (nonatomic, strong) NSArray            *buttomTitle;

@end

@implementation LXSBottomControllerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.buttomTitle = @[@"圆",@"椭圆",@"矩形",@"爱心"];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    UIButton *tempButtom;
    for (int i = 0; i < self.buttomTitle.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:self.buttomTitle[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tempButtom ? tempButtom.mas_right : self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(50, self.frame.size.height));
        }];
        tempButtom = button;
        button.tag = i;
        [button addTarget:self action:@selector(buttonActive:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - activeBtn

- (void)buttonActive:(UIButton *)sender {
    if (self.buttonTagBlock) {
        self.buttonTagBlock(sender.tag);
    }
}

@end
