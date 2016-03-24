#import <UIKit/UIKit.h>

@interface RESwitchCell : UITableViewCell

@property (nonatomic, strong, readonly) UISwitch *switchView;

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
