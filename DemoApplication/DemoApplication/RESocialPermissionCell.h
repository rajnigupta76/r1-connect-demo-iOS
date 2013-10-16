#import "RETextValueCell.h"

@class R1EmitterSocialPermission;

@interface RESocialPermissionCell : RETextValueCell

@property (nonatomic, retain) R1EmitterSocialPermission *permission;

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
