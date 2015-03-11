#import <UIKit/UIKit.h>

@interface RETextValueCell : UITableViewCell

@property (nonatomic, readonly) UITextField *textField;

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id) initLabelCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
