//
//  REInitialViewController.m
//  R1EmitterDemo
//
//  Created by Alexey Goliatin on 14.01.13.
//  Copyright (c) 2013 Home. All rights reserved.
//

#import "REInitialViewController.h"
#import "RETextValueCell.h"
#import "R1SDK.h"
#import "R1Emitter.h"
#import "R1Push.h"

#import "RESharedParametersViewController.h"
#import "REEmitterParametersViewController.h"
#import "REPushParametersViewController.h"
#import "REGeofencingViewController.h"
#import "REEmitterViewController.h"

@interface REInitialViewController ()

@property (nonatomic, retain) RETextValueCell *applicationIdCell;
@property (nonatomic, retain) RETextValueCell *applicationKeyCell;

@end

@implementation REInitialViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
#ifdef USE_PROD_SERVER
        self.navigationItem.title = @"R1 Connect (Prod)";
#else
        self.navigationItem.title = @"R1 Connect (Test)";
#endif
    }
    return self;
}

- (void) dealloc
{
    self.applicationIdCell = nil;
    self.applicationKeyCell = nil;
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.applicationIdCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"ApplicationIdCell"] autorelease];
    self.applicationIdCell.textField.returnKeyType = UIReturnKeyDone;
    self.applicationIdCell.textField.placeholder = @"Application ID";
    self.applicationIdCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.applicationIdCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.applicationIdCell.textField.delegate = (id)self;
    self.applicationIdCell.textField.enablesReturnKeyAutomatically = NO;
    self.applicationIdCell.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterDemoApplicationId"];
    
    self.applicationKeyCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"ApplicationKeyCell"] autorelease];
    self.applicationKeyCell.textField.returnKeyType = UIReturnKeyDone;
    self.applicationKeyCell.textField.placeholder = @"Client Key";
    self.applicationKeyCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.applicationKeyCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.applicationKeyCell.textField.delegate = (id)self;
    self.applicationKeyCell.textField.enablesReturnKeyAutomatically = NO;
    self.applicationKeyCell.textField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterDemoApplicationKey"];
}

- (void) viewDidUnload
{
    self.applicationIdCell = nil;
    self.applicationKeyCell = nil;
    
    [super viewDidUnload];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (!sdk.emitter.isStarted && !sdk.push.isStarted)
        return 3;
    
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (!sdk.emitter.isStarted && !sdk.push.isStarted)
    {
        switch (section)
        {
            case 0:
                return @"Application ID:";
            case 1:
                return @"Client Key (only for push):";
                
            default:
                break;
        }
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (sdk.emitter.isStarted || sdk.push.isStarted)
    {
        if (section == 0)
            return 50;
        
        return 10;
    }
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (sdk.emitter.isStarted || sdk.push.isStarted)
    {
        if (section == 0)
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width-20, 40)];
            label.backgroundColor = [UIColor clearColor];
            label.text = @"Restart application to change parameters.\n(Remove the app from the mutitasking bar)";
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor grayColor];
            
            [headerView addSubview:label];
            
            [label release];
            
            return [headerView autorelease];
        }
    }

    return nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (!sdk.emitter.isStarted && !sdk.push.isStarted)
        return 1;
    
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return sdk.emitter.isStarted ? 2 : 0;
        case 2:
            return sdk.push.isStarted ? 1 : 0;
        case 3:
            return 1;
            
        default:
            break;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (!sdk.emitter.isStarted && !sdk.push.isStarted)
    {
        if (indexPath.section == 0)
            return self.applicationIdCell;
        if (indexPath.section == 1)
            return self.applicationKeyCell;
        if (indexPath.section == 2)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartCell"];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StartCell"] autorelease];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            cell.textLabel.text = @"Start";
            cell.textLabel.textColor = [UIColor blueColor];
            
            return cell;
        }
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StartCell"] autorelease];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.section)
    {
        case 0:
            cell.textLabel.text = @"Shared Options";
            break;
        case 1:
            if (indexPath.row == 0)
                cell.textLabel.text = @"Emitter Options";
            else
                cell.textLabel.text = @"Emitter Methods";
            break;
        case 2:
            cell.textLabel.text = @"Push Options";
            break;
        case 3:
            cell.textLabel.text = @"Geofencing Options";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    if (!sdk.emitter.isStarted && !sdk.push.isStarted)
    {
        if (indexPath.section == 0 || indexPath.section == 1)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        [self startSDKs];
        
        [self.tableView reloadData];
        
        return;
    }
    
    UIViewController *viewController = nil;
    
    switch (indexPath.section)
    {
        case 0:
            viewController = [[RESharedParametersViewController alloc] initViewController];
            break;
        case 1:
            if (indexPath.row == 0)
            {
                viewController = [[REEmitterParametersViewController alloc] initViewController];
            }else
            {
                viewController = [[REEmitterViewController alloc] initViewController];
            }
            break;
        case 2:
            viewController = [[REPushParametersViewController alloc] initViewController];
            break;
        case 3:
            viewController = [[REGeofencingViewController alloc] initViewController];
            break;
            
        default:
            break;
    }
    
    if (viewController != nil)
    {
        [self.navigationController pushViewController:viewController animated:YES];
        [viewController release];
    }

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) startSDKs
{
    R1SDK *sdk = [R1SDK sharedInstance];
    
    NSString *applicationId = self.applicationIdCell.textField.text;
    if ([applicationId length] > 0)
        sdk.applicationId = applicationId;
    
    NSString *applicationKey = self.applicationKeyCell.textField.text;
    if ([applicationKey length] > 0)
        sdk.clientKey = applicationKey;

    [R1Emitter sharedInstance].appVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterLastApplicationVersion"];
    [R1Emitter sharedInstance].appId = [[NSUserDefaults standardUserDefaults] objectForKey:@"r1EmitterDemoAppId"];
    sdk.disableAllAdvertisingIds = [[NSUserDefaults standardUserDefaults] boolForKey:@"r1EmitterDemoDisableAllAdvertisingIds"];

    sdk.geofencingEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"r1EmitterDemoGeofencingEnabled"];

    [sdk start];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (textField == self.applicationIdCell.textField)
    {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"r1EmitterDemoApplicationId"];
    }else if (textField == self.applicationKeyCell.textField)
    {
        [[NSUserDefaults standardUserDefaults] setObject:newText forKey:@"r1EmitterDemoApplicationKey"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
