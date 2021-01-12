//
//  CameraBarcodeScanner.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 3/13/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarcodeScannerDelegate.h"
#import "BarcodeScannerProvider.h"
#import "BarcodeUIDelegate.h"

@interface CameraBarcodeScanner : NSObject<BarcodeScannerProvider, BarcodeUIDelegate> {
    
}

@end
