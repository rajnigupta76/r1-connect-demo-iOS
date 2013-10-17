#import "RESharedParametersViewController.h"
#import "RETextValueCell.h"
#import "R1SDK.h"

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Application User ID:";
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return self.appUserIdCell;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StartCell"] autorelease];
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = @"Location Service";
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        [R1SDK showLocationOptionsInNavigationController:self.navigationController animated:YES];
    }
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

@end
