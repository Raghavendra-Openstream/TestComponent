//
//  OSEContactsHandler.m
//  EVAContactsComponent
//
//  Created by OS Developer on 9/10/20.
//

#import "OSEContactsHandler.h"

@interface OSEContactsHandler () {
    
    UIViewController *mParentViewController_;
    Logger *mLogger_;
    CNContactStore *contactStore;
}

@end

@implementation OSEContactsHandler
static NSObject* ContactLock ;

/// Method to initialize OSEContactsHandler using top viewController
/// @param viewController top showing viewController
/// @param logger will use to print logs
- (id)initWithViewController:(UIViewController *)viewController logger:(id)logger {
    
    self = [super init];
    if (self) {
        mParentViewController_ = viewController;
        mLogger_ = logger;
                
        //Create repository objects contacts
        contactStore = [[CNContactStore alloc] init];
    }
    
    return self;
}

// TODO: Keyur : Implement lock relinquish
- (NSObject*) acquireLock {
    if( ContactLock == nil ) {
        ContactLock = [[NSObject alloc] init] ;
        return ContactLock ;
    }
    return nil ;
}

- (void) releaseLock: (NSObject*) lock {
    if( lock == ContactLock ) {
        ContactLock = nil ;
    }
}

/// Method to Check Device Contacts usage permission
/// @param completionHandler returns permission granted result YES or NO
- (void)checkContactsPermission:(void (^)(BOOL))completionHandler {
    
    [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
        if(granted)
            completionHandler(YES);
        else
            completionHandler(NO);
    }];
    
}

/// Method to Add New contact to device
/// @param addNewContactOptions JSONObject contains new contact details
/// @param completionHandler returns new contact added result YES or NO
- (void)addNewContact:(JSONObject *)addNewContactOptions withCompletion:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    
    CNMutableContact *mutableContact = [[CNMutableContact alloc] init];
        
    NSString *firstName = [addNewContactOptions getString:@"firstName"];
    NSString *lastName = [addNewContactOptions getString:@"lastName"];
    NSString *phoneNumber = [addNewContactOptions getString:@"phoneNumber"];
    NSString *email = [addNewContactOptions getString:@"email"];

    if(firstName)
        mutableContact.givenName = firstName;
    
    if(lastName)
        mutableContact.familyName = lastName;
    
    if(email)
        mutableContact.emailAddresses = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelEmailiCloud value:email], nil];
    
    if(phoneNumber)
        mutableContact.phoneNumbers = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]], nil];// @[[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]];
    
    CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
    [saveRequest addContact:mutableContact toContainerWithIdentifier:contactStore.defaultContainerIdentifier];

    NSError *error;
    if([contactStore executeSaveRequest:saveRequest error:&error])
        completionHandler(YES, nil);
    else
        completionHandler(NO, nil);
    
}

/// Method to get list of contacts available in device
/// @param completionHandler returns Array of contact list
- (void)getContactsList:(void (^)(NSMutableArray * _Nullable, NSError * _Nullable))completionHandler {
    
    NSMutableArray *contactList = [[NSMutableArray alloc] init];
    
    NSArray *keys = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
    
    // Create a request object
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    request.predicate = nil;
    
    [contactStore enumerateContactsWithFetchRequest:request
                                              error:nil
                                         usingBlock:^(CNContact* __nonnull contact, BOOL* __nonnull stop)
     {
        // Contact one each function block is executed whenever you get
        NSString *phoneNumber = @"";
        if( contact.phoneNumbers)
            phoneNumber = [[[contact.phoneNumbers firstObject] value] stringValue];
        
        [self->mLogger_ debug:@"phoneNumber = %@", phoneNumber];
        [self->mLogger_ debug:@"givenName = %@", contact.givenName];
        [self->mLogger_ debug:@"familyName = %@", contact.familyName];
        [self->mLogger_ debug:@"email = %@", contact.emailAddresses];
        
        NSDictionary *contactDetail = @{
            @"identifier":contact.identifier,
            @"firstName":contact.givenName,
            @"lastName":contact.familyName,
            @"phoneNumber":contact.phoneNumbers,
            @"imageData":[NSData dataWithData:contact.imageData]
        };
         
        [contactList addObject:contactDetail];
     }];
    
    completionHandler(contactList, nil);
}

