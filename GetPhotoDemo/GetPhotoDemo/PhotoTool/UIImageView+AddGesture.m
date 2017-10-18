//
//  UIImageView+AddGesture.m
//  Artselleasy
//
//  Created by admin on 15/6/4.
//  Copyright (c) 2015年 faith. All rights reserved.
//

#import "UIImageView+AddGesture.h"

@implementation UIImageView (AddGesture)

- (id)initWithTarget:(id)target panAction:(SEL)action longAction:(SEL)longaction{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:panGestureRecognizer];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longaction];
        longPress.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPress];
    }
    return self;
}
- (id)initWithTarget:(id)target longAction:(SEL)longaction shortAction:(SEL)shortcation{
    if (self = [super init]) {
        UILongPressGestureRecognizer * longPress;
        UITapGestureRecognizer* singleRecognizer;
        self.userInteractionEnabled = YES;
        
        if (longaction) {
        
        longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longaction];
        longPress.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPress];
        }
        if (shortcation) {
    
        singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:shortcation];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self addGestureRecognizer:singleRecognizer];
        }
        if (longaction && shortcation) {
         
        [singleRecognizer requireGestureRecognizerToFail:longPress];
        
        }
    }
    return self;
}
- (void)imageViewInitWithTarget:(id)target panAction:(SEL)action longAction:(SEL)longaction{
    
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:panGestureRecognizer];
        
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longaction];
        longPress.minimumPressDuration = 1.0;
        [self addGestureRecognizer:longPress];
    

}
- (void)imageViewInitWithTarget:(id)target longAction:(SEL)longaction shortAction:(SEL)shortcation{
        UILongPressGestureRecognizer * longPress;
        UITapGestureRecognizer* singleRecognizer;
        self.userInteractionEnabled = YES;
        
        if (longaction) {
            
            longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:longaction];
            longPress.minimumPressDuration = 1.0;
            [self addGestureRecognizer:longPress];
        }
        if (shortcation) {
            
            singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:shortcation];
            singleRecognizer.numberOfTapsRequired = 1; // 单击
            [self addGestureRecognizer:singleRecognizer];
        }
        if (longaction && shortcation) {
            
            [singleRecognizer requireGestureRecognizerToFail:longPress];
            
        }

}
@end

