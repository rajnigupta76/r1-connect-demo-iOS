#import <UIKit/UIKit.h>

@class RETestCase;
@protocol REEventParametersViewControllerDelegate;

@interface REEventParametersViewController : UITableViewController

@property (nonatomic, strong, readonly) RETestCase *testCase;
@property (nonatomic, assign) id<REEventParametersViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL hasParameters;
@property (nonatomic, assign) BOOL hasLineItem;
@property (nonatomic, assign) BOOL hasPermissions;
@property (nonatomic, strong) NSString *predefinedEventName;
@property (nonatomic, strong) NSArray  *predefinedEventParameters;

- (id) initViewController;
- (id) initViewControllerWithTestCase:(RETestCase *) testCase;

@end

@protocol REEventParametersViewControllerDelegate <NSObject>

- (void) eventParametersViewControllerDidCancelled:(REEventParametersViewController *) eventParametersViewController;
- (void) eventParametersViewController:(REEventParametersViewController *) eventParametersViewController didFinishedWithEventName:(NSString *) eventName withParameters:(NSDictionary *) parameters;

@end
