//
//  BarcodeScannerProvider.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 3/13/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BarcodeScannerDelegate.h"

@class JSONObject ;

@protocol BarcodeScannerProvider <NSObject>
- (void) initialize:(id<BarcodeScannerDelegate>) delegate withOptions: (JSONObject*) options ;
- (void) start ;
- (void) stop ;
@end
