//
//  getPhoto.h
///  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotoGroupTableViewController.h"
#import "PhotoTool.h"
@protocol MyActionSheetDelegate <NSObject>
//回传
@optional
- (void)myActionSheetMutiSelectDelegate:(NSMutableArray *)array;
@end
@interface getPhoto : NSObject
@property (nonatomic, strong) UIViewController *vc;
@property (nonatomic, assign) BOOL isEdit;//状态是否可以编辑
@property (nonatomic, weak) id<MyActionSheetDelegate>delegate;
@property (nonatomic, assign) BOOL isMutiSelect;//是否允许多选
@property (nonatomic, assign) BOOL isShopAlbum;//是否相册
@property (assign, nonatomic) NSInteger maxPhotoNumber;
- (void)actionShow;
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
