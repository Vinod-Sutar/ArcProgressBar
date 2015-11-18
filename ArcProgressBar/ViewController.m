//
//  ViewController.m
//  ArcProgressBar
//
//  Created by Vinod on 18/11/15.
//  Copyright © 2015 Vinod. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int progress;
    NSTimer * myTimer;
    BOOL isPaused;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    progress = 0;
    [super viewDidLoad];
    
    
    [self startDownload];
    //[self setTimer];
    
    [self.cancelButton setHidden:YES];
    [self.resumeButton setHidden:YES];
}



-(void) setTimer
{
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

-(void) timerMethod:(id)sender
{
    if(progress == 100)
    {
        [myTimer invalidate];
        myTimer = nil;
    }
    
    [objArcProgressBarView setProgress:++progress];
    //[btnProgress setTitle:[NSString stringWithFormat:@"%ld%%",(long)progress] forState:UIControlStateNormal];
    
}


#pragma mark URLSession Implementation

-(void) startDownload
{
    NSURL *url = [NSURL URLWithString:@"https://s3-eu-west-1.amazonaws.com/bb.german.applications/2014/association/ios/DGIM_Leitlinien_Dummy/DE/1.1.zip"];
    
    
    self.downloadTask = [self.session downloadTaskWithURL:url];
    [self.downloadTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSURLSession *)session {
    if (!_session) {
        
        //NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier: @"myBackgroundSessionIdentifier"];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    }
    
    return _session;
}

-(void)URLSession:(NSURLSession *)session
     downloadTask:(NSURLSessionDownloadTask *)downloadTask
     didWriteData:(int64_t)bytesWritten
totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    float progressValue = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        //[btnProgress setTitle:[NSString stringWithFormat:@"%d%%", (int)(progressValue * 100)] forState:UIControlStateNormal];
        [btnProgress setTitle:@"" forState:UIControlStateNormal];
        
        [objArcProgressBarView setProgress:(int)(progressValue * 100)];
        
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        myDownloadedData = [NSData dataWithContentsOfURL:location];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    // Invalidate Session
    [session finishTasksAndInvalidate];
    //session = nil;
    //[self startDownload];
    //[myViewObj setHidden:YES];
    //[btnProgress setHidden:YES];
    
    //[iconImage setAlpha:1];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    
}



- (IBAction)cancel:(id)sender
{
    [self pauseMethod];
}



- (IBAction)resume:(id)sender
{
    [self resumeMethod];
}

-(void) pauseMethod
{
    if (self.downloadTask)
    {
        [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData)
         {
             [self setResumeData:resumeData];
             [self setDownloadTask:nil];
         }];
    }
}

-(void) resumeMethod
{
    if (self.resumeData)
    {
        self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
        [self.downloadTask resume];
        [self setResumeData:nil];
    }
}


- (IBAction)pauseResume:(id)sender
{
    switch (self.downloadTask.state) {
        case NSURLSessionTaskStateRunning:
            NSLog(@"NSURLSessionTaskStateRunning");
            if(isPaused)
            {
                [self resumeMethod];
                isPaused = NO;
            }
            else
            {
                [objArcProgressBarView setProgress:0];
                [self pauseMethod];
                isPaused = YES;
            }
            break;
        case NSURLSessionTaskStateSuspended:
            NSLog(@"NSURLSessionTaskStateSuspended");
            break;
        case NSURLSessionTaskStateCanceling:
            NSLog(@"NSURLSessionTaskStateCanceling");
            break;
        case NSURLSessionTaskStateCompleted:
            NSLog(@"NSURLSessionTaskStateCompleted");
            [self startDownload];
            break;
            
        default:
            break;
    }
}

@end
