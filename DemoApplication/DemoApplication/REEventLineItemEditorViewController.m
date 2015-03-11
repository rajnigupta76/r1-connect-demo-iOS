#import "REEventLineItemEditorViewController.h"
#import "R1EmitterLineItem.h"
#import "REEventParameter.h"

#import "RETextValueCell.h"
#import "REEventParameterCell.h"

#import "REEventParameterEditorViewController.h"

@interface REEventLineItemEditorViewController ()

@property (nonatomic, assign) BOOL isNewItem;
@property (nonatomic, retain) R1EmitterLineItem *lineItem;

@property (nonatomic, retain) RETextValueCell *productIDCell;
@property (nonatomic, retain) RETextValueCell *productNameCell;
@property (nonatomic, retain) RETextValueCell *quantityCell;
@property (nonatomic, retain) RETextValueCell *unitOfMeasureCell;
@property (nonatomic, retain) RETextValueCell *msrPriceCell;
@property (nonatomic, retain) RETextValueCell *pricePaidCell;
@property (nonatomic, retain) RETextValueCell *currencyCell;
@property (nonatomic, retain) RETextValueCell *itemCategoryCell;

@end

@implementation REEventLineItemEditorViewController

- (id) initWithNewLineItem
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.isNewItem = YES;
        self.navigationItem.title = @"New LineItem";
        
        self.navigationItem.hidesBackButton = YES;
        [self configureNavigationItemsAnimated:NO];
    }
    return self;
}

- (id) initWithLineItem:(R1EmitterLineItem *) lineItem
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        self.isNewItem = NO;
        self.navigationItem.title = @"Exist LineItem";

        self.lineItem = lineItem;

        self.navigationItem.hidesBackButton = YES;
        [self configureNavigationItemsAnimated:NO];
    }
    return self;
}

- (void) dealloc
{
    self.lineItem = nil;
    
    self.productIDCell = nil;
    self.productNameCell = nil;
    self.quantityCell = nil;
    self.unitOfMeasureCell = nil;
    self.msrPriceCell = nil;
    self.pricePaidCell = nil;
    self.currencyCell = nil;
    self.itemCategoryCell = nil;
    
    [super dealloc];
}

- (void) configureNavigationItemsAnimated:(BOOL) animated
{
    if ([self inTextFieldEditing])
    {
        [self.navigationItem setLeftBarButtonItem:nil animated:animated];
        
        [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                                  target:self action:@selector(doneEditButtonPressed)] autorelease]  animated:animated];

        return;
    }
    
    [self.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                             target:self action:@selector(cancelButtonPressed)] autorelease]  animated:animated];
    
    [self.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                             target:self action:@selector(doneButtonPressed)] autorelease]  animated:animated];
}

- (void) cancelButtonPressed
{
    [self.delegate eventLineItemEditorViewControllerDidCancelled:self];
}

- (void) doneButtonPressed
{
    if ([self.productIDCell.textField.text length] == 0)
    {
        [self showErrorAlertView:@"Product ID is empty!"];
        return;
    }
    
    if (self.isNewItem)
        self.lineItem = [[[R1EmitterLineItem alloc] initWithItemID:self.productIDCell.textField.text] autorelease];
    
    self.lineItem.itemID = self.productIDCell.textField.text;
    self.lineItem.itemName = self.productNameCell.textField.text;
    self.lineItem.unitOfMeasure = self.unitOfMeasureCell.textField.text;
    self.lineItem.currency = self.currencyCell.textField.text;
    self.lineItem.itemCategory = self.itemCategoryCell.textField.text;
    
    NSScanner *scanner = nil;
    
    scanner = [NSScanner scannerWithString:self.quantityCell.textField.text];
    int quantityVal;
    if ([scanner scanInt:&quantityVal])
        self.lineItem.quantity = quantityVal;
    else
        self.lineItem.quantity = 0;

    scanner = [NSScanner scannerWithString:self.msrPriceCell.textField.text];
    double msrPriceVal;
    if ([scanner scanDouble:&msrPriceVal])
        self.lineItem.msrPrice = msrPriceVal;
    else
        self.lineItem.msrPrice = 0;
    
    scanner = [NSScanner scannerWithString:self.pricePaidCell.textField.text];
    double pricePaidVal;
    if ([scanner scanDouble:&pricePaidVal])
        self.lineItem.pricePaid = pricePaidVal;
    else
        self.lineItem.pricePaid = 0;
        
    [self.delegate eventLineItemEditorViewController:self didFinishedWithLineItem:self.lineItem];
}

