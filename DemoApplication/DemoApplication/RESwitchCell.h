#import <UIKit/UIKit.h>

@interface RESwitchCell : UITableViewCell

@property (nonatomic, readonly) UISwitch *switchView;

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
