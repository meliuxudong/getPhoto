//
//  PhotoGroupTableViewCell.m
//  iOS9Sample-Photos
//
//  Created by admin on 2017/10/13.
//  Copyright © 2017年 小码哥. All rights reserved.
//

#import "PhotoGroupTableViewCell.h"

@implementation PhotoGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(PhotoGroupModel *)model{
    _model = model;
    
    _albumNameLabel.text = _model.title;
    _albumPhotoNumberLabel.text = [@(_model.count) stringValue];
    [self getImageWithAsset:_model.headImageAsset completion:^(UIImage *image) {
         _albumImageView.image = image;
    }];
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
    
    return CGSizeMake(_albumImageView.frame.size.height*scale, _albumImageView.frame.size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
