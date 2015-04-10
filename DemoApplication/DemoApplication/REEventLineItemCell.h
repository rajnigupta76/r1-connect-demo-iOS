#import <UIKit/UIKit.h>

@class R1EmitterLineItem;

@interface REEventLineItemCell : UITableViewCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) R1EmitterLineItem *lineItem;

+ (CGFloat) heightForLineItem:(R1EmitterLineItem *) lineItem withWidth:(CGFloat) width;

@end
