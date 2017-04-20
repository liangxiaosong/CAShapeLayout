//
//  LXSDrawView.m
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/18.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//

#import "LXSDrawView.h"
#import "LXSBaseModel.h"

//////////////////////////////////////////////////////////////

@implementation LXSBrush


@end

//////////////////////////////////////////////////////////////

@implementation LXSCanvas

+ (Class)layerClass {
    return ([CAShapeLayer class]);
}

- (void)setBrush:(LXSBrush *)brush {
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.strokeColor = brush.brushColor.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    //lineJoin（线条之间的结合点的样子）
    shapeLayer.lineJoin = kCALineJoinRound;
    //lineCap（线条结尾的样子），
    shapeLayer.lineCap = kCALineCapRound;
    //lineWith 线宽
    shapeLayer.lineWidth = brush.brushWidth;

    if (!brush.isEraser)
    {
        ((CAShapeLayer *)self.layer).path = brush.bezierPath.CGPath;
    }
}

@end

/////////////////////////////////////////////////////////////////

@interface LXSDrawView ()
{
    CGPoint pts[5];
    uint ctr;
}

//画笔容器
@property (nonatomic, strong) NSMutableArray        *brushArray;
//撤销容器
@property (nonatomic, strong) NSMutableArray        *undoArray;
//重做容器
@property (nonatomic, strong) NSMutableArray        *redoArray;
//合成View
@property (nonatomic, strong) UIImageView           *composeView;
//画板View
@property (nonatomic, strong) LXSCanvas              *canvasView;

//linyl
//记录脚本用
@property (nonatomic, strong) LXSDrawFile            *dwawFile;
//每次touchsbegin的时间，后续为计算偏移量用
@property (nonatomic, strong) NSDate                *beginDate;

//绘制脚本用
@property (nonatomic, strong) NSMutableArray        *recPackageArray;

@end

