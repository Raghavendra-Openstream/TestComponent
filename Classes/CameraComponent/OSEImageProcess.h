//
//  OSEImageEdgeDetector.h
//  CameraComponent
//
//  Created by OS Developer on 8/10/20.
//  Copyright © 2020 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OSEImageProcess : NSObject

/// Create a singleton object of this class
+ (instancetype)sharedInstance;


/// Detect Edge using Vision Framework
/// @param referenceImagePixelBuffer input image to detect edge
/// @param completionHandler contains Boolean value of result and detected edge result
- (void)detectEdgeUsingVisionFramework:(UIImage *)referenceImagePixelBuffer withCompletionHandler:(void(^)(BOOL result,UIImage  * _Nullable resultImage))completionHandler;


/// This method will usefull to fix the orientation of input image
/// @param image input image to fix orientation
- (UIImage *)normalizedImage:(UIImage *)image;


/// Detect Text using Vision Framework
/// @param referenceImagePixelBuffer  input image to detect text
/// @param completionHandler contains Boolean value of result and detected text result
- (void)detectText:(UIImage *)referenceImagePixelBuffer withCompletionHandler:(void(^)(BOOL result,NSString * _Nullable detectedText, NSArray * _Nullable arrayOfDetectedText))completionHandler;

@end

NS_ASSUME_NONNULL_END