/// Method to get Particular contact details
/// @param contactOptions JSONObject contains contact unique key details to identify contact
/// @param completionHandler returns requested contact details
- (void)getParticularContact:(JSONObject *)contactOptions withCompletion:(void (^)(NSDictionary * _Nullable))completionHandler {
    
    NSString *phoneNumber = [contactOptions getString:@"phoneNumber"];
    
    if(!phoneNumber) {
        
        [mLogger_ debug:@"Error: please provide valid phone number to fetch contact"];
        completionHandler(nil);
        
    } else {
        
        CNContact *contact = [self getParticularContact:phoneNumber];
        if(!contact) {
            
            [mLogger_ debug:@"Error: fetching contact"];
            completionHandler(nil);
            
        } else {
            
            [self->mLogger_ debug:@"phoneNumber = %@", phoneNumber];
            [self->mLogger_ debug:@"givenName = %@", contact.givenName];
            [self->mLogger_ debug:@"familyName = %@", contact.familyName];
            [self->mLogger_ debug:@"email = %@", contact.emailAddresses];
            
            NSDictionary *contactDetail = @{
               @"identifier":contact.identifier,
               @"firstName":contact.givenName,
               @"lastName":contact.familyName,
               @"phoneNumber":contact.phoneNumbers,
               @"imageData":[NSData dataWithData:contact.imageData]
            };
            
            completionHandler(contactDetail);
        }
    }
}


/// Method to get particular CNContact from device contacts list
/// @param phoneNumber input key to get contact from device
- (CNContact *)getParticularContact:(NSString *)phoneNumber {
    
    NSPredicate* predicate = [CNContact predicateForContactsMatchingPhoneNumber:[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]];
    NSArray* keysToFetch = [[NSArray alloc]initWithObjects:CNContactIdentifierKey, CNContactEmailAddressesKey, CNContactBirthdayKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactViewController.descriptorForRequiredKeys, nil];
    //@[CNContactFamilyNameKey, CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey, CNContactEmailAddressesKey, CNContactPostalAddressesKey];
    NSError *error;
    NSArray *contacts = [contactStore unifiedContactsMatchingPredicate:predicate
                                                           keysToFetch:keysToFetch
                                                                 error:&error];
    if (error) {
        [mLogger_ debug:@"error fetching contacts %@", error];
        return nil;
    } else {
       
        NSMutableArray *contactList = [[NSMutableArray alloc] init];
        
        for (CNContact *contact in contacts) {
                      
            [contactList addObject:contact];
        }
        
        if([contactList count] > 0)
            return contactList.firstObject;
        else
            return nil;
    }
}

/// Method to update contact details
/// @param updateContactOptions JSONObject contains updated contact details
/// @param completionHandler returns update contact result YES or NO
- (void)updateContact:(JSONObject *)updateContactOptions withCompletion:(void (^)(BOOL , NSError * _Nullable))completionHandler {
    
    NSString *phoneNumber = [updateContactOptions getString:@"phoneNumber"];
    
    if(!phoneNumber) {
        
        [mLogger_ debug:@"Error: please provide valid phone number to update contact"];
        completionHandler(NO, nil);
        
    } else {
        
        CNContact *contact = [self getParticularContact:phoneNumber];
        CNMutableContact *mutableContact = contact.mutableCopy;
        
        NSString *firstName = [updateContactOptions getString:@"firstName"];
        NSString *lastName = [updateContactOptions getString:@"lastName"];
        NSString *phoneNumber = [updateContactOptions getString:@"phoneNumber"];
        NSString *email = [updateContactOptions getString:@"email"];
        
        if(firstName)
            mutableContact.givenName = firstName;
        
        if(lastName)
            mutableContact.familyName = lastName;
        
        if(email)
            mutableContact.emailAddresses = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelEmailiCloud value:email], nil];
        
        if(phoneNumber)
            mutableContact.phoneNumbers = [[NSArray alloc] initWithObjects:[CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]], nil];// @[[CNPhoneNumber phoneNumberWithStringValue:phoneNumber]];
        
        CNSaveRequest *saveRequest = [[CNSaveRequest alloc] init];
        [saveRequest updateContact:mutableContact];
        
        NSError *error;
        if([contactStore executeSaveRequest:saveRequest error:&error])
            completionHandler(YES, nil);
        else
            completionHandler(NO, nil);
    }
}

/// Method to delete contact
/// @param deleteContactOptions JSONObject contains contact unique key details to delete contact
/// @param completionHandler returns delete contact result YES or NO
- (void)deleteContact:(JSONObject *)deleteContactOptions withCompletion:(void (^)(BOOL, NSError * _Nullable))completionHandler {
    
    NSString *phoneNumber = [deleteContactOptions getString:@"phoneNumber"];
    
    if(!phoneNumber) {
        
        [mLogger_ debug:@"Error: please provide valid phone number to delete contact"];
        completionHandler(NO, nil);
        
    } else {
        
        CNContact *contact = [self getParticularContact:phoneNumber];
        CNMutableContact *mutableContact = contact.mutableCopy;
        
        CNSaveRequest *deleteRequest = [[CNSaveRequest alloc] init];
        [deleteRequest deleteContact:mutableContact];
        
        NSError *error;
        if([contactStore executeSaveRequest:deleteRequest error:&error])
            completionHandler(YES, nil);
        else
            completionHandler(NO, nil);
    }
}

@end
