#import "REEventParametersViewController.h"
#import "RETextValueCell.h"
#import "REEventParameter.h"
#import "REEventParameterEditorViewController.h"
#import "REEventLineItemEditorViewController.h"
#import "R1EmitterLineItem.h"
#import "R1EmitterSocialPermission.h"
#import "REEventParameterCell.h"
#import "REEventLineItemCell.h"
#import "RESocialPermissionCell.h"
#import "RETestCase.h"

@interface REEventParametersViewController ()

@property (nonatomic, retain) RETextValueCell *eventNameCell;
@property (nonatomic, retain) NSMutableArray *parameters;
@property (nonatomic, retain) NSMutableArray *permissions;
@property (nonatomic, retain) R1EmitterLineItem *lineItem;

@end

@implementation REEventParametersViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"New Event";
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                               target:self action:@selector(cancelButtonPressed)] autorelease];

        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                                   style:UIBarButtonItemStyleDone
                                                                                  target:self action:@selector(doneButtonPressed)] autorelease];

        self.parameters = [NSMutableArray array];
        self.permissions = [NSMutableArray array];
    }
    return self;
}

- (id) initViewControllerWithTestCase:(RETestCase *) testCase
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        _testCase = [testCase retain];
        
        self.navigationItem.title = @"New Event";
        
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                               target:self action:@selector(cancelButtonPressed)] autorelease];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Send"
                                                                                   style:UIBarButtonItemStyleDone
                                                                                  target:self action:@selector(doneButtonPressed)] autorelease];
        
        self.parameters = [NSMutableArray array];
        self.permissions = [NSMutableArray array];
        
        self.hasParameters = [self.testCase hasParameters];
        self.predefinedEventName = [self.testCase predefinedEventName];
        self.predefinedEventParameters = [self.testCase predefinedEventParameters];
        self.hasLineItem = [self.testCase hasLineItem];
        self.hasPermissions = [self.testCase hasPermissions];
    }
    return self;
}

- (void) dealloc
{
    self.eventNameCell = nil;
    self.parameters = nil;
    self.permissions = nil;
    self.lineItem = nil;
    self.predefinedEventName = nil;
    self.predefinedEventParameters = nil;
    
    [_testCase release];
    
    [super dealloc];
}

- (void) setHasLineItem:(BOOL)hasLineItem
{
    if (_hasLineItem == hasLineItem)
        return;
    
    _hasLineItem = hasLineItem;
    
    if (_hasLineItem)
    {
        self.lineItem = [[[R1EmitterLineItem alloc] initWithProductID:[REEventParameter randomString]] autorelease];
    }else
    {
        self.lineItem = nil;
    }
}

- (void) cancelButtonPressed
{
    [self.delegate eventParametersViewControllerDidCancelled:self];
}

- (void) doneButtonPressed
{
    if ([self.eventNameCell.textField.text length] == 0)
    {
        [self showErrorAlertView:@"Event name is empty!"];
        return;
    }
    
    if (self.hasLineItem && self.lineItem.productID == nil)
    {
        [self showErrorAlertView:@"Line item product ID is empty!"];
        return;
    }
    
    NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *otherInfoDict = ([self.predefinedEventParameters count] > 0) ? [NSMutableDictionary dictionary] : nil;
    
    for (REEventParameter *eventParameter in self.parameters)
    {
        if ([eventParameter.key length] == 0 ||
            !eventParameter.isValueValid)
        {
            [self showErrorAlertView:@"One of parameters is invalid"];
            return;
        }

        if ([(otherInfoDict != nil ? otherInfoDict : paramsDict) objectForKey:eventParameter.key] != nil)
        {
            [self showErrorAlertView:@"Duplicate keys found in parameters"];
            return;
        }
    
        if (otherInfoDict != nil)
            [otherInfoDict setObject:eventParameter.value forKey:eventParameter.key];
        else
            [paramsDict setObject:eventParameter.value forKey:eventParameter.key];
    }
    
    if ([otherInfoDict count] != 0)
        [paramsDict setObject:otherInfoDict forKey:@"other_info"];
    
    for (REEventParameter *eventParameter in self.predefinedEventParameters)
    {
        if ([eventParameter.key length] == 0 ||
            !eventParameter.isValueValid)
        {
            continue;
        }

        [paramsDict setObject:eventParameter.value forKey:eventParameter.key];
    }
    
    if (self.lineItem != nil)
    {
        [paramsDict setObject:self.lineItem forKey:@"lineItem"];
    }
    
    NSMutableArray *permissionsArr = [NSMutableArray arrayWithCapacity:[self.permissions count]];
    for (RESocialPermissionCell *cell in self.permissions)
    {
        [permissionsArr addObject:cell.permission];
    }
    if ([permissionsArr count] > 0)
        [paramsDict setObject:permissionsArr forKey:@"permissions"];

    [self.delegate eventParametersViewController:self didFinishedWithEventName:self.eventNameCell.textField.text withParameters:paramsDict];

}

