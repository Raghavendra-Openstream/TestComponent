//
//  OSEContactsHandler.h
//  EVAContactsComponent
//
//  Created by OS Developer on 9/10/20.
//

#import <Foundation/Foundation.h>
#import <ContactsUI/ContactsUI.h>
#import "JSONObject.h"
#import "Logger.h"

NS_ASSUME_NONNULL_BEGIN

@interface OSEContactsHandler : NSObject <CNContactViewControllerDelegate, CNContactPickerDelegate>

/// Method to initialize OSEContactsHandler using top viewController
/// @param viewController top showing viewController
/// @param logger will use to print logs
- (id)initWithViewController:(UIViewController *)viewController logger:(Logger *)logger;

- (NSObject*) acquireLock ;

- (void) releaseLock: (NSObject*) lock ;


/// Method to Check Device Contacts usage permission
/// @param completionHandler returns permission granted result YES or NO
- (void)checkContactsPermission:(void(^)(BOOL permissionWasGranted))completionHandler;


/// Method to Add New contact to device
/// @param addNewContactOptions JSONObject contains new contact details
/// @param completionHandler returns new contact added result YES or NO
- (void)addNewContact:(JSONObject *)addNewContactOptions withCompletion:(void(^)(BOOL addNewContactStatus, NSError * _Nullable error))completionHandler;


/// Method to get list of contacts available in device
/// @param completionHandler returns Array of contact list
- (void)getContactsList:(void(^)(NSMutableArray * _Nullable contactList, NSError * _Nullable error))completionHandler;


/// Method to get Particular contact details
/// @param contactOptions JSONObject contains contact unique key details to identify contact
/// @param completionHandler returns requested contact details
- (void)getParticularContact:(JSONObject *)contactOptions withCompletion:(void(^)(NSDictionary * _Nullable contactDetail))completionHandler;


/// Method to update contact details
/// @param updateContactOptions JSONObject contains updated contact details
/// @param completionHandler returns update contact result YES or NO
- (void)updateContact:(JSONObject *)updateContactOptions withCompletion:(void(^)(BOOL updateContactStatus, NSError * _Nullable error))completionHandler;


/// Method to delete contact
/// @param deleteContactOptions JSONObject contains contact unique key details to delete contact
/// @param completionHandler returns delete contact result YES or NO
- (void)deleteContact:(JSONObject *)deleteContactOptions withCompletion:(void(^)(BOOL deleteContactStatus, NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
