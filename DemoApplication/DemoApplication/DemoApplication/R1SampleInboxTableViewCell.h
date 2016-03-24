#import <UIKit/UIKit.h>

@class R1InboxMessage;

@interface R1SampleInboxTableViewCell : UITableViewCell

// Sets or Gets R1InboxMessage object and configures cell for it
@property (nonatomic, strong) R1InboxMessage *inboxMessage;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

// Calculates the height of the cell
+ (CGFloat) heightForCellWithInboxMessage:(R1InboxMessage *) inboxMessage cellWidth:(CGFloat) cellWidth;

@end
