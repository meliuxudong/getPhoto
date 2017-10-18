//
//  getPhoto.m
//  iOS9Sample-Photos
//
//  Created by admin on 2017/10/17.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import "getPhoto.h"

@interface getPhoto()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,returnImageDelegate>
@end

@implementation getPhoto
- (void)actionShow{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_delegate myActionSheetMutiSelectDelegate:nil];
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
    
    [_vc presentViewController:alertController animated:YES completion:nil];
    
}


//#pragma mark - 选取照片和拍照
-(void)takePhotoWithIndex:(NSInteger )index
{
    
    UIImagePickerController * mipc = [[UIImagePickerController alloc] init];
    switch (index) {
        case 1:
            // 判断设备是否支持相册
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                
                [_delegate myActionSheetMutiSelectDelegate:nil];
                return ;
            }
            
            if (_isMutiSelect) {
                
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"PhotoGroup" bundle:nil];
                PhotoGroupTableViewController *photoTVC = [storyboard instantiateViewControllerWithIdentifier:@"PhotoGroupTableViewController"];
                photoTVC.maxPhotoNumber = self.maxPhotoNumber;
                photoTVC.delegate = self;
                
                //                ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
                //
                //                elcPicker.maximumImagesCount = self.maxPhotoNumber; //Set the maximum number of images to select to 100
                //                elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
                //                elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
                //                elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
                //                elcPicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie]; //Supports image and movie types (NSString *)kUTTypeMovie
                //
                //                elcPicker.imagePickerDelegate = self;
                //                [[NSNotificationCenter defaultCenter]postNotificationName:@"showButton" object:nil];
                [_vc.navigationController pushViewController:photoTVC animated:YES];
                
            }else{
                mipc.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                mipc.delegate = self;//委托
                mipc.allowsEditing = self.isEdit;//是否可编辑照片
                mipc.mediaTypes=[NSArray arrayWithObjects:@"public.image",nil];
                // 设置可用媒体类型
                [_vc presentViewController:mipc animated:YES completion:^(void){
                    
                }];
            }
            break;
        case 0:{
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                //                [self.hud showErrorWithMessage:@"设备不支持访问照相机" duration:1.2f];
                
                [_delegate myActionSheetMutiSelectDelegate:nil];
                return;
            }
            
            mipc.sourceType =  UIImagePickerControllerSourceTypeCamera;
            mipc.delegate = self;//委托
            mipc.allowsEditing = self.isEdit;//是否可编辑照片
            mipc.mediaTypes=[NSArray arrayWithObjects:@"public.image",nil];
            
            [_vc presentViewController:mipc animated:YES completion:^(void){
               
            }];
            
            break;
        }
       
    }
}


- (void)returnImageDelegate:(NSMutableArray *)array{
    [_delegate myActionSheetMutiSelectDelegate:array];

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
        [_delegate myActionSheetMutiSelectDelegate:images];
        
        //    [_delegate myActionSheetDelegate:info];

        
    }else{
        //        [self.hud showErrorWithMessage:@"没有选择图片或图片错误，请重试" duration:1.5f complection:nil];
    }
    

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
   
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
