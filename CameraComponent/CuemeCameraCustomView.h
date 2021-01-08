//
//  CustomView.h
//  CameraTestApp
//
//  Created by OS Developer on 9/16/19.
//  Copyright © 2019 Openstream Teechnologies. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomViewDelegate<NSObject>

- (void)closeButtonClicked;
- (void)infoButtonClicked;
- (void)captureButtonClicked;

@end

@interface CuemeCameraCustomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (weak, nonatomic) IBOutlet UIButton *captureButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureButtonBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captureButtonCenterXConstraint;

@property (weak, nonatomic) IBOutlet UIView *safeareaTopView;


@property(nonatomic, weak) id <CustomViewDelegate> delegate;

@property (nonatomic) IBOutlet UIView *aspectRatioView;
@property (nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic) IBOutlet UIView *viewFinderView;
@property (nonatomic) IBOutlet UIView *backgroundImageViewFillColorView;


@property(nonatomic,weak) NSLayoutConstraint *captureButtonTrailingConstraint;
@property(nonatomic,weak) NSLayoutConstraint *captureButtonCenterYConstraint;

@property(nonatomic) CGSize cameraAspectRatio;
@property(nonatomic) CGFloat customViewYValue;


- (instancetype)initWithFrame:(CGRect)frame andBundle:(NSBundle *)bundle;


- (IBAction)infoButtonAction:(id)sender;

- (IBAction)closeButtonAction:(id)sender;

- (IBAction)captureButtonAction:(id)sender;


@end

NS_ASSUME_NONNULL_END
