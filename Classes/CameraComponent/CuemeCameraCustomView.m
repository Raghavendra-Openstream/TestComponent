//
//  CustomView.m
//  CameraTestApp
//
//  Created by OS Developer on 9/16/19.
//  Copyright © 2019 Openstream Teechnologies. All rights reserved.
//

#import "CuemeCameraCustomView.h"

@implementation CuemeCameraCustomView

- (instancetype)initWithFrame:(CGRect)frame andBundle:(NSBundle *)bundle
{
    CuemeCameraCustomView *customView = [[bundle loadNibNamed:@"CustomView" owner:self options:nil] lastObject];
    customView.frame = frame;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    if(screenSize.width > screenSize.height) {
        
        screenWidth = screenSize.height;
        screenHeight = screenSize.width;
    }
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {

        customView.cameraAspectRatio = CGSizeMake(screenWidth, (screenWidth) * (4.0 / 3.0));

    } else {
        
        customView.cameraAspectRatio = CGSizeMake(screenWidth, screenHeight);
    }
    
    customView.customViewYValue = customView.safeareaTopView.frame.size.height + customView.topView.frame.size.height;
    
    customView.aspectRatioView = [[UIView alloc] initWithFrame:CGRectMake(0,customView.customViewYValue , customView.cameraAspectRatio.width, customView.cameraAspectRatio.height - customView.customViewYValue)];
    
    customView.viewFinderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, customView.aspectRatioView.frame.size.width, customView.aspectRatioView.frame.size.height)];
    customView.viewFinderView.backgroundColor = [UIColor clearColor];
    
    customView.backgroundImageViewFillColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, customView.aspectRatioView.frame.size.width, customView.aspectRatioView.frame.size.height)];
    customView.backgroundImageViewFillColorView.backgroundColor = [UIColor clearColor];
    
    customView.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, customView.aspectRatioView.frame.size.width, customView.aspectRatioView.frame.size.height)];
    customView.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    customView.backgroundImageView.backgroundColor = [UIColor clearColor];

    [customView.aspectRatioView addSubview:customView.viewFinderView];
    [customView.aspectRatioView addSubview:customView.backgroundImageViewFillColorView];
    [customView.aspectRatioView addSubview:customView.backgroundImageView];

    [customView addSubview:customView.aspectRatioView];

    [customView bringSubviewToFront:customView.captureButton];
    [customView bringSubviewToFront:customView.topView];
    [customView bringSubviewToFront:customView.safeareaTopView];

    return customView;
}

- (IBAction)infoButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(infoButtonClicked)]) {
        [self.delegate infoButtonClicked];
    }
}

- (IBAction)closeButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(closeButtonClicked)]) {
        [self.delegate closeButtonClicked];
    }
}

- (IBAction)captureButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(captureButtonClicked)]) {
        [self.delegate captureButtonClicked];
    }
}


@end
