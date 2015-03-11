#import "RESwitchCell.h"

@implementation RESwitchCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchView sizeToFit];
        [self.contentView addSubview:_switchView];
    }
    return self;
}

- (void) dealloc
{
    [_switchView release];
    _switchView = nil;
    
    [super dealloc];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:NO];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect switchFrame = self.switchView.frame;
    switchFrame.origin = CGPointMake(self.contentView.bounds.size.width-switchFrame.size.width-10, (self.contentView.bounds.size.height-switchFrame.size.height)/2);

    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size.width = switchFrame.origin.x-10-textLabelFrame.origin.x;

    self.textLabel.frame = textLabelFrame;
    self.switchView.frame = switchFrame;
}

@end
