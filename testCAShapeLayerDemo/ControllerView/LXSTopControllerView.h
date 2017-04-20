//
//  LXSTopControllerView.h
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/19.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXSTopControllerView : UIView
//按钮点击事件的回调
@property (nonatomic, copy) void (^buttonBlack) (NSInteger tag);

@end
