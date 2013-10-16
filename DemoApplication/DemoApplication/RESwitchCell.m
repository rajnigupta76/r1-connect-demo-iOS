#import "RESwitchCell.h"

@implementation RESwitchCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
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
    
    self.textLabel.frame = CGRectMake(10, 10, self.contentView.bounds.size.width-100, self.contentView.bounds.size.height-20);
    self.switchView.frame = CGRectMake(self.contentView.bounds.size.width-80, (self.contentView.bounds.size.height-30)/2, 70, 30);
}

@end
