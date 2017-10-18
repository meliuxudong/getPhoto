//
//  PhotoGroupTableViewCell.h
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTool.h"

@interface PhotoGroupTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) IBOutlet UILabel *albumNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *albumPhotoNumberLabel;
@property (strong, nonatomic) PhotoGroupModel *model;
@end
