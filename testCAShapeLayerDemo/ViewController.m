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
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate>
{
    LXSDrawView *drawView;
    UIImageView *bgImgView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

    LXSTopControllerView *topView = [[LXSTopControllerView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 50)];
    [self.view addSubview:topView];
    @weakify(self);
    [topView setButtonBlack:^(NSInteger tag){
        @strongify(self);
        [self buttonActiveBlack:tag];
    }];

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

//block回调的方法
- (void)buttonActiveBlack:(NSInteger)tag {
    if (tag == 0) {//更换背景
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //初始化UIImagePickerController
            UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
            //获取方式1：通过相册（呈现全部相册），UIImagePickerControllerSourceTypePhotoLibrary
            //获取方方式3，通过相册（呈现全部图片），UIImagePickerControllerSourceTypeSavedPhotosAlbum
            PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//方式1
            //允许编辑，即放大裁剪
            PickerImage.allowsEditing = YES;
            //自代理
            PickerImage.delegate = self;
            //页面跳转
            [self presentViewController:PickerImage animated:YES completion:nil];
        }]];
        //按钮：取消，类型：UIAlertActionStyleCancel
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //info是所选择照片的信息
    //UIImagePickerControllerEditedImage//编辑过的图片
    //UIImagePickerControllerOriginalImage//原图
    NSLog(@"info === %@",info);
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    drawView.backgroundImage = resultImage;
    //使用模态返回到软件界面
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    NSLog(@"editingInfo **** %@",editingInfo);
}

@end
