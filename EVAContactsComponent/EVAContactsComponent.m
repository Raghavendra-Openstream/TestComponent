//
//  EVAContactsComponent.m
//  EVAContactsComponent
//
//  Created by OS Developer on 9/10/20.
//

#import "EVAContactsComponent.h"
#import "IApplicationContext.h"
#import "Logger.h"
#import "IMEvent.h"
#import "IM.h"
#import "MessageQueue.h"
#import "JSONObject.h"
#import "JSONArray.h"
#import "ApplicationUtil.h"
#import "StringUtil.h"
#import "EVAContactsComponentVersion.h"
#import "OSEContactsHandler.h"
#import "OSEContactsComponentError.h"


@interface EVAContactsComponent () {
    
    id<IApplicationContext> mAppContext_;
    IM * mIMHandler_;
    MessageQueue * mEventsQueue_;
    Logger * mLogger_;
    NSObject *mCameraLock_;
    UIViewController *mCameraViewControler_;
    JSONObject *mCaptureState_;
    OSEContactsHandler *mOSEContactsHandler_;
}

@end

@implementation EVAContactsComponent

static NSString* const LOGGER_NAME  = @"com.openstream.cueme.EVAContactComponent";
static NSString* const SOURCE_ID    = @"x-contact";

static NSString *S_EventAddNewContact = @"addNewContact";
static NSString *S_EventAddNewContactSuccess = @"onAddNewContactSuccess";
static NSString *S_EventAddNewContactFail = @"onAddNewContactFail";

static NSString *S_EventGetContacts = @"getContacts";
static NSString *S_EventGetContactsSuccess = @"onGetContactsSuccess";
static NSString *S_EventGetContactsFail = @"onGetContactsFail";

static NSString *S_EventGetParticularContact = @"getParticularContact";
static NSString *S_EventGetParticularContactFail = @"onGetParticularContactFail";

static NSString *S_EventUpdateContact = @"updateContact";
static NSString *S_EventUpdateContactFail = @"onUpdateContactFail";

static NSString *S_EventDeleteContact = @"deleteContact";
static NSString *S_EventDeleteContactFail = @"onDeleteContactFail";

static NSString *ContactResponseEventDataKeyRequest = @"request";
static NSString *ContactResponseEventDataKeyData = @"data";

static NSString *S_EventContactAccessDenied = @"contactAccessDenied";

// success object attribute names
static NSString * const S_SuccessAttrCode = @"successCode";
static NSString * const S_SuccessAttrDescription = @"successDescription";


- (id) init {
    
    if (self = [super init]) {
        mLogger_ = nil;
        mEventsQueue_ = [[MessageQueue alloc] initWithHandler:self];
        [mEventsQueue_ startRunning];
        mCaptureState_= [[JSONObject alloc] init];
    }
    return self;
}

- (void) initComponent:(NSDictionary *)pConfig {
    
    mAppContext_ = (id<IApplicationContext>)[pConfig objectForKey:@"appContext"];
    mLogger_ = [mAppContext_ getLogger:LOGGER_NAME];
    
    [mLogger_ debug:@"%@", [EVAContactsComponentVersion getVersionInfoToPrint]];
    
    [mLogger_ debug:@"EVContactComponent : init"];
}

- (void) setIMHandler:(IM *)pIm {
    mIMHandler_ = pIm;
}

- (void) handleEvent:(IMEvent *)evt {
    [mEventsQueue_ addMessageToQueue:evt];
}

- (int) processMessage:(NSObject *)pMessage {
    
    IMEvent *event = (IMEvent *)pMessage;
    
    // Log event received
    NSMutableString *eventStr = [[NSMutableString alloc] init];
    [event debug:eventStr];
    [mLogger_ debug:@"EVContactComponent : processMessage : %@", eventStr];
    
    if ([event.typeStr isEqualToString:S_EventAddNewContact]) {
                
        [self performSelectorOnMainThread:@selector(addNewContact:) withObject:event waitUntilDone:NO];
       
    } else if ([event.typeStr isEqualToString:S_EventGetContacts]) {
                
        [self performSelectorOnMainThread:@selector(getAllContacts:) withObject:event waitUntilDone:NO];
       
    } else if ([event.typeStr isEqualToString:S_EventGetParticularContact]) {
                
        [self performSelectorOnMainThread:@selector(getParticularContact:) withObject:event waitUntilDone:NO];
        
    } else if ([event.typeStr isEqualToString:S_EventUpdateContact]) {
        
        [self performSelectorOnMainThread:@selector(updateContact:) withObject:event waitUntilDone:NO];
        
    } else if ([event.typeStr isEqualToString:S_EventDeleteContact]) {
        
        [self performSelectorOnMainThread:@selector(deleteContact:) withObject:event waitUntilDone:NO];
    }
    
    return 0;
}

- (void) closeUI {
    // Close UI ...
}