- (void) doneEditButtonPressed
{
    if ([self.productIDCell.textField isFirstResponder])
        [self.productIDCell.textField resignFirstResponder];
    
    if ([self.productNameCell.textField isFirstResponder])
        [self.productNameCell.textField resignFirstResponder];

    if ([self.quantityCell.textField isFirstResponder])
        [self.quantityCell.textField resignFirstResponder];

    if ([self.unitOfMeasureCell.textField isFirstResponder])
        [self.unitOfMeasureCell.textField resignFirstResponder];

    if ([self.msrPriceCell.textField isFirstResponder])
        [self.msrPriceCell.textField resignFirstResponder];

    if ([self.pricePaidCell.textField isFirstResponder])
        [self.pricePaidCell.textField resignFirstResponder];
    
    if ([self.currencyCell.textField isFirstResponder])
        [self.currencyCell.textField resignFirstResponder];

    if ([self.itemCategoryCell.textField isFirstResponder])
        [self.itemCategoryCell.textField resignFirstResponder];
}

- (BOOL) inTextFieldEditing
{
    if ([self.productIDCell.textField isFirstResponder])
        return YES;
    if ([self.productNameCell.textField isFirstResponder])
        return YES;
    if ([self.quantityCell.textField isFirstResponder])
        return YES;
    if ([self.unitOfMeasureCell.textField isFirstResponder])
        return YES;
    if ([self.msrPriceCell.textField isFirstResponder])
        return YES;
    if ([self.pricePaidCell.textField isFirstResponder])
        return YES;
    if ([self.currencyCell.textField isFirstResponder])
        return YES;
    if ([self.itemCategoryCell.textField isFirstResponder])
        return YES;
    
    return NO;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.productIDCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"productIDCell"] autorelease];
    self.productIDCell.textLabel.text = self.productIDCell.textField.placeholder = @"Product ID";
    self.productIDCell.textField.returnKeyType = UIReturnKeyDone;
    self.productIDCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.productIDCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.productIDCell.textField.delegate = (id)self;
    self.productIDCell.textField.enablesReturnKeyAutomatically = YES;
    self.productIDCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.productIDCell.textField.text = (self.lineItem == nil) ? [REEventParameter randomString] : self.lineItem.itemID;
