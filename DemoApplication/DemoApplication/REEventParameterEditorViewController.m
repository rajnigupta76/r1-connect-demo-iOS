#import "REEventParameterEditorViewController.h"
#import "REEventParameter.h"
#import "RETextValueCell.h"
#import "RESwitchCell.h"
#import "REEventParameterTypeViewController.h"

@interface REEventParameterEditorViewController ()

@property (nonatomic, retain) RETextValueCell *keyCell;
@property (nonatomic, retain) RETextValueCell *valueCell;
@property (nonatomic, retain) RESwitchCell *switchCell;

@end

@implementation REEventParameterEditorViewController

- (id) initWithEventParameter:(REEventParameter *) eventParameter
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Edit Parameter";
        
        _eventParameter = [eventParameter retain];
        [self.eventParameter addObserver:self forKeyPath:@"type" options:0 context:nil];
    }
    return self;
}

- (void) dealloc
{
    self.keyCell = nil;
    self.valueCell = nil;
    self.switchCell = nil;
    
    [self.eventParameter removeObserver:self forKeyPath:@"type" context:nil];
    [_eventParameter release], _eventParameter = nil;
    
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.keyCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"KeyCell"] autorelease];
    self.keyCell.textField.returnKeyType = UIReturnKeyDone;
    self.keyCell.textField.placeholder = @"Key (String)";
    self.keyCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.keyCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyCell.textField.delegate = (id)self;
    self.keyCell.textField.enablesReturnKeyAutomatically = YES;
    self.keyCell.textField.text = self.eventParameter.key;
    if (self.eventParameter.isPredefined)
        self.keyCell.textField.userInteractionEnabled = NO;
    
    self.valueCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"ValueCell"] autorelease];
    self.valueCell.textField.returnKeyType = UIReturnKeyDone;
    self.valueCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.valueCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.valueCell.textField.delegate = (id)self;
    self.valueCell.textField.enablesReturnKeyAutomatically = YES;
    
    self.switchCell = [[[RESwitchCell alloc] initCellWithReuseIdentifier:@"SwitchCell"] autorelease];
    self.switchCell.textLabel.text = @"Value:";
    [self.switchCell.switchView addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];

    if (self.eventParameter.type == REEventParameterTypeBool)
        self.switchCell.switchView.on = [(NSNumber *)self.eventParameter.value boolValue];
    else
        self.valueCell.textField.text = [self.eventParameter stringFromValue];
    
    [self configureValueCellForParameterType];
}

- (void) viewDidUnload
{
    self.keyCell = nil;
    self.valueCell = nil;
    
    [super viewDidUnload];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![self isViewLoaded])
        return;
    
    [self.tableView reloadData];
    
    [self configureValueCellForParameterType];
    
    if (self.eventParameter.type == REEventParameterTypeBool)
    {
        [self.eventParameter generateRandomValue];
        self.switchCell.switchView.on = [(NSNumber *)self.eventParameter.value boolValue];
    }
    else
    {
        self.eventParameter.value = nil;
        self.valueCell.textField.text = [self.eventParameter stringFromValue];
    }
}

- (void) configureValueCellForParameterType
{
    switch (self.eventParameter.type)
    {
        case REEventParameterTypeString:
            self.valueCell.textField.placeholder = @"String value (abcd)";
            self.valueCell.textField.keyboardType = UIKeyboardTypeDefault;
            break;
        case REEventParameterTypeLong:
            self.valueCell.textField.placeholder = @"Long value (1234)";
            self.valueCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
        case REEventParameterTypeDouble:
            self.valueCell.textField.placeholder = @"Double value (123.456)";
            self.valueCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Key:";
        case 1:
            return @"Type:";
        case 2:
            if (self.eventParameter.type != REEventParameterTypeBool)
                return @"Value:";
            
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return self.keyCell;
    if (indexPath.section == 2)
    {
        if (self.eventParameter.type == REEventParameterTypeBool)
            return self.switchCell;
        
        return self.valueCell;
    }
    
    static NSString *CellIdentifier = @"TypeCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = (self.eventParameter.isPredefined) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [REEventParameter typeToString:self.eventParameter.type];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        if (self.eventParameter.isPredefined)
        {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            
            return;
        }
        
        REEventParameterTypeViewController *parameterTypeViewController = [[REEventParameterTypeViewController alloc] initWithEventParameter:self.eventParameter];
        
        [self.navigationController pushViewController:parameterTypeViewController animated:YES];
        
        [parameterTypeViewController release];
        
        return;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if (textField == self.keyCell.textField)
    {
        self.eventParameter.key = newText;
        return YES;
    }
    
    if ([newText length] == 0)
    {
        self.eventParameter.value = nil;
        return YES;
    }
    
    if (![REEventParameter isValueValue:newText type:self.eventParameter.type])
        return NO;
    
    [self.eventParameter valueFromString:newText];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) switchChanged
{
    self.eventParameter.value = [NSNumber numberWithBool:self.switchCell.switchView.on];
}

@end
