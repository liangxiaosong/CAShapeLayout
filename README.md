# CAShapeLayout

/*设置画板的基本属性*/
LXSDrawView 
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
/*画布 通过LXSBrush可更改画笔的颜色 线宽等*/
LXSCanvas
/*封装的画笔类*/
LXSBrush
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

