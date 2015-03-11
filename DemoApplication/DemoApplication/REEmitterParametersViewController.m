#import "REEmitterParametersViewController.h"
#import "RETextValueCell.h"
#import "R1Emitter.h"

@interface REEmitterParametersViewController ()

@property (nonatomic, retain) RETextValueCell *appIdCell;
@property (nonatomic, retain) RETextValueCell *appVersionCell;

@end

@implementation REEmitterParametersViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Emitter Options";
    }
    return self;
}

- (void) dealloc
{
    self.appIdCell = nil;
    self.appVersionCell = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appIdCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"AppUserIdCell"] autorelease];
    self.appIdCell.textField.returnKeyType = UIReturnKeyDone;
    self.appIdCell.textField.placeholder = @"iTunes Application ID";
    self.appIdCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.appIdCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.appIdCell.textField.delegate = (id)self;
    self.appIdCell.textField.enablesReturnKeyAutomatically = YES;
    self.appIdCell.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterDemoAppId"];
    
    self.appVersionCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"AppVersionCell"] autorelease];
    self.appVersionCell.textField.returnKeyType = UIReturnKeyDone;
    self.appVersionCell.textField.placeholder = @"Application Version";
    self.appVersionCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.appVersionCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.appVersionCell.textField.delegate = (id)self;
    self.appVersionCell.textField.enablesReturnKeyAutomatically = YES;
    self.appVersionCell.textField.text = [R1Emitter sharedInstance].appVersion;
}

- (void) viewDidUnload
{
    self.appIdCell = nil;
    
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return 2;
            
        default:
            break;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"iTunes Connect application identifier:";

        case 1:
            return @"App version:";

        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return self.appIdCell;

    if (indexPath.row == 0)
        return self.appVersionCell;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResetCell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResetCell"] autorelease];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Reset";
    }        
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reset App Version?"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Reset", nil];
        
        alertView.tag = 100;
        
        [alertView show];
        [alertView release];
        return;
    }
}

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if (indexPath != nil)
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (alertView.cancelButtonIndex == buttonIndex)
            return;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        
        [userDefaults removeObjectForKey:@"r1EmitterLastApplicationVersion"];
        
        [userDefaults synchronize];
        
        self.appVersionCell.textField.text = @"";
        [R1Emitter sharedInstance].appVersion = nil;
        
        return;
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.appIdCell.textField)
    {
        [R1Emitter sharedInstance].appId = newText;

        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"r1EmitterDemoAppId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if (textField == self.appVersionCell.textField)
    {
        [R1Emitter sharedInstance].appVersion = newText;

        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"r1EmitterLastApplicationVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
