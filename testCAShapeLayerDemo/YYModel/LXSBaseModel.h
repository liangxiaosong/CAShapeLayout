//
//  LXSDrawView.m
//  testCAShapeLayerDemo
//
//  Created by LPPZ-User01 on 2017/4/18.
//  Copyright © 2017年 LPPZ-User01. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LXSBaseModel : NSObject<NSCopying,NSCoding>

-(void)encodeWithCoder:(NSCoder *)aCoder;

-(id)initWithCoder:(NSCoder *)aDecoder;

-(id)copyWithZone:(NSZone *)zone;

-(NSUInteger)hash;

-(BOOL)isEqual:(id)object;


@end

@interface LXSDrawModel : LXSBaseModel

@property (nonatomic, assign) NSInteger modelType;

@end



@interface LXSPointModel : LXSDrawModel

@property (nonatomic, assign) CGFloat xPoint;

@property (nonatomic, assign) CGFloat yPoint;

@property (nonatomic, assign) double timeOffset;

@end


@interface LXSBrushModel : LXSDrawModel

@property (nonatomic, copy) UIColor *brushColor;

@property (nonatomic, assign) CGFloat brushWidth;

@property (nonatomic, assign) NSInteger shapeType;

@property (nonatomic, assign) BOOL isEraser;

@property (nonatomic, copy) LXSPointModel *beginPoint;

@property (nonatomic, copy) LXSPointModel *endPoint;

@end

typedef NS_ENUM(NSInteger, LXSDrawAction)
{
    LXSDrawActionUnKnown = 1,
    LXSDrawActionUndo,
    LXSDrawActionRedo,
    LXSDrawActionSave,
    LXSDrawActionClean,
    LXSDrawActionOther,
};

@interface LXSActionModel : LXSDrawModel

@property (nonatomic, assign) LXSDrawAction ActionType;

@end

@interface LXSDrawPackage : LXSBaseModel

@property (nonatomic, strong) NSMutableArray<LXSDrawModel*> *pointOrBrushArray;

@end


@interface LXSDrawFile : LXSBaseModel

@property (nonatomic, strong) NSMutableArray<LXSDrawPackage*> *packageArray;

@end
