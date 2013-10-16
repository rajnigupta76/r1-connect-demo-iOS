#import <UIKit/UIKit.h>

@class REEventParameter;

@interface REEventParameterEditorViewController : UITableViewController

@property (nonatomic, readonly) REEventParameter *eventParameter;

- (id) initWithEventParameter:(REEventParameter *) eventParameter;

@end