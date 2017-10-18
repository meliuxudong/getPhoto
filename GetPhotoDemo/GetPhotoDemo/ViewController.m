//
//  ViewController.m
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//

#import "ViewController.h"
#import "MyActionSheet.h"
#import "MBProgressHUD.h"

@interface ViewController ()<MyActionSheetDelegate>
@property (nonatomic, strong) MyActionSheet *actionView;
@end
@implementation ViewController

// lazy initialization

- (MyActionSheet *)actionView{
    if (!_actionView) {
        _actionView = [[MyActionSheet alloc]initWithFrame:self.view.frame];
        _actionView.isEdit = NO;
        _actionView.isMutiSelect = YES;
        _actionView.delegate = self;
        _actionView.maxPhotoNumber = 4;
        [self.view addSubview:_actionView];
    }
    return _actionView;
}
- (void)viewDidLoad{
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self removeMyActionSheetView];
}

- (IBAction)getPhoto:(UIButton *)sender {
    
    [self.actionView actionShow];
    
}

/**
 MyActionSheetDelegate
 
 @param array return array of UIImage
 @param info return Error
 */
- (void)myActionSheetMutiSelectDelegate:(NSMutableArray *)array info:(NSString *)info{
    
    NSLog(@"image = %@, Error = %@",array,info);
    
    [self removeMyActionSheetView];
    
    if (info) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.label.text = @"温馨提示";
        hud.detailsLabel.text = info;
        hud.mode = MBProgressHUDModeText;
        
        [hud hideAnimated:YES afterDelay:2.f];
        
    }
}
//remove actionView
- (void)removeMyActionSheetView{
    [_actionView removeFromSuperview];
    _actionView = nil;
}

@end
