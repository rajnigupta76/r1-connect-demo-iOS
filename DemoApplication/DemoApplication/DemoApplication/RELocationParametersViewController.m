#import "RELocationParametersViewController.h"
#import "R1SDK.h"
#import "RESwitchCell.h"
#import "R1LocationService.h"

@interface RELocationParametersViewController ()

@property (nonatomic, strong) R1LocationService *locationService;
@property (nonatomic, assign) BOOL hasObservers;

@end

@implementation RELocationParametersViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Location Service Options";
        
        self.locationService = [R1SDK sharedInstance].locationService;
    }
    return self;
}

- (void) dealloc
{
    [self removeObservers];

    self.locationService = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addObservers];
}

- (void) viewDidUnload
{
    [self removeObservers];
    
    [super viewDidUnload];
}

- (void) addObservers
{
    if (self.hasObservers)
        return;
    
    self.hasObservers = YES;
    
    [self.locationService addObserver:self forKeyPath:@"enabled" options:0 context:nil];
    [self.locationService addObserver:self forKeyPath:@"lastLocation" options:0 context:nil];
    [self.locationService addObserver:self forKeyPath:@"state" options:0 context:nil];
    [self.locationService addObserver:self forKeyPath:@"locationServiceEnabled" options:0 context:nil];
    [self.locationService addObserver:self forKeyPath:@"locationServiceAuthorizationStatus" options:0 context:nil];
}

- (void) removeObservers
{
    if (!self.hasObservers)
        return;
    
    self.hasObservers = NO;

    [self.locationService removeObserver:self forKeyPath:@"enabled" context:nil];
    [self.locationService removeObserver:self forKeyPath:@"lastLocation" context:nil];
    [self.locationService removeObserver:self forKeyPath:@"state" context:nil];
    [self.locationService removeObserver:self forKeyPath:@"locationServiceEnabled" context:nil];
    [self.locationService removeObserver:self forKeyPath:@"locationServiceAuthorizationStatus" context:nil];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.locationService)
    {
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!self.locationService.enabled)
        return 2;
    
    NSUInteger sections = 2;
    
    if (self.locationService.state == R1LocationServiceStateWaitNextUpdate)
        sections ++;
    
    if (self.locationService.lastLocation != nil)
        sections ++;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return 2;

    if (section == 1)
        return 3;
    
    if (section == 2 && self.locationService.state == R1LocationServiceStateWaitNextUpdate)
        return 1;
    
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2 && self.locationService.state != R1LocationServiceStateWaitNextUpdate)
        return @"Location:";
    
    if (section == 3)
        return @"Last Location:";
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"EnableLocationCell";
            RESwitchCell *cell = (RESwitchCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[RESwitchCell alloc] initCellWithReuseIdentifier:CellIdentifier];
                [cell.switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            }
            
            cell.textLabel.text = @"Location Enabled";
            cell.switchView.on = self.locationService.enabled;
            
            return cell;
        }
        
        static NSString *CellIdentifier = @"Button1Cell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = @"Change AutoUpdate Interval";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.0f", [[R1SDK sharedInstance].locationService autoupdateTimeout]];
        
        return cell;

    }
    
    if (indexPath.section == 2 && self.locationService.state == R1LocationServiceStateWaitNextUpdate)
    {
        static NSString *CellIdentifier = @"ButtonCell";
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryNone;

            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        cell.textLabel.text = @"Update Now";
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"InfoCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"State";
                cell.detailTextLabel.text = [self stringFromState:self.locationService.state];
                break;
            case 1:
                cell.textLabel.text = @"Service Enabled";
                cell.detailTextLabel.text = self.locationService.locationServiceEnabled ? @"YES" : @"NO";
                break;
            case 2:
                cell.textLabel.text = @"Authorization Status";
                cell.detailTextLabel.text = [self stringFromAuthorizationStatus:self.locationService.locationServiceAuthorizationStatus];
                break;
                
            default:
                break;
        }
    } else
    {
        switch (indexPath.row)
        {
            case 0:
                cell.textLabel.text = @"Latitude";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", self.locationService.lastLocation.coordinate.latitude];
                break;
            case 1:
                cell.textLabel.text = @"Longitude";
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%f", self.locationService.lastLocation.coordinate.longitude];
                break;
                
            default:
                break;
        }
    }
    
    return cell;
}

- (NSString *) stringFromState:(R1LocationServiceState) state
{
    switch (state)
    {
        case R1LocationServiceStateDisabled:
            return @"Disabled";
        case R1LocationServiceStateOff:
            return @"Off";
        case R1LocationServiceStateSearching:
            return @"Searching";
        case R1LocationServiceStateHasLocation:
            return @"Has Location";
        case R1LocationServiceStateWaitNextUpdate:
            return @"Wait Next Update";
            
        default:
            break;
    }
    
    return nil;
}

- (NSString *) stringFromAuthorizationStatus:(CLAuthorizationStatus) status
{
    switch (status)
    {
        case kCLAuthorizationStatusNotDetermined:
            return @"Not Determined";
        case kCLAuthorizationStatusRestricted:
            return @"Restricted";
        case kCLAuthorizationStatusDenied:
            return @"Denied";
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return @"Authorized";
            
        default:
            break;
    }
    
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2 && self.locationService.state == R1LocationServiceStateWaitNextUpdate)
    {
        [self.locationService updateNow];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        [self changeAutoUpdateInterval];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) switchChanged:(UISwitch *) switchView
{
    self.locationService.enabled = switchView.on;
    
    [self.tableView reloadData];
}

- (void) changeAutoUpdateInterval
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Change AutoUpdate Interval"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"Change", nil];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    textField.placeholder = @"Interval";
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.text = [NSString stringWithFormat:@"%0.0f", [[R1SDK sharedInstance].locationService autoupdateTimeout]];
    
    [alertView show];
}

- (void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex)
        return;
    
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    double timeout = 0;
    NSScanner *scanner = [NSScanner scannerWithString:textField.text];
    
    [scanner scanDouble:&timeout];
    
    if (timeout == 0)
        return;
    
    [[R1SDK sharedInstance].locationService setAutoupdateTimeout:timeout];
    [self.tableView reloadData];
}

- (BOOL) alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *textField = [alertView textFieldAtIndex:0];
    
    double timeout = 0;
    NSScanner *scanner = [NSScanner scannerWithString:textField.text];
    
    [scanner scanDouble:&timeout];
    
    if (timeout == 0)
        return NO;
    
    return YES;
}

@end
