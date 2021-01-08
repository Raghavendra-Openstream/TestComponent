//
//  OSEImageEdgeDetector.m
//  CameraComponent
//
//  Created by OS Developer on 8/10/20.
//  Copyright © 2020 Openstream Inc. All rights reserved.
//

#import "OSEImageProcess.h"
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Vision/Vision.h>
#import <ImageIO/ImageIO.h>

@implementation OSEImageProcess

+ (instancetype)sharedInstance
{
    static OSEImageProcess *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OSEImageProcess alloc] init];
    });
    
    return sharedInstance;
}

- (void)detectEdgeUsingVisionFramework:(UIImage *)referenceImagePixelBuffer withCompletionHandler:(void (^)(BOOL, UIImage * _Nullable))completionHandler {
 
    CIImage *ciImage = [CIImage imageWithCGImage:[referenceImagePixelBuffer CGImage]];
    CGImagePropertyOrientation orientation = [self CGImagePropertyOrientation:referenceImagePixelBuffer.imageOrientation];
    CIImage *orientedImage = [ciImage imageByApplyingOrientation:orientation];
    
    // Use the VNImageRequestHandler on iOS 11 to attempt to find a rectangle from the initial image.
    VNImageRequestHandler *imageRequest = [[VNImageRequestHandler alloc] initWithCIImage:ciImage orientation:orientation options:@{}];
    
    VNDetectRectanglesRequest *rectangleDetectionRequest = [[VNDetectRectanglesRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
                
        if(error || request.results.count == 0) {
            
            NSLog(@"Failed to detect Edges");
            completionHandler(NO, nil);
            
        } else {
           
            VNRectangleObservation *biggestRectangle = [self biggestRectangle:request.results];
           
            if(biggestRectangle) {
                               
                UIImage *resultImage = [self getFinalCroppedImage:orientedImage withDetectedRectangle:biggestRectangle];
                
                completionHandler(YES, resultImage);
            }
        }
    }];
    
    rectangleDetectionRequest.minimumConfidence = 0.8;
    rectangleDetectionRequest.maximumObservations = 15;
    rectangleDetectionRequest.minimumAspectRatio = 0.3;
    
    // Send the requests to the request handler.
    NSError *error = nil;
    [imageRequest performRequests:@[rectangleDetectionRequest] error:&error];
    
    if(error) {
        
        NSLog(@"Failed to perform Detect Edge Request");
        completionHandler(NO, nil);
    }
}

/// Finds the biggest rectangle within an array of `Quadrilateral` objects.
- (VNRectangleObservation *)biggestRectangle:(NSArray *)arrayOfRectangleObservation {
    
    return [arrayOfRectangleObservation sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        VNRectangleObservation *rect1 = obj1;
        VNRectangleObservation *rect2 = obj2;
        
        if ([self getPerimeter:rect1] > [self getPerimeter:rect2]) {
            return NSOrderedDescending;
        } else if ([self getPerimeter:rect1] < [self getPerimeter:rect2]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
        
    }].lastObject;
}

/// The perimeter of the Quadrilateral
- (double)getPerimeter:(VNRectangleObservation *)rectangle {
    
    double perimeter = [self distanceToPoint:rectangle.topRight fromPoint:rectangle.topLeft] + [self distanceToPoint:rectangle.bottomRight fromPoint:rectangle.topRight] + [self distanceToPoint:rectangle.bottomLeft fromPoint:rectangle.bottomRight] + [self distanceToPoint:rectangle.topLeft fromPoint:rectangle.bottomLeft];
        
    return perimeter;
}

/// Returns the distance between two points
- (CGFloat)distanceToPoint:(CGPoint)toPoint fromPoint:(CGPoint)fromPoint {
    
    return hypot(fromPoint.x - toPoint.x, fromPoint.y - toPoint.y);
}

