#import "REEventParameterCell.h"
#import "REEventParameter.h"

@implementation REEventParameterCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void) dealloc
{
    self.eventParameter = nil;
}

- (void) setEventParameter:(REEventParameter *)eventParameter
{
    [_eventParameter removeObserver:self forKeyPath:@"type" context:nil];
    [_eventParameter removeObserver:self forKeyPath:@"key" context:nil];
    [_eventParameter removeObserver:self forKeyPath:@"value" context:nil];
    
    _eventParameter = eventParameter;
    
    self.textLabel.text = _eventParameter.visibleKey != nil ? _eventParameter.visibleKey : _eventParameter.key;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", ([_eventParameter stringFromValue] == nil) ? @"Empty" : [_eventParameter stringFromValue], [REEventParameter typeToString:_eventParameter.type]];
    
    [_eventParameter addObserver:self forKeyPath:@"type" options:0 context:nil];
    [_eventParameter addObserver:self forKeyPath:@"key" options:0 context:nil];
    [_eventParameter addObserver:self forKeyPath:@"value" options:0 context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    self.textLabel.text = _eventParameter.visibleKey != nil ? _eventParameter.visibleKey : _eventParameter.key;
    self.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)", ([_eventParameter stringFromValue] == nil) ? @"Empty" : [_eventParameter stringFromValue], [REEventParameter typeToString:_eventParameter.type]];
    
    [self setNeedsLayout];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
}

@end
