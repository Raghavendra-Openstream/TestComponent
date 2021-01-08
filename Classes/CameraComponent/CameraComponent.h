/*
 *  CameraComponent.h
 *
 * (C) Copyright 2014, Openstream, Inc. NJ, U.S.A.
 * All rights reserved.
 *
 * This software is confidential and proprietary information of
 * Openstream, Inc. ("Confidential Information"). You shall not disclose
 * such Confidential Information and shall use/possess it only in accordance
 * with the terms of the license/usage agreement you entered into with
 * Openstream, Inc.
 *
 * If you any have questions regarding this matter, please contact legal@openstream.com
 *
 * Author: Keyur Patel
 *
 * Created On : Jun 06, 2014
 *
 */

#import <Foundation/Foundation.h>

#import "IIMComponent.h"
#import "MessageProcessor.h"

@interface CameraComponent : NSObject <IIMComponent, MessageProcessor>

@end
