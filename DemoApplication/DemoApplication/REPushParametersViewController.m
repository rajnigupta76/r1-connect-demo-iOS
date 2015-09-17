#import "REPushParametersViewController.h"
#import "RESwitchCell.h"
#import "R1Push.h"

@implementation REPushParametersViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Push Options";
    }
    return self;
}

- (void) closeButtonPressed
{
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.navigationController.viewControllers indexOfObject:self] == 0)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                                 style:UIBarButtonItemStyleBordered
                                                                                target:self action:@selector(closeButtonPressed)];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
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
            return [[R1Push sharedInstance].tags.tags count]+1;
            
        default:
            break;
    }
    return 0;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 2:
            return @"Tags:";
            
        default:
            break;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"EnablePushCell";
        RESwitchCell *cell = (RESwitchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[RESwitchCell alloc] initCellWithReuseIdentifier:CellIdentifier];
            [cell.switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
        cell.textLabel.text = @"Push Enabled";
        cell.switchView.on = [R1Push sharedInstance].pushEnabled;
        
        return cell;
    }
    
        
    if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        cell.textLabel.text = @"Badge Number";
        
        return cell;
    }
    
    if (indexPath.row == [[R1Push sharedInstance].tags.tags count])
    {
        static NSString *CellIdentifier = @"InsertTagCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.textLabel.text = @"Add Tag";
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [[R1Push sharedInstance].tags.tags objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView editingStyleForRowAtIndexPath:indexPath] != UITableViewCellEditingStyleNone;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if (indexPath.row == [[R1Push sharedInstance].tags.tags count])
            return UITableViewCellEditingStyleInsert;
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *tag = [[R1Push sharedInstance].tags.tags objectAtIndex:indexPath.row];

        [[R1Push sharedInstance].tags removeTag:tag];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self addNewTag];
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    if (indexPath.section == 1)
    {
        UIAlertView *badgeAlertView = [[UIAlertView alloc] initWithTitle:@"Enter badge number"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"Cancel"
                                                       otherButtonTitles:@"Set", nil];
        
        [badgeAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        
        UITextField *textField = [badgeAlertView textFieldAtIndex:0];
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.text = [NSString stringWithFormat:@"%lu", (unsigned long)[R1Push sharedInstance].badgeNumber];
        
        [badgeAlertView show];
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        return;
    }
    
    if (indexPath.section == 2)
    {
        if (indexPath.row == [[R1Push sharedInstance].tags.tags count])
        {
            [self addNewTag];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            return;
        }
        
        [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}

- (void) switchChanged:(UISwitch *) switchView
{
    [R1Push sharedInstance].pushEnabled = switchView.on;
}

- (void) addNewTag
{
    UIAlertView *addAlertView = [[UIAlertView alloc] initWithTitle:@"Enter tag:"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Add", nil];
    
    addAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    addAlertView.tag = 100;
    
    UITextField *textField = [addAlertView textFieldAtIndex:0];
    textField.placeholder = @"Tag";
    
    [addAlertView show];
}

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
        return;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (alertView.tag == 100)
    {
        if ([textField.text length] == 0)
        {
            [self addNewTag];
            return;
        }
        
        [[R1Push sharedInstance].tags addTag:textField.text];
        
        [self.tableView reloadData];
    }else
    {
        NSInteger badge;
        NSScanner *scanner = [NSScanner scannerWithString:textField.text];
        
        if (![scanner scanInteger:&badge])
            return;
        
        [[R1Push sharedInstance] setBadgeNumber:badge];
    }
}

- (BOOL) alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    if (alertView.tag == 100)
        return ([textField.text length] > 0);
    
    NSInteger badge;
    NSScanner *scanner = [NSScanner scannerWithString:textField.text];
    
    if ([scanner scanInteger:&badge])
        return YES;
    return NO;
}


@end
