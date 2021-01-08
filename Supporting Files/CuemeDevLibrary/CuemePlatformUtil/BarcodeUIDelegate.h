//
//  BarcodeUIDelegate.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 3/13/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BarcodeUIDelegate <NSObject>
- (UIView*) getBarcodeView: (CGRect) parentFrame ;
@end
