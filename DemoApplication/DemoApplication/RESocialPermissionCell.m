#import "RESocialPermissionCell.h"
#import "R1EmitterSocialPermission.h"

@interface RESocialPermissionCell ()

@property (nonatomic, retain) UISwitch *grantedSwitch;

@end

@implementation RESocialPermissionCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initCellWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textField.placeholder = @"Name";
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.delegate = (id)self;
        
        self.grantedSwitch = [[[UISwitch alloc] initWithFrame:CGRectZero] autorelease];
        [self.grantedSwitch addTarget:self action:@selector(grantedSwitchChanged) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:self.grantedSwitch];
    }
    return self;
}

- (void) dealloc
{
    self.permission = nil;
    
    self.grantedSwitch = nil;
    
    [super dealloc];
}

- (void) setPermission:(R1EmitterSocialPermission *)permission
{
    if (permission == _permission)
        return;
    
    [_permission release];
    _permission = [permission retain];
    
    self.textField.text = _permission.name;
    self.grantedSwitch.on = _permission.granted;
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.grantedSwitch.frame = CGRectMake(self.contentView.bounds.size.width-80, (self.contentView.bounds.size.height-30)/2, 70, 30);
    self.textField.frame = CGRectMake(10, 10, self.contentView.bounds.size.width-100, self.contentView.bounds.size.height-20);
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.permission.name = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) grantedSwitchChanged
{
    self.permission.granted = self.grantedSwitch.on;
}

@end
