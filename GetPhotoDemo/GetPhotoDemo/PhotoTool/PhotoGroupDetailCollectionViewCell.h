//
//  PhotoGroupDetailCollectionViewCell.h
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PhotoTool.h"
@protocol selectImagDeletage <NSObject>

- (void)getImage:(PhotoGroupDetailModel *)model sender:(UIButton *)button;

@end
@interface PhotoGroupDetailCollectionViewCell : UICollectionViewCell

@property (strong ,nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) IBOutlet UILabel *selectNumberLabel;
@property (strong ,nonatomic) PhotoGroupDetailModel *model;
@property (weak, nonatomic) id<selectImagDeletage>delegate;
@end
