//
//  PhotoGroupTableViewController.m
//  iOS9Sample-Photos
//
//  Created by admin on 2017/10/12.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import "PhotoGroupTableViewController.h"
#import <Photos/Photos.h>
#import "PhotoTool.h"
#import "PhotoGroupTableViewCell.h"
#import "PhotoGroupDetailCollectionViewController.h"
#import "UIImageView+AddGesture.h"
#import "MBProgressHUD.h"

@interface PhotoGroupTableViewController ()<getSelectImgDelegate>
@property (nonatomic, strong) NSMutableArray *photoGroupArray;
@end

@implementation PhotoGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self getPhotoGroup];
}
- (void)getPhotoGroup{
    // 判断授权状态
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusAuthorized){
            NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
            NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleDisplayName"];
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.label.text = @"温馨提示";
            hud.detailsLabel.text = [NSString stringWithFormat:@"请在设备的\"设置-隐私-照片\"选项中，允许%@访问你的手机相册", appName];
            hud.mode = MBProgressHUDModeText;
            
            [hud hideAnimated:YES afterDelay:2.f];
          return;
        }
    }];
    _photoGroupArray = [[PhotoTool sharePhotoTool]getPhotoAblumList];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _photoGroupArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellResueIdentifier = @"PhotoGroupTableViewCell";
    PhotoGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellResueIdentifier forIndexPath:indexPath];
    PhotoGroupModel *model = _photoGroupArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoGroupDetailCollectionViewController *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoGroupDetailCollectionViewController"];
    
    PhotoGroupModel *model = _photoGroupArray[indexPath.row];
    detailVC.model = model;
    detailVC.delegate = self;
    detailVC.title = model.title;
    detailVC.maxPhotoNumber = self.maxPhotoNumber;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (void)getSelectImg:(NSMutableArray *)imgArray{
    [self.delegate returnImageDelegate:imgArray];
    [self.navigationController popViewControllerAnimated:NO];
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