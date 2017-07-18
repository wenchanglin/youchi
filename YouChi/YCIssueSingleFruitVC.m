//
//  YCIssueSingleFruitVC.m
//  YouChi
//
//  Created by 李李善 on 15/5/21.
//  Copyright (c) 2015年 Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Guangzhou QuicklyANT Information Technology Co.,LTD. All rights reserved.
//

#import "YCIssueSingleFruitVC.h"
#import "YCRandomPicturesVC.h"
#import "YCMaterialVC.h"

@interface YCIssueSingleFruitVC ()


@end

@implementation YCIssueSingleFruitVC
- (void)dealloc{
    //ok
}
#pragma mark - 生命周期
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0.8];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.closeButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
    [UIView animateWithDuration:0.5 animations:^{
        self.closeButton.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.closeButton.transform = CGAffineTransformMakeRotation(M_PI/4*3);

    }];
}


#pragma mark - 
// 添加随手拍，添加秘籍按钮
- (IBAction)onAddBtns:(UIButton *)button {
        
    //调用系统设备
    if (button.tag==1)

    {
        [self pushTo:[YCRandomPicturesVC class]];
        /*
        // 判断是否支持相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        }
        else
        {
            //如果没有提示用户
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示!!!" message:@"当前设备不支持照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
         */
     }
    
    //添加图片发果单
    else if (button.tag==2)
    {
       
        [self pushTo:[YCMaterialVC class]];
        
        
    }
    //取消按钮
    else
    {
      
        
    }

}

/*

#pragma mark--- 拍摄完成后要执行的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self pushTo:[YCSuishoupaiVC class]];
    }];

    
    
    
//    [self.navigationController pushViewController:IssueCasuaFlmVC animated:YES];
   
   
    
//    //得到图片
//    
//    UIImage * image =[info objectForKey:UIImagePickerControllerOriginalImage];
//    
//    //    dispatch_async(dispatch_get_main_queue(), ^{
//    //
//    //    });
//    
//    //图片存入相册
//    //    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    //     if (image==nil){}
//    //    else
//    //    {
//    //       [_imageViews addObject:image];
//    //
//    //        for (int i = 0; i< _imageViews.count; i++) {
//    //           }
//    //
//    //    }
 
}





//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
//    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"YCIssueCasuaFlmVC" bundle:nil];
//            YCIssueCasuaFlmVC *IssueCasuaFlmVC = [sb instantiateInitialViewController];
//     [self.navigationController pushViewController:IssueCasuaFlmVC animated:YES];
////    [self presentViewController:IssueCasuaFlmVC animated:YES completion:nil];
//    
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self onClose:nil];
}

// 关闭
- (IBAction)onClose:(id)sender {
    [self.navigationController.view removeFromSuperview];
    [self.navigationController removeFromParentViewController];
    [self.navigationController didMoveToParentViewController:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
