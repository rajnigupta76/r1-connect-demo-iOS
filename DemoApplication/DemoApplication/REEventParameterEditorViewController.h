#import <UIKit/UIKit.h>

@class REEventParameter;

@interface REEventParameterEditorViewController : UITableViewController

@property (nonatomic, strong, readonly) REEventParameter *eventParameter;

- (id) initWithEventParameter:(REEventParameter *) eventParameter;

@end