//
//  PhotoGroupDetailCollectionViewController.h
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoTool.h"
@protocol getSelectImgDelegate <NSObject>

- (void)getSelectImg:(NSMutableArray *)imgArray;

@end
@interface PhotoGroupDetailCollectionViewController : UICollectionViewController
@property (nonatomic ,strong) PhotoGroupModel *model;
@property (assign, nonatomic) NSInteger maxPhotoNumber;
@property (nonatomic ,weak) id<getSelectImgDelegate>delegate;
@end
