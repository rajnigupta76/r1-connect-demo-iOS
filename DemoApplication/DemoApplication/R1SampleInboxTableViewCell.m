#import "R1SampleInboxTableViewCell.h"
#import "R1Inbox.h"

@interface R1SampleInboxTableViewCell ()

@property (nonatomic, strong) UIView *unreadMarker;
@property (nonatomic, strong) UILabel *alertLabel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation R1SampleInboxTableViewCell

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.alertLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.alertLabel.numberOfLines = 0;
        self.alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.alertLabel];
        
        self.unreadMarker = [[UIView alloc] initWithFrame:CGRectZero];
        self.unreadMarker.layer.cornerRadius = 3;
        self.unreadMarker.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.unreadMarker];
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.alertLabel.font = [UIFont systemFontOfSize:14];
        
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
    return self;
}

// Configures the cell for displaying Inbox Message
- (void) setInboxMessage:(R1InboxMessage *)inboxMessage
{
    if (_inboxMessage == inboxMessage)
    {
        [self configureUnreadMarker];
        return;
    }
    
    _inboxMessage = inboxMessage;
    
    self.textLabel.text = inboxMessage.title;
    self.alertLabel.text = inboxMessage.alert;
    
    self.detailTextLabel.text = [self.dateFormatter stringFromDate:inboxMessage.createdDate];
    [self configureUnreadMarker];
    
    [self setNeedsLayout];
}

// Shows or hides unread marker view
- (void) configureUnreadMarker
{
    if ([self.unreadMarker isHidden] != _inboxMessage.unread)
        return;
    
    [self.unreadMarker setHidden:!_inboxMessage.unread];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.unreadMarker.frame = CGRectMake(4, (self.contentView.bounds.size.height - 6)/2, 6, 6);
    
    self.detailTextLabel.frame = CGRectMake(0, 0, self.contentView.bounds.size.width-10, 20);
    
    if (self.textLabel.text == nil)
    {
        self.alertLabel.frame = CGRectMake(15, 15, self.contentView.bounds.size.width-20, self.contentView.bounds.size.height-20);
    }else
    {
        self.textLabel.frame = CGRectMake(15, 15, self.contentView.bounds.size.width-20, 20);
        self.alertLabel.frame = CGRectMake(15, 35, self.contentView.bounds.size.width-20, self.contentView.bounds.size.height-45);
    }
}

// Calculates the height of the cell
+ (CGFloat) heightForCellWithInboxMessage:(R1InboxMessage *) inboxMessage cellWidth:(CGFloat) cellWidth
{
    CGFloat height = 25;
    
    if (inboxMessage.title != nil)
        height += 20;
    
    if (inboxMessage.alert != nil)
    {
        if ([inboxMessage.alert respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
        {
            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
            paragraph.lineBreakMode = NSLineBreakByWordWrapping;
            
            NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                         NSParagraphStyleAttributeName: paragraph};
            
            height += [inboxMessage.alert boundingRectWithSize:CGSizeMake(cellWidth-20, 100)
                                                       options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                    attributes:attributes
                                                       context:nil].size.height;
        }else
        {
            height += [inboxMessage.alert sizeWithFont:[UIFont systemFontOfSize:14]
                                     constrainedToSize:CGSizeMake(cellWidth-20, 100)
                                         lineBreakMode:NSLineBreakByWordWrapping].height;
        }
        
        height += 1;
    }
    
    if (height < 50)
        return 50;
    
    return height;
}

@end