- (void) showErrorAlertView:(NSString *) error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.eventNameCell = [[[RETextValueCell alloc] initCellWithReuseIdentifier:@"EventNameCell"] autorelease];
    self.eventNameCell.textField.returnKeyType = UIReturnKeyDone;
    self.eventNameCell.textField.placeholder = @"Event Name";
    self.eventNameCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.eventNameCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.eventNameCell.textField.delegate = (id)self;
    self.eventNameCell.textField.enablesReturnKeyAutomatically = YES;
    
    if (self.predefinedEventName != nil)
    {
        self.eventNameCell.textField.text = self.predefinedEventName;
        self.eventNameCell.textField.userInteractionEnabled = NO;
    }
    
    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void) viewDidUnload
{
    self.eventNameCell = nil;
    
    [super viewDidUnload];
}

- (NSInteger) parametersSection
{
    if (!self.hasParameters)
        return -1;
    
    NSInteger section = 1;
    if ([self.predefinedEventParameters count] > 0)
        section ++;
    if (self.hasLineItem)
        section ++;
    if (self.hasPermissions)
        section ++;
    
    return section;
}

- (NSInteger) predefinedParametersSection
{
    if ([self.predefinedEventParameters count] == 0)
        return -1;

    return 1;
}

- (NSInteger) lineItemsSection
{
    if (!self.hasLineItem)
        return -1;

    if ([self.predefinedEventParameters count] > 0)
        return 2;
    
    return 1;
}

- (NSInteger) permissionsSection
{
    if (!self.hasPermissions)
        return -1;
    
    NSInteger section = 1;
    if ([self.predefinedEventParameters count] > 0)
        section ++;
    if (self.hasLineItem)
        section ++;
    return section;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSMutableArray *removedParameters = [NSMutableArray array];
    NSMutableArray *removedIndexPaths = [NSMutableArray array];
    
    NSUInteger index = 0;
    for (REEventParameter *eventParameter in self.parameters)
    {
        if ([eventParameter.key length] == 0 ||
            !eventParameter.isValueValid)
        {
            [removedIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:[self parametersSection]]];
            [removedParameters addObject:eventParameter];
        }
        
        index ++;
    }
    
    for (REEventParameter *eventParameter in removedParameters)
        [self.parameters removeObject:eventParameter];
    
    [self.tableView deleteRowsAtIndexPaths:removedIndexPaths withRowAnimation:UITableViewRowAnimationRight];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 1;
    
    if (self.hasParameters)
        sections ++;
    
    if ([self.predefinedEventParameters count] > 0)
        sections ++;
    
    if (self.hasLineItem)
        sections ++;
    
    if (self.hasPermissions)
        sections ++;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 1;
    
    if (section == [self predefinedParametersSection])
        return [self.predefinedEventParameters count];    
    
    if (section == [self lineItemsSection])
        return 1;
    
    if (section == [self permissionsSection])
        return [self.permissions count] + 1;
    
    return [self.parameters count] + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Event name:";
    
    if (section == 1)
    {
        if ([self.predefinedEventParameters count] > 0)
            return @"Event parameters:";
        if (self.hasLineItem)
            return @"Line item:";
        if (self.hasPermissions)
            return @"Permissions:";
        return @"Event parameters:";
    }
    
    if (section == 2)
    {
        if (self.hasLineItem)
            return @"Line items:";
        if (self.hasPermissions)
            return @"Permissions:";
    }
    
    if (section == 3)
    {
        if (self.hasPermissions)
            return @"Permissions:";
    }

    return @"Other info:";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self lineItemsSection])
    {
        return [REEventLineItemCell heightForLineItem:self.lineItem withWidth:self.tableView.frame.size.width];
    }
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView lineItemsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LineItemCell";
    REEventLineItemCell *cell = (REEventLineItemCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[REEventLineItemCell alloc] initCellWithReuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.lineItem = self.lineItem;
    
    return cell;

}

