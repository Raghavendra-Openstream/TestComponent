//
//  BarcodeSCannerDelegate.h
//  CuemePlatformUtil
//
//  Created by Anthapu Ravindranatha Reddy on 3/13/14.
//  Copyright (c) 2014 Openstream Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BarcodeUIDelegate.h"

@protocol BarcodeScannerDelegate <NSObject>
- (void) scanFailed ;
- (void) scanCanceled ;
- (void) barcode: (NSString*)barcode type:(NSString*) barcodeType metadata:(NSDictionary *)barcodeData;
//- (id<BarcodeUIDelegate>) getUIDelegate ;
@end
