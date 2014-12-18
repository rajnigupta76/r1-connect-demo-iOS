#import "RESDKParametersViewController.h"
#import "RETextValueCell.h"
#import "R1Emitter.h"

@interface RESDKParametersViewController ()

@property (nonatomic, retain) RETextValueCell *emitterIdCell;
@property (nonatomic, retain) RETextValueCell *appUserIdCell;
@property (nonatomic, retain) RETextValueCell *appIdCell;
@property (nonatomic, retain) RETextValueCell *appVersionCell;

@end

@implementation RESDKParametersViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Parameters";
    }
    return self;
}

- (void) dealloc
{
    self.emitterIdCell = nil;
    self.appUserIdCell = nil;
    self.appIdCell = nil;
    self.appVersionCell = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.emitterIdCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"EmitterIdCell"] autorelease];
    self.emitterIdCell.textField.returnKeyType = UIReturnKeyDone;
    self.emitterIdCell.textField.placeholder = @"Emitter ID";
    self.emitterIdCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emitterIdCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.emitterIdCell.textField.delegate = (id)self;
    self.emitterIdCell.textField.enablesReturnKeyAutomatically = YES;
    self.emitterIdCell.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterDemoEmitterId"];

    self.appUserIdCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"AppUserIdCell"] autorelease];
    self.appUserIdCell.textField.returnKeyType = UIReturnKeyDone;
    self.appUserIdCell.textField.placeholder = @"App User ID";
    self.appUserIdCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.appUserIdCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.appUserIdCell.textField.delegate = (id)self;
    self.appUserIdCell.textField.enablesReturnKeyAutomatically = YES;
    self.appUserIdCell.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterDemoAppUserId"];
    
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
    self.emitterIdCell = nil;
    self.appIdCell = nil;
    self.appUserIdCell = nil;
    
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1;
        case 3:
            return 2;
        case 4:
            return 3;
            
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
            return @"Emitter ID:";
            
        case 1:
            return @"Application User ID:";
            
        case 2:
            return @"iTunes Connect application identifier:";

        case 3:
            return @"App version:";

        case 4:
            return @"Server:";

        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return self.emitterIdCell;

    if (indexPath.section == 1)
        return self.appUserIdCell;
    
    if (indexPath.section == 2)
        return self.appIdCell;

    if (indexPath.row == 0)
        return self.appVersionCell;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResetCell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResetCell"] autorelease];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Reset";
    }        
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3 && indexPath.row == 1)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reset App Version?"
                                                            message:@"It will emulate clear application install"
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
        
        [userDefaults removeObjectForKey:@"r1EmitterLastUsedServer"];
        [userDefaults removeObjectForKey:@"r1EmitterLastApplicationVersion"];
        
        [userDefaults synchronize];
        
        return;
    }
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.emitterIdCell.textField)
    {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"r1EmitterDemoEmitterId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (textField == self.appUserIdCell.textField)
    {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"r1EmitterDemoAppUserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (textField == self.appIdCell.textField)
    {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"r1EmitterDemoAppId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else if (textField == self.appVersionCell.textField)
    {
        [R1Emitter sharedInstance].appVersion = newText;
    }
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
