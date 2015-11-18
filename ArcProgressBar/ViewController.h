//
//  ViewController.h
//  ArcProgressBar
//
//  Created by Vinod on 18/11/15.
//  Copyright © 2015 Vinod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcProgressBarView.h"

@interface ViewController : UIViewController <NSURLSessionDelegate, NSURLSessionDownloadDelegate>
{
    NSURLSession *_session;
    NSData * myDownloadedData;
    __weak IBOutlet UIImageView * iconImage;
    __weak IBOutlet ArcProgressBarView * objArcProgressBarView;
    __weak IBOutlet UIButton * btnProgress;
}


@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *resumeButton;

- (IBAction)cancel:(id)sender;
- (IBAction)resume:(id)sender;


@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;
@property (strong, nonatomic) NSData *resumeData;

@end

