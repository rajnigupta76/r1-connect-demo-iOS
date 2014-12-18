#import <Foundation/Foundation.h>

typedef enum
{
    RETestCaseTypeEvent,
    RETestCaseTypeAction,
    RETestCaseTypeLogin,
    RETestCaseTypeRegistration,
    RETestCaseTypeFBConnect,
    RETestCaseTypeTConnect,
    RETestCaseTypeTransaction,
    RETestCaseTypeTransactionItem,
    RETestCaseTypeCartCreate,
    RETestCaseTypeCartDelete,
    RETestCaseTypeAddToCart,
    RETestCaseTypeDeleteFromCart,
    RETestCaseTypeUpgrade,
    RETestCaseTypeTrialUpgrade,
    RETestCaseTypeScreenView
} RETestCaseType;

@interface RETestCase : NSObject

@property (nonatomic, readonly) RETestCaseType type;

@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) BOOL hasParameters;
@property (nonatomic, readonly) NSString *predefinedEventName;
@property (nonatomic, readonly) NSArray  *predefinedEventParameters;
@property (nonatomic, readonly) BOOL hasLineItem;
@property (nonatomic, readonly) BOOL hasPermissions;

- (id) initWithType:(RETestCaseType) type;

+ (RETestCase *) testCaseWithType:(RETestCaseType) type;

- (void) emitWithEventName:(NSString *) eventName withParameters:(NSDictionary *) parameters;

@end
