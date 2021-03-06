//
//  MyActionSheet.h
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoGroupTableViewController.h"
#import "PhotoTool.h"
@protocol MyActionSheetDelegate <NSObject>
//回传
@optional
- (void)myActionSheetMutiSelectDelegate:(NSMutableArray *)array info:(NSString *)info;
@end

@interface MyActionSheet : UIView

@property (nonatomic, assign) BOOL isEdit;//状态是否可以编辑
@property (nonatomic, assign) BOOL isMutiSelect;//是否允许多选
@property (nonatomic, assign) NSInteger maxPhotoNumber;
@property (nonatomic, weak) id<MyActionSheetDelegate>delegate;
@property (nonatomic, strong) UIViewController *sourceVC;
- (void)actionShow;
- (void)removeView;
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
