//
//  UIImageSpinnerView.m
//  ThePhoneHouseBOA
//
//  Created by Damien Traille on 24/05/11.
//  Copyright 2011 DPC Interactive. All rights reserved.
//

#import "UIImageSpinnerView.h"


@implementation UIImageSpinnerView

@synthesize currentImageView;
@synthesize activityIndicatorView;
@synthesize threadImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.currentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
        [currentImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:currentImageView];
        [currentImageView release];
    
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width-40.0)/2.0, (self.frame.size.height-40.0)/2.0, 40.0, 40.0)];
        [activityIndicatorView setHidesWhenStopped:YES];
        [activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
       
        [currentImageView addSubview:activityIndicatorView];
        [activityIndicatorView release];
        
    }
    return self;
}

- (void) setImageWithUrl:(NSURL*)urlParam {

    if (currentImageView == nil) return;

    UIImage *image = [[SDImageCache sharedImageCache] imageFromKey:[urlParam absoluteString]];
    
    if (!image) {
        [activityIndicatorView startAnimating];
        self.threadImage = [[NSThread alloc] initWithTarget:self selector:@selector(downloadImage:) object:urlParam];
        [threadImage start];
    } else {
        [currentImageView setImage:image];
    }
    
}

- (void)downloadImage:(NSURL*)urlParam {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:urlParam]];
    
    [self performSelectorOnMainThread:@selector(didFinishWithImage:) withObject:image waitUntilDone:YES];
    
    [pool release];
}


- (void)didFinishWithImage:(UIImage *)image {
    
    if (threadImage != nil && ![threadImage isCancelled]) {

        if (image)
        {
            if (currentImageView != nil) {
                [currentImageView setImage:image];
            }
            if (activityIndicatorView != nil) {
                [activityIndicatorView stopAnimating];
            }
            
        }
        else
        {
            NSLog(@"The image can't be downloaded from this URL, mark the URL as failed so we won't try and fail again and again"); 
            if (currentImageView != nil) {
                [currentImageView setBackgroundColor:[UIColor darkGrayColor]];
            }
            if (activityIndicatorView != nil) {
                [activityIndicatorView stopAnimating];
            }
            
        }
    }
}


- (void)dealloc {
    [activityIndicatorView  release];
    [currentImageView       release];
    if (![threadImage isCancelled]) {
        [threadImage cancel]; 
    }
    [threadImage release];
    
    [super dealloc];
}

@end
