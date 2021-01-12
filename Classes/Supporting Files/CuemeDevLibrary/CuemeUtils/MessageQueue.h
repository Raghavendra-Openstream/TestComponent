/*
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
 * Author: Openstream Inc
 *
 */

/**
 * This provides queuing mechanism which can be used in all components for event queuing. This provides how ability set
 * to how many events that can be parallelely processed by settning value for process thr.eads
 *
 * @author Anthapu Reddy
 *
 *  Created by Anthapu Ravindranatha Reddy
 *  Copyright (c) 2014 Openstream Inc. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSArray.h>
#import <Foundation/NSLock.h>

#import "MessageProcessor.h"



@interface MessageQueue : NSObject <NSFastEnumeration> {
}

- (void) addMessageToTopOfQueue:(id)message;
- (void) addMessageToQueue: (id) message ;
- (void) stopQueue ;
- (id) initWithHandler: (id<MessageProcessor>) processor ;
- (id) initWithHandler: (id<MessageProcessor>) processor withThreads:(int) threadCount ;
- (void) clearQueue ;
- (void) completeProcessAndExit ;
- (BOOL) isRunning ;
- (void) startRunning ;
@end

