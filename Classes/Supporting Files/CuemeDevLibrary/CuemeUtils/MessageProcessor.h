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

#import <Foundation/Foundation.h>

@protocol MessageProcessor
/**
 * Process the Message provided.
 * Message Queue will call the handler with the message
 * when a message is added to the queue.
 *
 * @param  message   The message that needs to be processed.
 */
- (int) processMessage:(id)message;

@end
