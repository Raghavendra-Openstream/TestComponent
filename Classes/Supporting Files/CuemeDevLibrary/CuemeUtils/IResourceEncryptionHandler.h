/*
 * IResourceEncryptionHandler.h
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
 * Author: Opensteam Inc
 *
 * Created On : Jul 23, 2014
 *
 */

#import <Foundation/Foundation.h>

#import "Logger.h"

@protocol IResourceEncryptionHandler <NSObject>


/**
 * The file stream corresponding to filepath will be returned.
 * If enckey is null then suitable key used will be identified and file will be decrypted appropriately.
 *
 * @param filePath  File path must be a cueme url
 * @param customEncryptionKey   (optional) Custom encryption key to use
 * @param logger logger object to log
 * @return NSdata with contents of the file
 * @throws Exception
 */
- (NSData *) readFile:(NSString *)filePath customEncryptionKey:(NSData *)customEncryptionKey logger:(Logger *)logger;


/**
 * This method will save given data in encrypted form at given location. If encKey is sent then it will be used for
 * encryption, if not workbench decided encKey will be used for saving if encryptFile is set to true. If workbench
 * key is used for encrypting data then same will be tracked in workbench database. If encryptFile is false the data
 * will be saved without encrypting irrespective of encKey parameter value.
 *
 * @param data  Byte data to save
 * @param filePath  Path where the data must be saved. This must be a cueme supported url
 * @param customEncryptionKey (optional) Custom encryption key to encrypt
 * @param encrypt Bool which indicates if the file must be encrypted
 * @param shared  Set it to YES if this file needs to be accessed by other applications.
 * @param logger logger object to log
 *
 * @return YES if save operation was successfull.
 * @throws Exception
 */
- (BOOL) saveFile:(NSData *)data filePath:(NSString *)filePath customEncryptionKey:(NSData *)customEncryptionKey encrypt:(BOOL)encrypt isShared:(BOOL)shared logger:(Logger *)logger;

/**
 * File with the given name is deleted, also if encryption related information about this files is
 * also removed
 *
 * @param filePath Must be a cueme supported url
 * @param logger logger object to log
 *
 * @return false if any of the resource deletion failed.
 */
- (BOOL) deleteFile:(NSString *)filePath logger:(Logger *)logger;


/**
 * Checks whether file is encrypted using system key or not, it can be resource or app created data. Returns true if
 * file is encrypted using system keys. False means either it is not encrypted or encrypted using non system key
 *
 * @param url cueme supported url
 * @return Return YES if the file was encrypted. False means either it is not encrypted or encrypted using non system key
 */
- (BOOL) isEncryptedResource:(NSString *)url logger:(Logger *)logger;

/**
 * Encrypts the input data and returns the encrypt stream. If encKey is sent then it will be used for encryption, if
 * not workbench decided encKey will be used for saving.
 *
 * @param data Byte data to encrypt
 * @param encKey encryption key
 * @param logger logger instance to log
 * @return Encrypted byte data
 * @throws Exception
 */
- (NSData *) encrypt:(NSData *)data encKey:(NSData *)encKey logger:(Logger *)logger;

/**
 * Decrypts the input data and returns the decrypt stream. If encKey is sent then it will be used for decryption, if
 * not workbench decided encKey will be used for saving.
 *
 * @param data Byte data to decrypt
 * @param encKey encryption key
 * @param logger logger instance to log
 * @return Decrypted byte data
 * @throws Exception
 */
- (NSData *) decrypt:(NSData *)data encKey:(NSData *)encKey logger:(Logger *)logger;

@end