- (UIImage *)getFinalCroppedImage:(CIImage *)orientedImage withDetectedRectangle:(VNRectangleObservation *)detectedRectangle {
    
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIPerspectiveCorrection"];

    if(ciFilter) {
        
        CGFloat width = orientedImage.extent.size.width;
        CGFloat height = orientedImage.extent.size.height;
        
        CGPoint topLeft = CGPointMake(detectedRectangle.topLeft.x * width, detectedRectangle.topLeft.y * height);
        CGPoint topRight = CGPointMake(detectedRectangle.topRight.x * width, detectedRectangle.topRight.y * height);
        CGPoint bottomLeft = CGPointMake(detectedRectangle.bottomLeft.x * width, detectedRectangle.bottomLeft.y * height);
        CGPoint bottomRight = CGPointMake(detectedRectangle.bottomRight.x * width, detectedRectangle.bottomRight.y * height);

        [ciFilter setValue:[CIVector vectorWithCGPoint:topLeft] forKey:@"inputTopLeft"];
        [ciFilter setValue:[CIVector vectorWithCGPoint:topRight] forKey:@"inputTopRight"];
        [ciFilter setValue:[CIVector vectorWithCGPoint:bottomLeft] forKey:@"inputBottomLeft"];
        [ciFilter setValue:[CIVector vectorWithCGPoint:bottomRight] forKey:@"inputBottomRight"];
        
        [ciFilter setValue:orientedImage forKey:kCIInputImageKey];
        
        CIImage *outputCIImage = [ciFilter outputImage];
        
        CIContext *context = [CIContext context];
        CGImageRef outputCGImage = [context createCGImage:outputCIImage fromRect:outputCIImage.extent];
        
        UIImage *finalImage = [UIImage imageWithCGImage:outputCGImage];
        
        return finalImage;
    }
    return nil;
}

- (UIImage *)normalizedImage:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;

    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (CGImagePropertyOrientation)CGImagePropertyOrientation:(UIImageOrientation)orientation
{
    switch (orientation) {
        case UIImageOrientationUp:
            return kCGImagePropertyOrientationUp;
        case UIImageOrientationUpMirrored:
            return kCGImagePropertyOrientationUpMirrored;
        case UIImageOrientationDown:
            return kCGImagePropertyOrientationDown;
        case UIImageOrientationDownMirrored:
            return kCGImagePropertyOrientationDownMirrored;
        case UIImageOrientationLeftMirrored:
            return kCGImagePropertyOrientationLeftMirrored;
        case UIImageOrientationRight:
            return kCGImagePropertyOrientationRight;
        case UIImageOrientationRightMirrored:
            return kCGImagePropertyOrientationRightMirrored;
        case UIImageOrientationLeft:
            return kCGImagePropertyOrientationLeft;
    }
}

/// Detect Text using Vision Framework
/// @param referenceImagePixelBuffer  input image to detect text
/// @param completionHandler contains Boolean value of result and detected text result
- (void)detectText:(UIImage *)referenceImagePixelBuffer withCompletionHandler:(void(^)(BOOL result,NSString * _Nullable detectedText, NSArray * _Nullable arrayOfDetectedText))completionHandler {
    
    CIImage *ciImage = [CIImage imageWithCGImage:[referenceImagePixelBuffer CGImage]];
    CGImagePropertyOrientation orientation = [self CGImagePropertyOrientation:referenceImagePixelBuffer.imageOrientation];
    
    // Use the VNImageRequestHandler on iOS 11 to attempt to find a rectangle from the initial image.
    VNImageRequestHandler *imageRequestHandler = [[VNImageRequestHandler alloc] initWithCIImage:ciImage orientation:orientation options:@{}];
    
    if (@available(iOS 13.0, *)) {
        
        //TODO: VNRecognizeTextRequest will use to get detected raw text value
        VNRecognizeTextRequest *textRecognitionRequest = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
            
            if(error || request.results.count == 0) {
                
                NSLog(@"Failed to detect text");
                completionHandler(NO, nil, nil);
                
            } else {
                        
                NSArray *requestResults = request.results;
                NSMutableArray *arrayOfRecognizedText = [[NSMutableArray alloc] init];
                NSString *recognizedText = @"";
                
                for(VNRecognizedTextObservation *observation in requestResults) {
                    
                    VNRecognizedText *candidiate = [observation topCandidates:1].firstObject;
                    
                    if(candidiate) {
                        
                        recognizedText = [recognizedText stringByAppendingString:candidiate.string];
                        recognizedText = [recognizedText stringByAppendingString:@"\n"];
                        [arrayOfRecognizedText addObject:candidiate.string];
                    }
                }
                
                NSLog(@"Recognized Text = %@", recognizedText);
                completionHandler(YES, recognizedText, arrayOfRecognizedText);
            }
        }];
        
        textRecognitionRequest.recognitionLevel = VNRequestTextRecognitionLevelAccurate;
        
        NSError *error;
        [imageRequestHandler performRequests:@[textRecognitionRequest] error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    } else {
        completionHandler(NO, nil, nil);
    }
}

@end
