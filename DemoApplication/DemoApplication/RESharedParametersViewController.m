#import "RESharedParametersViewController.h"
#import "RETextValueCell.h"
#import "R1SDK.h"
#import "RELocationParametersViewController.h"
#import "RESwitchCell.h"

@interface RESharedParametersViewController ()

@property (nonatomic, retain) RETextValueCell *appUserIdCell;

@end

@implementation RESharedParametersViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Shared Options";
    }
    return self;
}

- (void) dealloc
{
    self.appUserIdCell = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appUserIdCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"AppUserIdCell"] autorelease];
    self.appUserIdCell.textField.returnKeyType = UIReturnKeyDone;
    self.appUserIdCell.textField.placeholder = @"App User ID";
    self.appUserIdCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.appUserIdCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.appUserIdCell.textField.delegate = (id)self;
    self.appUserIdCell.textField.enablesReturnKeyAutomatically = YES;
    self.appUserIdCell.textField.text = [R1SDK sharedInstance].applicationUserId;
}

- (void) viewDidUnload
{
    self.appUserIdCell = nil;
    
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Application User ID:";
    if (section == 1)
        return @"Advertising Enabled:";
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return self.appUserIdCell;
    
    if (indexPath.section == 1)
    {
        RESwitchCell *switchCell = (RESwitchCell *)[tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        if (switchCell == nil)
        {
            switchCell = [[[RESwitchCell alloc] initCellWithReuseIdentifier:@"SwitchCell"] autorelease];
            switchCell.textLabel.text = @"Disable All Advertising Ids:";
            [switchCell.switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
        switchCell.switchView.on = [R1SDK sharedInstance].disableAllAdvertisingIds;

        return switchCell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"] autorelease];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = @"Location Service";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        RELocationParametersViewController *locationServiceViewController = [[RELocationParametersViewController alloc] initViewController];
        [self.navigationController pushViewController:locationServiceViewController animated:YES];
        [locationServiceViewController release];
        return;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.appUserIdCell.textField)
    {
        [R1SDK sharedInstance].applicationUserId = newText;
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) switchChanged:(UISwitch *) switchView
{
    [R1SDK sharedInstance].disableAllAdvertisingIds = switchView.on;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:switchView.on forKey:@"r1EmitterDemoDisableAllAdvertisingIds"];
    [ud synchronize];
}

@end
