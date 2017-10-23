//
//  MyActionSheet.m
//  艺术蜥蜴
//
//  Created by admin on 15/3/10.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "MyActionSheet.h"

@interface MyActionSheet ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,returnImageDelegate>
@end

@implementation MyActionSheet


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;

    }
    return self;
}
- (void)actionShow{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_delegate myActionSheetMutiSelectDelegate:nil info:nil];
    }];
    UIAlertAction *photographAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithIndex:0];
        
    }];
    UIAlertAction *selectPhotoAction = [UIAlertAction actionWithTitle:@"选取照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self takePhotoWithIndex:1];
        
    }];
    
    [alertController addAction:photographAction];
    [alertController addAction:selectPhotoAction];
    [alertController addAction:cancleAction];
    
    [_sourceVC presentViewController:alertController animated:YES completion:nil];

}
- (void)removeView{
    [self removeFromSuperview];
}

//#pragma mark - 选取照片和拍照
-(void)takePhotoWithIndex:(NSInteger )index
{
    
    UIImagePickerController * mipc = [[UIImagePickerController alloc] init];
    switch (index) {
        case 1:{
            // 判断设备是否支持相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
               
                [_delegate myActionSheetMutiSelectDelegate:nil info:@"设备不支持相册功能"];
                return ;
            }
            
            [[PhotoTool sharePhotoTool]requestAuthorizatio:[self viewController] comeplete:^(BOOL state) {
                if (state) {
                    if (_isMutiSelect) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                        UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"PhotoGroup" bundle:nil];
                        PhotoGroupTableViewController *photoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PhotoGroupTableViewController"];
                        photoTVC.maxPhotoNumber = self.maxPhotoNumber;
                        photoTVC.delegate = self;
                        
                        
                        [_sourceVC.navigationController pushViewController:photoTVC animated:YES];
                        });
                    }else{
                        mipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                        mipc.delegate = self;//委托
                        mipc.allowsEditing = self.isEdit;//是否可编辑照片
                        mipc.mediaTypes=[NSArray arrayWithObjects:@"public.image",nil];
                        // 设置可用媒体类型
                        [_sourceVC presentViewController:mipc animated:YES completion:^(void){
                            
                        }];
                    }

                }else{
                    NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
                    NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
                    
                    [_delegate myActionSheetMutiSelectDelegate:nil info:[NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName]];
                    return ;
                }
            }];
        }
                     break;
        case 0:{
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {


                [_delegate myActionSheetMutiSelectDelegate:nil info:@"设备不支持访问照相机"];
                return;
            }
            
            mipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
            mipc.delegate = self;//委托
            mipc.allowsEditing = self.isEdit;//是否可编辑照片
            mipc.mediaTypes=[NSArray arrayWithObjects:@"public.image",nil];

            [_sourceVC presentViewController:mipc animated:YES completion:^(void){
                //        NSLog(@"1");
                //        NSLog(@"%@",NSHomeDirectory());
            }];
            
            break;
        }
        
    }
}

- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
        
    }
    return nil;
}
- (void)returnImageDelegate:(NSMutableArray *)array{
    [_delegate myActionSheetMutiSelectDelegate:array info:nil];
    [_sourceVC dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - <UIImagePickerControllerDelegate>代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
        UIImage* image = self.isEdit ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    
    if (image) {
        UIImage * compressImage =[self imageWithImage:image scaledToSize:CGSizeMake(Screen_Width, image.size.height * Screen_Width/ image.size.width)];
        //               UIImage * image =[self imageWithImage:(UIImage*)imageArray[i] scaledToSize:CGSizeMake(320, 107)];
        NSData * data =  UIImageJPEGRepresentation(compressImage,0.50); //将拍下的图片转化成data
        UIImage *compressEndImage = [UIImage imageWithData:data];
        [images addObject:compressEndImage];
        [_delegate myActionSheetMutiSelectDelegate:images info:nil];
        

        [_sourceVC dismissViewControllerAnimated:YES completion:nil];

    }else{

        [_delegate myActionSheetMutiSelectDelegate:nil info:@"没有选择图片或图片错误，请重试"];
    }
   
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [_sourceVC dismissViewControllerAnimated:YES completion:nil];

}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
