#import "RETextValueCell.h"

@interface RETextValueCell ()

@property (nonatomic, assign) BOOL labelCell;

@end

@implementation RETextValueCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
	{
		_textField = [[UITextField alloc] initWithFrame:CGRectZero];
		[self.textField setBorderStyle:UITextBorderStyleNone];
		[self.textField setBackgroundColor:[UIColor clearColor]];
		[self.textField setOpaque:YES];
		
		[self.contentView addSubview:self.textField];
    }
    return self;
}

- (id) initLabelCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self)
	{
        self.labelCell = YES;
        
		_textField = [[UITextField alloc] initWithFrame:CGRectZero];
		[self.textField setBorderStyle:UITextBorderStyleNone];
		[self.textField setBackgroundColor:[UIColor clearColor]];
		[self.textField setOpaque:YES];
        
		[self.contentView addSubview:self.textField];
    }
    return self;
}

- (void) layoutSubviews
{
	[super layoutSubviews];
	
    if (self.labelCell)
    {
        CGFloat offset = self.textLabel.frame.size.width+self.textLabel.frame.origin.x;
        self.textField.frame = CGRectMake(offset+10, 10, self.contentView.bounds.size.width-20-offset, self.contentView.bounds.size.height-20);
    }else
        self.textField.frame = CGRectMake(10, 10, self.contentView.bounds.size.width-20, self.contentView.bounds.size.height-20);
    
	[self.contentView bringSubviewToFront:self.textField];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void) dealloc
{
    [_textField performSelector:@selector(release)
                     withObject:nil
                     afterDelay:1.0];
	
    [super dealloc];
}

@end