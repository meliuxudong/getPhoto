//
//  UIImageView+AddGesture.h
//  GetPhotoDemo
//
//  Created by 刘旭东 on 2017/10/18.
//  Copyright © 2017年 GetPhoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (AddGesture)
//添加两种手势
- (id)initWithTarget:(id)target panAction:(SEL)action longAction:(SEL)longaction;
- (id)initWithTarget:(id)target longAction:(SEL)longaction shortAction:(SEL)shortcation;
//已实例化
- (void)imageViewInitWithTarget:(id)target panAction:(SEL)action longAction:(SEL)longaction;
- (void)imageViewInitWithTarget:(id)target longAction:(SEL)longaction shortAction:(SEL)shortcation;
@end
