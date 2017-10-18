//
//  PhotoGroupDetailCollectionViewController.m
//  iOS9Sample-Photos
//
//  Created by admin on 2017/10/13.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import "PhotoGroupDetailCollectionViewController.h"
#import "PhotoGroupDetailCollectionViewCell.h"
#import "UIImageView+AddGesture.h"
#import "MBProgressHUD.h"

@interface PhotoGroupDetailCollectionViewController ()<selectImagDeletage>
@property (nonatomic ,strong) NSMutableArray *photoArray;
@property (nonatomic ,strong) IBOutlet UIImageView *showBigPicImageView;
@property (nonatomic ,strong) IBOutlet UIView *maskView;
@property (nonatomic ,strong) NSMutableArray *selectPhotoArray;
@property (nonatomic ,strong) NSIndexPath *selectIndexPath;
@property (nonatomic ,assign) CGRect rectInWindow;

@end

@implementation PhotoGroupDetailCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBtnClick)];
    
    _photoArray = @[].mutableCopy;
    _selectPhotoArray = @[].mutableCopy;
    
    NSMutableArray *assetArray = [[PhotoTool sharePhotoTool]getAssetsInAssetCollection:_model.assetCollection ascending:NO];
    for (NSInteger i = 0; i <= assetArray.count - 1; i ++) {
        
        PhotoGroupDetailModel *model = [[PhotoGroupDetailModel alloc]init];
        model.asset = assetArray[i];
        model.isSelectState = NO;
        model.selectNumber = 0;
        
        [_photoArray addObject:model];
    }
    [self initCollectionViewFlowLayout];
}
- (void)initCollectionViewFlowLayout{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置每个item的大小，
    CGFloat picWidth = (Screen_Width - 3 * 2) / 4;
    flowLayout.itemSize = CGSizeMake(picWidth, picWidth);
    // 设置列的最小间距
    flowLayout.minimumInteritemSpacing = 2;
    // 设置最小行间距
    flowLayout.minimumLineSpacing = 2;
    // 设置布局的内边距
    flowLayout.sectionInset = UIEdgeInsetsMake(2, 0, 2, 0);
    // 滚动方向
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView.collectionViewLayout = flowLayout;
    
}
- (void)confirmBtnClick{
    __block NSMutableArray *imgArray = @[].mutableCopy;
    for (PhotoGroupDetailModel *model in _photoArray) {
        if (model.isSelectState) {
            [self getImageWithAsset:model.asset resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
                NSData * data =  UIImageJPEGRepresentation(image,0.50);
                UIImage *compressEndImage = [UIImage imageWithData:data];
                [imgArray addObject:compressEndImage];
            }];
            
        }
        
    }
    [self.navigationController popViewControllerAnimated:NO];
    [self.delegate getSelectImg:imgArray];
    
    
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const reuseIdentifier = @"PhotoGroupDetailCollectionViewCell";
    
    PhotoGroupDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    PhotoGroupDetailModel *model = _photoArray[indexPath.row];

    cell.model = model;
    cell.delegate = self;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoGroupDetailCollectionViewCell *cell = (PhotoGroupDetailCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    PhotoGroupDetailModel *model = _photoArray[indexPath.row];
    
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    // 转换坐标系。把cell里图片的参照系从cell换成UIWindow
    _rectInWindow = [cell convertRect:cell.photoImageView.frame toView:window];
    //    [_showBigPicImageView sd_setImageWithURL:((NSString *)_imgArray[indexPath.row]).imageURL placeholderImage:IMG(@"placeholder")];
    //    _maskView.frame = _rectInWindow;
    _maskView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
    _showBigPicImageView.frame = _rectInWindow;
    [window addSubview:_maskView];
    [window addSubview:_showBigPicImageView];
    [self getImageWithAsset:model.asset resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image) {
        _showBigPicImageView.image = image;
    }];

    [UIView animateWithDuration:0.3f animations:^{
        //        _maskView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        _showBigPicImageView.frame = CGRectMake(0, 0, Screen_Width, Screen_Height);
        
    } completion:^(BOOL finished) {
        
    }];

}
- (void)getImage:(PhotoGroupDetailModel *)model sender:(UIButton *)button{
     
    NSInteger count = 0;
    for (PhotoGroupDetailModel *addModel in _photoArray) {
        if (addModel.isSelectState) count ++;
    }
    if (count > _maxPhotoNumber) {
        model.isSelectState = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        hud.label.text = @"温馨提示";
        hud.detailsLabel.text = [NSString stringWithFormat:@"最多可以选取%ld张",(long)_maxPhotoNumber];
        hud.mode = MBProgressHUDModeText;
        
        [hud hideAnimated:YES afterDelay:2.f];
        return;
    }
    
    button.selected = !button.selected;
    
    if (button.selected) {
        model.selectNumber = count;
    }else{
        for (PhotoGroupDetailModel *reduceModel in _photoArray) {
            if (reduceModel.isSelectState && (reduceModel.selectNumber > model.selectNumber)){
                reduceModel.selectNumber --;
            }
        }
        model.selectNumber = 0;
    }
    [self.collectionView reloadData];
}
- (IBAction)tapMakeView:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.3f animations:^{
        //        _maskView.frame = _rectInWindow;
        _showBigPicImageView.frame = _rectInWindow;
    } completion:^(BOOL finished) {
        [_maskView removeFromSuperview];
        [_showBigPicImageView removeFromSuperview];
    }];
}
//从这个回调中获取所有的图片
- (void)getImageWithAsset:(PHAsset *)asset resizeMode:(PHImageRequestOptionsResizeMode)resizeMode completion:(void (^)(UIImage *image))completion
{
    CGSize size = [self getSizeWithAsset:asset];
    [[PhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:resizeMode completion:completion];
}
#pragma mark - 获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = height/width;
    
    return CGSizeMake(Screen_Width, Screen_Width * scale);
}


@end
