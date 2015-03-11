#import "REGeofencingViewController.h"
#import "R1SDK.h"
#import "RESwitchCell.h"

@implementation REGeofencingViewController

- (id) initViewController
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.navigationItem.title = @"Geofencing Options";
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Geofencing Enabled:";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RESwitchCell *switchCell = (RESwitchCell *)[tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
    if (switchCell == nil)
    {
        switchCell = [[[RESwitchCell alloc] initCellWithReuseIdentifier:@"SwitchCell"] autorelease];
        switchCell.textLabel.text = @"Geofencing Enabled";
        [switchCell.switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    }
    
    switchCell.switchView.on = [R1SDK sharedInstance].geofencingEnabled;
    
    return switchCell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void) switchChanged:(UISwitch *) switchView
{
    [R1SDK sharedInstance].geofencingEnabled = switchView.on;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:switchView.on forKey:@"r1EmitterDemoGeofencingEnabled"];
    [ud synchronize];
}

@end
