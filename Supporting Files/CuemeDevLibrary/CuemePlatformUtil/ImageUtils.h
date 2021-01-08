//
//  ImageUtils.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 2/24/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PlatformImageUtils : NSObject {
    
}

+ (UIImage*)imageByScalingAndCroppingForSize:(UIImage*)anImage toSize:(CGSize)targetSize ;
+ (UIImage*)imageCorrectedForCaptureOrientation:(UIImage*)anImage ;
+ (UIImage*)imageByScalingNotCroppingForSize:(UIImage*)anImage toSize:(CGSize)frameSize ;
+ (UIImage *)resizedImageWithContentMode:(UIImage *)image
                             contentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

@end