@implementation LXSDrawView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];

        UIImage *backImage = [UIImage imageNamed:@"LPPZ_login_back"];
        self.layer.contents = (id)backImage.CGImage;

        self.brushArray = [NSMutableArray arrayWithCapacity:0];
        self.undoArray = [NSMutableArray arrayWithCapacity:0];
        self.redoArray = [NSMutableArray arrayWithCapacity:0];

        self.composeView = [[UIImageView alloc] init];
        self.composeView.frame = self.bounds;
        [self addSubview:self.composeView];

        _canvasView = [LXSCanvas new];
        _canvasView.frame = _composeView.bounds;

        [_composeView addSubview:_canvasView];

        _brushColor = LXSDEF_BRUSH_COLOR;
        _brushWidth = LXSDEF_BRUSH_WIDTH;
        _isEraser = NO;
        _shapeType = LXSDEF_BRUSH_SHAPE;

        //linyl
        _dwawFile = [LXSDrawFile new];
        _dwawFile.packageArray = [NSMutableArray new];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    LXSBrush *brush = [[LXSBrush alloc] init];
    brush.brushColor = _brushColor;
    brush.brushWidth = _brushWidth;
    brush.isEraser = _isEraser;
    brush.shapeType = _shapeType;
    brush.beginPoint = point;

    brush.bezierPath = [UIBezierPath new];
    [brush.bezierPath moveToPoint:point];

    [self.brushArray addObject:brush];

    //每次画线前，都清除重做列表。
    [self cleanRedoArray];
    ctr = 0;
    pts[0] = point;
    //linyl
    _beginDate = [NSDate date];

    LXSBrushModel *brushModel = [[LXSBrushModel alloc] init];
    brushModel.brushColor = _brushColor;
    brushModel.brushWidth = _brushWidth;
    brushModel.shapeType = _shapeType;
    brushModel.isEraser = _isEraser;
    brushModel.beginPoint = [LXSPointModel new];
    brushModel.beginPoint.xPoint = point.x;
    brushModel.beginPoint.yPoint = point.y;
    brushModel.beginPoint.timeOffset = 0;

    [self addModelToPackage:brushModel];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    LXSBrush *brush = [self.brushArray lastObject];
    //linyl
    LXSDrawPackage *drawPackage = [_dwawFile.packageArray lastObject];

    LXSPointModel *pointModel = [[LXSPointModel alloc] init];
    pointModel.xPoint = point.x;
    pointModel.yPoint = point.y;
    pointModel.timeOffset = fabs(_beginDate.timeIntervalSinceNow);

    [drawPackage.pointOrBrushArray addObject:pointModel];
    //linyl
    if (_isEraser) {

    }else {
        switch (self.shapeType) {
            case LXSShapeCurve://曲线(默认)
            {
                ctr ++;
                pts[ctr] = point;
                if (ctr == 4) {
                    pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0);
                    [brush.bezierPath moveToPoint:pts[0]];
                    [brush.bezierPath addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]];
                    pts[0] = pts[3];
                    pts[1] = pts[4];
                    ctr = 1;
                }
            }
                break;
            case LXSShapeLine://直线
            {

            }
                break;
            case LXSShapeEllipse://椭圆
            {

            }
                break;
            case LXSShapeRect://矩形
            {

            }
                break;
            default:
                break;
        }
    }
    //在画布上画线
    [_canvasView setBrush:brush];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    uint count = ctr;
    if (count <= 4 && _shapeType == LXSShapeCurve)
    {
        for (int i = 4; i > count; i--)
        {
            [self touchesMoved:touches withEvent:event];
        }
        ctr = 0;
    }
    else
    {
        [self touchesMoved:touches withEvent:event];
    }
    //画布view与合成view 合成为一张图（使用融合卡）
    UIImage *img = [self composeBrushToImage];
    //清空画布
    [_canvasView setBrush:nil];
    //保存到存储，撤销用。
    [self saveTempPic:img];

    //linyl
    CGPoint point = [[touches anyObject] locationInView:self];

    LXSBrushModel *brushModel = [LXSBrushModel new];
    brushModel.brushColor = _brushColor;
    brushModel.brushWidth = _brushWidth;
    brushModel.shapeType = _shapeType;
    brushModel.isEraser = _isEraser;
    brushModel.endPoint = [LXSPointModel new];
    brushModel.endPoint.xPoint = point.x;
    brushModel.endPoint.yPoint = point.y;
    brushModel.endPoint.timeOffset = fabs(_beginDate.timeIntervalSinceNow);;

    LXSDrawPackage *drawPackage = [_dwawFile.packageArray lastObject];

    [drawPackage.pointOrBrushArray addObject:brushModel];

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}


- (UIImage *)composeBrushToImage
{
    /*
     size——同UIGraphicsBeginImageContext
     opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
     scale—–缩放因子
     */
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();
    [_composeView.layer renderInContext:context];

    UIImage *getImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    _composeView.image = getImage;

    return getImage;
}


- (void)cleanRedoArray
{
    for(NSString *picPath in _redoArray)
    {
        [self deleteTempPic:picPath];
    }
    [_redoArray removeAllObjects];
}

- (void)deleteTempPic:(NSString *)picPath
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:picPath error:nil];
}

- (void)addModelToPackage:(LXSDrawModel*)drawModel
{
    LXSDrawPackage *drawPackage = [LXSDrawPackage new];
    drawPackage.pointOrBrushArray = [NSMutableArray new];

    [drawPackage.pointOrBrushArray addObject:drawModel];
    [_dwawFile.packageArray addObject:drawPackage];
}

- (void)saveTempPic:(UIImage*)img
{
    if (img)
    {
        //这里切换线程处理
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            NSDate *date = [NSDate date];
            NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"HHmmssSSS"];
            NSString *now = [dateformatter stringFromDate:date];

            NSString *picPath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingFormat:@"/tmp/"], now];
            NSLog(@"存贮于   = %@",picPath);

            BOOL bSucc = NO;
            NSData *imgData = UIImagePNGRepresentation(img);


            if (imgData)
            {
                bSucc = [imgData writeToFile:picPath atomically:YES];
            }

            dispatch_async(dispatch_get_main_queue(), ^{

                if (bSucc)
                {
                    [_undoArray addObject:picPath];
                }

            });
        });
    }

}

#pragma mark - set / get

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    self.layer.contents = (id)backgroundImage.CGImage;
}

@end
