//
//  LXSDrawView.h
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/18.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LXSDEF_BRUSH_COLOR [UIColor colorWithRed:255 green:0 blue:0 alpha:1.0]

#define LXSDEF_BRUSH_WIDTH 3

#define LXSDEF_BRUSH_SHAPE LXSShapeCurve

//画笔形状
typedef NS_ENUM(NSInteger, LXSShapeType)
{
    LXSShapeCurve = 0,//曲线(默认)
    LXSShapeLine,//直线
    LXSShapeEllipse,//椭圆
    LXSShapeRect,//矩形
    LXSRound,//圆
    LXSLove,//爱心

};

/////////////////////////////////////////////////////////////////////
//封装的画笔类
@interface LXSBrush : NSObject

//画笔颜色
@property (nonatomic, strong) UIColor *brushColor;

//画笔宽度
@property (nonatomic, assign) NSInteger brushWidth;

//是否是橡皮擦
@property (nonatomic, assign) BOOL isEraser;

//形状
@property (nonatomic, assign) LXSShapeType shapeType;

//路径
@property (nonatomic, strong) UIBezierPath *bezierPath;

//起点
@property (nonatomic, assign) CGPoint beginPoint;
//终点
@property (nonatomic, assign) CGPoint endPoint;

@end

////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////

@interface LXSCanvas : UIView

- (void)setBrush:(LXSBrush *)brush;

@end
/////////////////////////////////////////////////////////////////////

@interface LXSDrawView : UIView

//颜色
@property (strong, nonatomic) UIColor *brushColor;
//是否是橡皮擦
@property (assign, nonatomic) BOOL isEraser;
//宽度
@property (assign, nonatomic) NSInteger brushWidth;
//形状
@property (assign, nonatomic) LXSShapeType shapeType;
//背景图
@property (assign, nonatomic) UIImage *backgroundImage;



@end
