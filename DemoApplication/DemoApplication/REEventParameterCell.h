#import <UIKit/UIKit.h>

@class REEventParameter;

@interface REEventParameterCell : UITableViewCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, retain) REEventParameter *eventParameter;

@end