//    if (!self.isNewItem)
//        self.productIDCell.textField.userInteractionEnabled = NO;

    self.productNameCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"productNameCell"] autorelease];
    self.productNameCell.textLabel.text = self.productNameCell.textField.placeholder = @"Product Name";
    self.productNameCell.textField.returnKeyType = UIReturnKeyDone;
    self.productNameCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.productNameCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.productNameCell.textField.delegate = (id)self;
    self.productNameCell.textField.enablesReturnKeyAutomatically = YES;
    self.productNameCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.productNameCell.textField.text = (self.lineItem == nil) ? [REEventParameter randomString] : self.lineItem.itemName;
    
    self.quantityCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"quantityCell"] autorelease];
    self.quantityCell.textLabel.text = self.quantityCell.textField.placeholder = @"Quantity";
    self.quantityCell.textField.returnKeyType = UIReturnKeyDone;
    self.quantityCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.quantityCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.quantityCell.textField.delegate = (id)self;
    self.quantityCell.textField.enablesReturnKeyAutomatically = YES;
    self.quantityCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.quantityCell.textField.text = [[NSNumber numberWithLong:(self.lineItem == nil) ? arc4random() : self.lineItem.quantity] stringValue];
    
    self.unitOfMeasureCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"unitOfMeasureCell"] autorelease];
    self.unitOfMeasureCell.textLabel.text = self.unitOfMeasureCell.textField.placeholder = @"Unit Of Measure";
    self.unitOfMeasureCell.textField.returnKeyType = UIReturnKeyDone;
    self.unitOfMeasureCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.unitOfMeasureCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.unitOfMeasureCell.textField.delegate = (id)self;
    self.unitOfMeasureCell.textField.enablesReturnKeyAutomatically = YES;
    self.unitOfMeasureCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.unitOfMeasureCell.textField.text = (self.lineItem == nil) ? [REEventParameter randomString] : self.lineItem.unitOfMeasure;

    self.msrPriceCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"msrPriceCell"] autorelease];
    self.msrPriceCell.textLabel.text = self.msrPriceCell.textField.placeholder = @"Msr Price";
    self.msrPriceCell.textField.returnKeyType = UIReturnKeyDone;
    self.msrPriceCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.msrPriceCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.msrPriceCell.textField.delegate = (id)self;
    self.msrPriceCell.textField.enablesReturnKeyAutomatically = YES;
    self.msrPriceCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.msrPriceCell.textField.text = [NSString stringWithFormat:@"%f", (self.lineItem == nil) ? arc4random() : self.lineItem.msrPrice];
    
    self.pricePaidCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"msrPriceCell"] autorelease];
    self.pricePaidCell.textLabel.text = self.pricePaidCell.textField.placeholder = @"Price Paid";
    self.pricePaidCell.textField.returnKeyType = UIReturnKeyDone;
    self.pricePaidCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.pricePaidCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.pricePaidCell.textField.delegate = (id)self;
    self.pricePaidCell.textField.enablesReturnKeyAutomatically = YES;
    self.pricePaidCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
    self.pricePaidCell.textField.text = [NSString stringWithFormat:@"%f", (self.lineItem == nil) ? arc4random() : self.lineItem.pricePaid];
    
    self.currencyCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"currencyCell"] autorelease];
    self.currencyCell.textLabel.text = self.unitOfMeasureCell.textField.placeholder = @"Currency";
    self.currencyCell.textField.returnKeyType = UIReturnKeyDone;
    self.currencyCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.currencyCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.currencyCell.textField.delegate = (id)self;
    self.currencyCell.textField.enablesReturnKeyAutomatically = YES;
    self.currencyCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.currencyCell.textField.text = (self.lineItem == nil) ? [REEventParameter randomString] : self.lineItem.currency;
    
    self.itemCategoryCell = [[[RETextValueCell alloc] initLabelCellWithReuseIdentifier:@"itemCategoryCell"] autorelease];
    self.itemCategoryCell.textLabel.text = self.unitOfMeasureCell.textField.placeholder = @"ItemCategory";
    self.itemCategoryCell.textField.returnKeyType = UIReturnKeyDone;
    self.itemCategoryCell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.itemCategoryCell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.itemCategoryCell.textField.delegate = (id)self;
    self.itemCategoryCell.textField.enablesReturnKeyAutomatically = YES;
    self.itemCategoryCell.textField.keyboardType = UIKeyboardTypeDefault;
    self.itemCategoryCell.textField.text = (self.lineItem == nil) ? [REEventParameter randomString] : self.lineItem.itemCategory;

    self.tableView.editing = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
}

- (void) viewDidUnload
{
    self.productIDCell = nil;
    self.productNameCell = nil;
    self.quantityCell = nil;
    self.unitOfMeasureCell = nil;
    self.msrPriceCell = nil;
    self.pricePaidCell = nil;
    self.itemCategoryCell = nil;
    self.currencyCell = nil;
    
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"LineItem info:";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return self.productIDCell;
        case 1:
            return self.productNameCell;
        case 2:
            return self.quantityCell;
        case 3:
            return self.unitOfMeasureCell;
        case 4:
            return self.msrPriceCell;
        case 5:
            return self.pricePaidCell;
        case 6:
            return self.currencyCell;
        case 7:
            return self.itemCategoryCell;
            
        default:
            break;
    }
    
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellEditingStyle style = [self tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    
    return (style != UITableViewCellEditingStyleNone);
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL) tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self configureNavigationItemsAnimated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self configureNavigationItemsAnimated:YES];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];

    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

@end
