//
//  ArcProgressBarView.h
//  ArcProgressBar
//
//  Created by Vinod on 18/11/15.
//  Copyright © 2015 Vinod. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArcProgressBarView : UIView
{
    UILabel * progressLabel;
    NSTimer * myTimer;
}

@property(nonatomic) NSInteger progress;


-(void)drawRect:(CGRect)rect;

@end