- (void) unInit {
    
    [mOSEContactsHandler_ releaseLock:mOSEContactsHandler_];
    
    [mEventsQueue_ stopQueue];
    
    [self performSelectorOnMainThread:@selector(closeUI) withObject:nil waitUntilDone:TRUE];
    
    mIMHandler_ = nil;
    mAppContext_ = nil;
    mLogger_ = nil;
}

- (NSString *) getBase {
    return nil;
}

- (NSString *) getSourceId {
    return SOURCE_ID;
}

- (void) setBase:(NSString *)pArg0 {
}

- (BOOL) addEventListener:(NSString *)nodeId eventType:(NSString *)eventType {
    return YES;
}

- (BOOL) removeEventListeners {
    return YES;
}

- (BOOL) removeEventListener:(NSString *)pArg0 eventType:(NSString *)pArg1 {
    return YES;
}

- (void)clearStateInfo {
    
}


- (void)imReady {
    
}

- (void)onApplicationBackground {
    
}


- (void)onApplicationForeground {
    
}


- (void)onContainerBackground {
    
}


- (void)onContainerForeground {
    
}


- (void) raiseIMEvent:(NSString *)event fieldId:(NSString *)fieldId data:(NSString *)data {
    [mIMHandler_ addEvent:SOURCE_ID typestr:event target:fieldId data:data];
}

- (void) raiseErrorIMEvent:(NSString *)event target:(NSString *)fieldId error:(JSONObject *)error request:(JSONObject *)request{
    [error put:ContactResponseEventDataKeyRequest value:request];
    [self raiseIMEvent:event fieldId:fieldId data:[error toString]];
}

- (NSString *) dictionary2JsonString:(NSDictionary *)dict {
    
    [mLogger_ debug:@"%s", __PRETTY_FUNCTION__];
    
    if(dict == nil) {
        
        return nil;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonStr;
}

- (NSDictionary *) successDictionaryWithCode:(NSString *)code description:(NSString *)description {
    
    [mLogger_ debug:@"%s", __PRETTY_FUNCTION__];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:code, S_SuccessAttrCode, description, S_SuccessAttrDescription, nil];
}

- (void) initializeOSEContactHandler {
    
    if (mOSEContactsHandler_ == nil) {
        
        UINavigationController *navController = [mAppContext_ getCuemeAppNavigationController];
        [mLogger_ debug:@"Contacts : Create View Controller : viewcontroller presented=%@ top=%@",    [navController presentedViewController], [navController topViewController] ];
        
        UIViewController *parentViewController = navController.presentedViewController ? navController.presentedViewController : navController.topViewController;
        mOSEContactsHandler_ = [[OSEContactsHandler alloc] initWithViewController:parentViewController
                                                                           logger:mLogger_ ];
        mCameraLock_ = [mOSEContactsHandler_ acquireLock];
    }
}


/// Method to Add new contact to device
- (void)addNewContact:(IMEvent *)event {
    [mLogger_ debug:@"EVContactComponent : addNewContact"];
    [self initializeOSEContactHandler];
    __block EVAContactsComponent *bSelf = self;
    __block JSONObject *contactOptions = [[JSONObject alloc] init];
    
    [mOSEContactsHandler_ checkContactsPermission:^(BOOL permissionWasGranted) {
        
        if(permissionWasGranted) {
            
            NSError *error = nil;
            if ([StringUtil isNotBlank:(NSString*)event.data]) {
                contactOptions = [[JSONObject alloc] initWithJSONString:(NSString*)event.data error:&error];
            }
            
            [self->mOSEContactsHandler_ addNewContact:contactOptions withCompletion:^(BOOL updateContactStatus, NSError * _Nullable error) {
                
                if(updateContactStatus) {
                    //Success to add new contact
                    [bSelf->mLogger_ debug:@"EVContactComponent : Successfully added new contact"];
                } else {
                    //Fail to add new contact
                    [bSelf->mLogger_ debug:@"EVContactComponent : Failed to add new contact"];
                }
            }];
            
        } else {
            
            // raise permission error event
            [bSelf raiseErrorIMEvent:S_EventContactAccessDenied
                             target:event.target
                              error:[OSEContactsComponentError constructErrorWithCode:OSEContactsComponentErrorCodePermissionDenied errorDescription:nil]
                            request:[[JSONObject alloc]init]];
        }
    }];
}


/// Method to Get list of available contacts from device
- (void)getAllContacts:(IMEvent *)event {
    
    [mLogger_ debug:@"EVContactComponent : getContacts"];
    [self initializeOSEContactHandler];
    __block EVAContactsComponent *bSelf = self;
    
    [mOSEContactsHandler_ checkContactsPermission:^(BOOL permissionWasGranted) {
        
        if(permissionWasGranted) {
            
            [self->mOSEContactsHandler_ getContactsList:^(NSMutableArray * _Nullable contactList, NSError * _Nullable error) {
                
                //Will get an Array of Contact list
                
                NSString *eventData = [bSelf dictionary2JsonString:[bSelf successDictionaryWithCode:S_EventGetContactsSuccess description:@"Get Contacts successful..."]];
                
                [self->mIMHandler_ addEvent:[self getSourceId] typestr:S_EventGetContactsSuccess target:nil data:eventData];
            }];
            
        } else {
            
            // raise permission error event
            [bSelf raiseErrorIMEvent:S_EventContactAccessDenied
                             target:event.target
                              error:[OSEContactsComponentError constructErrorWithCode:OSEContactsComponentErrorCodePermissionDenied errorDescription:nil]
                            request:[[JSONObject alloc]init]];
        }
    }];
    
}

