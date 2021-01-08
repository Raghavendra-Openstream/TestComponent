#import <Foundation/Foundation.h>

@class SQLiteDb ;
@class QueryResults ;
@class JSONObject ;
@class JSONArray;
@class Logger ;

@interface Database : NSObject {
}

- (id) init:(SQLiteDb *)db logger:(Logger *)logger;
- (BOOL) checkConnect;
- (void) closeDBConnection;
- (BOOL) loadQueryXMLData:(NSData *)xmlData;
- (BOOL) setQueries:(NSMutableDictionary *)queries ;
- (BOOL) checkDBExist;
- (QueryResults *) executeQuery:(NSString *)txnId queryId:(NSString *)queryId data:(JSONObject *)data cacheStmt:(BOOL)cacheStmt;
- (QueryResults *) executeQuery:(NSString *)txnId queryId:(NSString *)queryId data:(JSONObject *)data cacheStmt:(BOOL)cacheStmt disableLog:(BOOL)disableLog;
- (void) exec:(NSString *)sql;
- (void) clearStatementCache;
- (BOOL) changePassword:(NSString *)pwd ;

+ (JSONArray*) getResultData:(QueryResults*) queryResults logger:(Logger *)logger;

@end
