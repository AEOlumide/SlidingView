//
//  UIGestureRecognizer+UIGestureRecognizer_Cancel.m
//  CoreAnimationDemo
//
//  Created by Adedayo Ologunde on 2/14/13.
//  Copyright (c) 2013 Adedayo Ologunde. All rights reserved.
//

#import "UIGestureRecognizer+UIGestureRecognizer_Cancel.h"

@implementation UIGestureRecognizer (UIGestureRecognizer_Cancel)
-(void)UIGestureRecognizer_Cancel{
    self.enabled = NO;
    self.enabled = YES;
}
@end
