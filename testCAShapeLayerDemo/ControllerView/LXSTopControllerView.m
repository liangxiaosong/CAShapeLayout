//
//  LXSTopControllerView.m
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/19.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSTopControllerView.h"

#define buttonWidth (UI_SCREEN_WIDTH - (self.dataArray.count + 1) * 10)/ self.dataArray.count

@interface LXSTopControllerView ()

@property (nonatomic, strong) NSMutableArray            *dataArray;

@end

@implementation LXSTopControllerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray arrayWithArray:@[@"背景",@"撤销",@"保存",@"分享"]];
        [self addSubControls];
    }
    return self;
}

- (void)addSubControls {
    UIButton *tempBtn;
    for (int i = 0; i < self.dataArray.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(tempBtn ? tempBtn.mas_right : self.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(buttonWidth, self.bounds.size.height));
        }];
        tempBtn = button;

        [button setTitle:self.dataArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        button.tag = i;
        [button addTarget:self action:@selector(activeButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark --- active

- (void)activeButton:(UIButton *)sender {
    if (self.buttonBlack) {
        self.buttonBlack(sender.tag);
    }
}

@end
