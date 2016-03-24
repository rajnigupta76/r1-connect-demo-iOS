#import <UIKit/UIKit.h>

@class REEventParameter;

@interface REEventParameterCell : UITableViewCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) REEventParameter *eventParameter;

@end
