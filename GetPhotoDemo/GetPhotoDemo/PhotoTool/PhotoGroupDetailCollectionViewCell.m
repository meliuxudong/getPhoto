//
//  PhotoGroupDetailCollectionViewCell.m
//  iOS9Sample-Photos
//
//  Created by admin on 2017/10/13.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import "PhotoGroupDetailCollectionViewCell.h"

@implementation PhotoGroupDetailCollectionViewCell
- (void)setModel:(PhotoGroupDetailModel *)model{
    _model = model;
    [self getImageWithAsset:_model.asset completion:^(UIImage *image) {
        _photoImageView.image = image;
    }];
    _selectButton.selected = _model.isSelectState;
    _selectNumberLabel.hidden = !_model.isSelectState;
    _selectNumberLabel.text = [@(_model.selectNumber)stringValue];
}
- (IBAction)clickSelectButton:(UIButton *)sender {
    
    _model.isSelectState = !sender.selected;
    [self.delegate getImage:_model sender:sender];
    
}
//从这个回调中获取所有的图片
- (void)getImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image))completion
{
    CGSize size = [self getSizeWithAsset:asset];
    [[PhotoTool sharePhotoTool] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}
#pragma mark - 获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = width/height;
    
    return CGSizeMake(self.frame.size.height*scale, self.frame.size.height);
}
@end