/// Method to Get a particular contact from device
- (void)getParticularContact:(IMEvent *)event {
    
    [mLogger_ debug:@"EVContactComponent : getParticularContact"];
    [self initializeOSEContactHandler];
    __block EVAContactsComponent *bSelf = self;
    __block JSONObject *contactOptions = [[JSONObject alloc] init];

    [mOSEContactsHandler_ checkContactsPermission:^(BOOL permissionWasGranted) {
        
        if(permissionWasGranted) {
            
            NSError *error = nil;
            if ([StringUtil isNotBlank:(NSString*)event.data]) {
                contactOptions = [[JSONObject alloc] initWithJSONString:(NSString*)event.data error:&error];
            }
            
            [self->mOSEContactsHandler_ getParticularContact:contactOptions withCompletion:^(NSDictionary * _Nullable contactDetail) {
                
                if(contactDetail) {
                    //Success to get particular contact detail
                    [bSelf->mLogger_ debug:@"EVContactComponent : Successfully to get particular contact details"];
                } else {
                    //Fail to get particular contact detail
                    [bSelf->mLogger_ debug:@"EVContactComponent : Failed to get particular contact details"];
                }
            }];
            
        } else {
            
            // raise permission error event
            [bSelf raiseErrorIMEvent:S_EventContactAccessDenied
                             target:event.target
                              error:[OSEContactsComponentError constructErrorWithCode:OSEContactsComponentErrorCodePermissionDenied errorDescription:nil]
                            request:[[JSONObject alloc]init]];
        }
    }];
}

/// Method to Update a particular contact details
- (void)updateContact:(IMEvent *)event {
    [mLogger_ debug:@"EVContactComponent : updateContact"];
    [self initializeOSEContactHandler];
    __block EVAContactsComponent *bSelf = self;
    __block JSONObject *contactOptions = [[JSONObject alloc] init];
    
    [mOSEContactsHandler_ checkContactsPermission:^(BOOL permissionWasGranted) {
        
        if(permissionWasGranted) {
            
            NSError *error = nil;
            if ([StringUtil isNotBlank:(NSString*)event.data]) {
                contactOptions = [[JSONObject alloc] initWithJSONString:(NSString*)event.data error:&error];
            }
            
            [self->mOSEContactsHandler_ updateContact:contactOptions withCompletion:^(BOOL updateContactStatus, NSError * _Nullable error) {
                
                if(updateContactStatus) {
                    //Success to update particular contact detail
                    [bSelf->mLogger_ debug:@"EVContactComponent : Successfully updated particular contact details"];
                } else {
                    //Fail to update particular contact detail
                    [bSelf->mLogger_ debug:@"EVContactComponent : Failed to updated particular contact details"];
                }
            }];
            
        } else {
            
            // raise permission error event
            [bSelf raiseErrorIMEvent:S_EventContactAccessDenied
                             target:event.target
                              error:[OSEContactsComponentError constructErrorWithCode:OSEContactsComponentErrorCodePermissionDenied errorDescription:nil]
                            request:[[JSONObject alloc]init]];
        }
    }];
}

/// Method to Delete a particular contact from device
- (void)deleteContact:(IMEvent *)event {
    
    [mLogger_ debug:@"EVContactComponent : deleteContact"];
    [self initializeOSEContactHandler];
    __block EVAContactsComponent *bSelf = self;
    __block JSONObject *contactOptions = [[JSONObject alloc] init];

    [mOSEContactsHandler_ checkContactsPermission:^(BOOL permissionWasGranted) {
        
        if(permissionWasGranted) {
            
            NSError *error = nil;
            if ([StringUtil isNotBlank:(NSString*)event.data]) {
                contactOptions = [[JSONObject alloc] initWithJSONString:(NSString*)event.data error:&error];
            }
            
            [self->mOSEContactsHandler_ deleteContact:contactOptions withCompletion:^(BOOL deleteContactStatus, NSError * _Nullable error) {
                
                if(deleteContactStatus) {
                    //Success to delete particular contact detail
                    [bSelf->mLogger_ debug:@"EVContactComponent : Successfully delete particular contact details"];
                } else {
                    //Fail to delete particular contact detail
                    [bSelf->mLogger_ debug:@"EVContactComponent : Failed to delete particular contact details"];
                }
            }];
            
        } else {
            
            // raise permission error event
            [bSelf raiseErrorIMEvent:S_EventContactAccessDenied
                             target:event.target
                              error:[OSEContactsComponentError constructErrorWithCode:OSEContactsComponentErrorCodePermissionDenied errorDescription:nil]
                            request:[[JSONObject alloc]init]];
        }
    }];
    
}

@end
