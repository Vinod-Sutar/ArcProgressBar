//
//  ArcProgressBarView.m
//  ArcProgressBar
//
//  Created by Vinod on 18/11/15.
//  Copyright © 2015 Vinod. All rights reserved.
//

#import "ArcProgressBarView.h"
#include <math.h>

#define   DEGREES_TO_RADIANS(degrees)  ((3.14 * degrees)/ 180)

@implementation ArcProgressBarView

@synthesize progress = _progress;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setProgress:(NSInteger)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect
{
    [self drawOuterRing];
    [self drawInnerRing];
}

-(void) drawOuterRing
{
    
    CGContextRef outerRing = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    
    CGPoint center;;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    CGContextAddArc(outerRing, center.x, center.y, 45, 0.0, M_PI*2, YES);
    
    CGContextSetLineWidth(outerRing, 32);
    CGContextSetRGBStrokeColor(outerRing,0.2,0.2,0.2,0.8);
    CGContextStrokePath(outerRing);
}

-(void) drawInnerRing
{
    CGRect bounds = [self bounds];
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    CGContextRef innerRing = UIGraphicsGetCurrentContext();
    
    CGFloat endPoint = (((M_PI *2)/100)* _progress) + (M_PI + M_PI_2);
    
    CGContextAddArc(innerRing, center.x, center.y, 12, 4.71, endPoint, YES);
    CGContextSetLineWidth(innerRing, 24);
    CGContextSetRGBStrokeColor(innerRing,0.2,0.2,0.2,0.8);
    CGContextStrokePath(innerRing);
    
    if(_progress >= 100)
    {
        [self makeMeTransparent];
    }
    else
    {
        if(self.alpha != 0.9)
        {
            self.alpha = 0.9;
        }
        
    }
    
}


-(void) makeMeTransparent
{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

-(void) timerMethod:(id)sender
{
    if(self.alpha == 0)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    else
    {
        self.alpha -= 0.1;
    }
}


static UIImage *imageWithSize(CGSize size, int percent)
{
    static CGFloat const kThickness = 20;
    static CGFloat const kLineWidth = 1;
    
    CGFloat endPoint = ((4.28/100)*35) + 4.28;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0); {
        CGContextRef gc = UIGraphicsGetCurrentContext();
        
        CGContextAddArc(gc, size.width / 2, size.height / 2,
                        (size.width - kThickness - kLineWidth) / 2, 4.71, endPoint, NO);
        
        
        CGContextSetLineWidth(gc, kThickness);
        CGContextSetLineCap(gc, kCGLineCapButt);
        CGContextReplacePathWithStrokedPath(gc);
        CGPathRef path = CGContextCopyPath(gc);
        
        CGContextBeginTransparencyLayer(gc, 0); {
            
            
            CGContextAddPath(gc, path);
            CGPathRelease(path);
            
            CGContextSetLineWidth(gc, kLineWidth);
            CGContextSetLineJoin(gc, kCGLineJoinMiter);
            [[UIColor blackColor] setStroke];
            CGContextStrokePath(gc);
            
        } CGContextEndTransparencyLayer(gc);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end