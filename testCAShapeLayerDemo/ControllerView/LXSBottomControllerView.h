//
//  LXSControllerView.h
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/19.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXSBottomControllerView : UIView

@property (nonatomic, copy) void (^buttonTagBlock) (NSInteger tag);

@end
