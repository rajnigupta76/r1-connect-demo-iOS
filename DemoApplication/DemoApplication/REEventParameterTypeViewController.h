#import <UIKit/UIKit.h>

@class REEventParameter;

@interface REEventParameterTypeViewController : UITableViewController

@property (nonatomic, readonly) REEventParameter *eventParameter;

- (id) initWithEventParameter:(REEventParameter *) eventParameter;

@end
