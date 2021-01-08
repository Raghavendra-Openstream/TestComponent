
/**
 * @author Anthapu Reddy
 * 
 */

@interface QueryResults : NSObject {
  int mStatus_;
  int mUpdateCount_;
  NSString * mMessage_;
  NSString * mResults_;
  BOOL mHasResults_;
}

@property(nonatomic) int status;
@property(nonatomic) int updateCount;
@property(nonatomic, retain) NSString * message;
@property(nonatomic, retain) NSString * results;

- (BOOL) hasResults;
- (void) setHasResults:(BOOL)pHasResults;
@end
