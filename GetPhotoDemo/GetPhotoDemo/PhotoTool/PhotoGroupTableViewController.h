//
//  PhotoGroupTableViewController.h
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol returnImageDelegate <NSObject>
//回传
@optional
- (void)returnImageDelegate:(NSMutableArray *)array;
@end
@interface PhotoGroupTableViewController : UITableViewController
@property (assign, nonatomic) NSInteger maxPhotoNumber;
@property (nonatomic, weak) id<returnImageDelegate>delegate;
@end