- (UITableViewCell *)tableView:(UITableView *)tableView predefinedParametersCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ParameterCell";
    REEventParameterCell *cell = (REEventParameterCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[REEventParameterCell alloc] initCellWithReuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.eventParameter = [self.predefinedEventParameters objectAtIndex:indexPath.row];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView parametersCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.parameters count])
    {
        static NSString *CellIdentifier = @"InsertCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"Insert Parameter";
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"ParameterCell";
    REEventParameterCell *cell = (REEventParameterCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[REEventParameterCell alloc] initCellWithReuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.eventParameter = [self.parameters objectAtIndex:indexPath.row];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView permissonsCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.permissions count])
    {
        static NSString *CellIdentifier = @"InsertCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = @"Insert Permission";
        
        return cell;
    }
    
    return [self.permissions objectAtIndex:indexPath.row];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return self.eventNameCell;
    
    if (indexPath.section == [self predefinedParametersSection])
        return [self tableView:tableView predefinedParametersCellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == [self lineItemsSection])
        return [self tableView:tableView lineItemsCellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == [self permissionsSection])
        return [self tableView:tableView permissonsCellForRowAtIndexPath:indexPath];

    return [self tableView:tableView parametersCellForRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    
    return (style != UITableViewCellEditingStyleNone);
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        if (indexPath.section == [self permissionsSection])
        {
            [self.permissions removeObjectAtIndex:indexPath.row];
        }else
        {
            [self.parameters removeObjectAtIndex:indexPath.row];
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return UITableViewCellEditingStyleNone;
    
    if (indexPath.section == [self predefinedParametersSection])
        return UITableViewCellEditingStyleNone;
    
    if (indexPath.section == [self lineItemsSection])
        return UITableViewCellEditingStyleNone;
    
    if (indexPath.section == [self permissionsSection])
    {
        if (indexPath.row != [self.permissions count])
            return UITableViewCellEditingStyleDelete;
        
        return UITableViewCellEditingStyleInsert;
    }

    if (indexPath.row != [self.parameters count])
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleInsert;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    if (indexPath.section == [self lineItemsSection])
    {
        REEventLineItemEditorViewController *editorViewController = [[REEventLineItemEditorViewController alloc] initWithLineItem:self.lineItem];
        
        editorViewController.delegate = (id)self;
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:editorViewController];
        
        [self presentModalViewController:navController animated:YES];
        
        [navController release];
        
        [editorViewController release];
        
        return;
    }
    
    if (indexPath.section == [self permissionsSection])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

        if (indexPath.row == [self.permissions count])
        {
            // Insert Value
            RESocialPermissionCell *cell = [[RESocialPermissionCell alloc] initCellWithReuseIdentifier:@"PermissionCell"];
            cell.permission = [R1EmitterSocialPermission socialPermissionWithName:@"" granted:YES];
            [self.permissions addObject:cell];
            [cell release];
            
            [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:[self.permissions count]-1 inSection:indexPath.section] ]
                                  withRowAnimation:UITableViewRowAnimationLeft];
        }
        
        return;
    }
    
    REEventParameter *eventParameter = nil;
    
    if (indexPath.section == [self predefinedParametersSection])
    {
        eventParameter = [self.predefinedEventParameters objectAtIndex:indexPath.row];
    }else
    {
        if (indexPath.row == [self.parameters count])
        {
            // Insert Value
            eventParameter = [[REEventParameter alloc] init];
            eventParameter.type = REEventParameterTypeString;
            [self.parameters addObject:eventParameter];
            [self.tableView insertRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:[self.parameters count]-1 inSection:[self parametersSection]] ]
                                  withRowAnimation:UITableViewRowAnimationLeft];
            
            [eventParameter release];
        }else
        {
            eventParameter = [self.parameters objectAtIndex:indexPath.row];
        }
    }
    
    [self editParameter:eventParameter];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) editParameter:(REEventParameter *) eventParameter
{
    REEventParameterEditorViewController *editorViewController = [[REEventParameterEditorViewController alloc] initWithEventParameter:eventParameter];
    
    [self.navigationController pushViewController:editorViewController animated:YES];
    
    [editorViewController release];
}

- (void) eventLineItemEditorViewControllerDidCancelled:(REEventLineItemEditorViewController *) eventLineItemEditorViewController
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) eventLineItemEditorViewController:(REEventLineItemEditorViewController *) eventLineItemEditorViewController didFinishedWithLineItem:(R1EmitterLineItem *) lineItem
{
    [self.tableView reloadData];
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
