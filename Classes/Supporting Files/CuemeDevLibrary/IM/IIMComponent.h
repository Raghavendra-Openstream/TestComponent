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

/**
 * The MMI component interface for Modality Components.
 * 
 */

@class IM ;
@class IMEvent ;

@protocol IIMComponent <NSObject>

/**
 * Sets a base URL for HTTP documents retrieved for the current application for this view.
 */
- (void) setBase:(NSString *)base;

/**
 * Returns an base URL for HTTP documents retrieved for the current application for this view.
 *
 * @return the base remote server location and directory
 */
- (NSString*) getBase;

/**
 * Event handler for handling MMI events from the Interaction Manager. If handling event does not return almost
 * immediately, the handling should be in its own thread.
 *
 * @param event
 *            the MMI event
 */
- (void) handleEvent:(IMEvent *)event;

/**
 * Adds a listener for an event with given node ID. For the x-html view, for example, the event may be a 'click'
 * event and the node ID is a field's id attribute.
 * <p>
 * As a result of adding the listener for this event an MMI Event to added to the Interaction Manager's event queue
 * when this event occurs on the provided target and the (optional) script is run.
 *
 * @param nodeId the node or target ID of the event (may be null)
 * @param eventType the string identifier for the event (e.g., 'FocusIn')
 *
 * @return true if listener successfully attached
 */
- (BOOL) addEventListener:(NSString *)nodeId eventType:(NSString *)eventType;

/**
 * Removes a listener for an event with given node ID.
 * <p>
 * As a result of removing the listener for this event an MMI Event will not be added to the Interaction Manager's
 * event queue when this event occurs on the provided target.
 *
 * @param nodeId the node or target ID of the event (may be null)
 * @param eventType the string identifier for the event (e.g., 'FocusIn')
 * @return true if listener successfully removed
 */
- (BOOL) removeEventListener:(NSString *)nodeId eventType:(NSString *)eventType;

/**
 * Removes all listeners for events for this view.
 * <p>
 * As a result of removing all listeners no MMI Events will be added to the Interaction Manager's event queue due to
 * any of the previously added event listeners.
 *
 * @return true if all listeners successfully removed
 */
- (BOOL) removeEventListeners;

/**
 * Sets the IM for this component.
 *
 * @param im
 *            Interaction Manager
 */
- (void) setIMHandler:(IM *)im;

/**
 * Notifies components to clear all state related information as the
 * current state machine is stopped..
 *
 */
- (void) clearStateInfo;

/**
 * Notifies components that IM is ready for processing events.
 *
 */
- (void) imReady;

/**
 * Sets ApplicationContext for this component.
 *
 * @param appContext
 *            ApplicationContext
 */
//	public void setApplicationContext(IApplicationContext appContext);

/**
 * Initialize the component
 */
- (void) initComponent:(NSDictionary *)config;

/**
 * uninitialise the IM handler
 *
 * @throws Exception
 */
- (void) unInit;

/**
 * Returns the unique string identifier for this view, one of x-html, x-voice, x-ink, etc.
 *
 * @return the view's unique string identifier
 */
- (NSString*) getSourceId;

/**
 * Callback to indicate that application is gone background and other application is now visible
 */
- (void) onApplicationBackground;

/**
 * Callback to indicate that application is visible now while other application is gone background.
 */
- (void) onApplicationForeground;

/**
 * This is to indicate that Cueme is no longer visible state and currently some other application or view is in
 * visible state
 */
- (void) onContainerBackground;

/**
 * This is to indicate that Cueme is in visible state.
 */
- (void)  onContainerForeground;

@optional
/**
 * When application is pushed to hibernate state, the Container will call method. Components need to return data
 * that will be required for successful restore when application is restored.
 *
 * @return (NSDictionary with NSString keys and values)
 */
- (NSDictionary*) onSaveState;

/**
 * When applicaiton is restored from hibernation, Container will call this method with init parameters and restore
 * state info.
 *
 */
- (void) onRestoreState:(NSDictionary *)config stateInfo:(NSDictionary *) stateInfo;

@end
