//
//  ViewController.m
//  SlidingView
//
//  Created by Adedayo Ologunde on 2/10/13.
//  Copyright (c) 2013 Adedayo Ologunde. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController
@synthesize viewOrigin = _viewOrigin;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Save the origin of the view
    _viewOrigin = CGRectMake(self.view.superview.frame.origin.x, self.view.superview.frame.origin.y, self.view.superview.frame.size.width, self.view.superview.frame.size.height);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)UIViewAnimationOptionBeginFromCurrentState{

}

- (IBAction)handlePan:(UIPanGestureRecognizer *)panRecognizer {//Get rid of when done - use -() in .h to get recognized by storyboard

    CGPoint translation = [panRecognizer translationInView:self.view.superview];
    CGRect bounds = self.view.superview.bounds;
    CGPoint center = [self translateDirectionOnOrientation:translation];
    //CGFloat maxSize = center.y*2;
    //NSLog(@"View dragged %@ maxSize: %f bounds: %@", NSStringFromCGPoint(translation), maxSize, NSStringFromCGRect(bounds));
    
    
    // Stop all animations if user "catches" the view while it falls
    //NSLog(@"%i",panRecognizer.numberOfTouches);
    
    // if the drag exceeds the viewable area, readjust center to half bounds height
    if ([self isLandScapeRightOrientation] && center.x*2 > bounds.size.width) {
        center = CGPointMake(bounds.size.width/2, center.y);
    }
    else if ([self isLandScapeLeftOrientation] && center.x*2 < bounds.size.width) {
        center = CGPointMake(bounds.size.width/2, center.y);
    }
    else if ([self isPortraitOrientation] && center.y*2 > bounds.size.height) {
        center = CGPointMake(center.x, bounds.size.height/2);
    }
    
    // Set animation
    panRecognizer.view.superview.center = center;
    [panRecognizer setTranslation:CGPointZero inView:self.view.superview];
    
    // slide the view back down if the user stops dragging
    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect ogFrame = self.view.superview.frame;
        ogFrame.origin = _viewOrigin.origin;
        
        CGPoint velocity = [panRecognizer velocityInView:self.view.superview];
        //NSLog(@"velocity %f",velocity.x);

        //if the user isn't dragging the view, animate it down
        if (([self isPortraitOrientation] && velocity.y <= 0.0) || ([self isLandScapeRightOrientation] && velocity.x <=0.0 ) ||([self isLandScapeLeftOrientation] && velocity.x >=0.0 )) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.4];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        }
        
        // Restore frame to it's original position
        self.view.superview.frame = ogFrame;
        [UIView commitAnimations];
    }
}

-(CGPoint)translateDirectionOnOrientation:(CGPoint) translation{
    CGPoint center = self.view.superview.center;
    if ( [self isPortraitOrientation]) {
        center = CGPointMake(center.x, center.y + translation.y);
        return center;
    }
    else if ([self isLandScapeOrientation]){
        center = CGPointMake(center.x+translation.x,center.y);
        return center;
    }
    return center;
}

-(BOOL)isPortraitOrientation {
    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( UIDeviceOrientationIsPortrait(orientation) == YES) {
        return YES;
    }
    return NO;
}

-(BOOL)isLandScapeOrientation {
    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( UIDeviceOrientationIsLandscape(orientation) == YES) {
        return YES;
    }
    return NO;
}

-(BOOL)isLandScapeRightOrientation {
    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( orientation ==UIDeviceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

-(BOOL)isLandScapeLeftOrientation {
    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ( orientation ==UIDeviceOrientationLandscapeLeft) {
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
