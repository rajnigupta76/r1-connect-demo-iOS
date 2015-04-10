#import "REEventLineItemCell.h"
#import "R1EmitterLineItem.h"

@implementation REEventLineItemCell

- (id) initCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    return self;
}

- (void) setLineItem:(R1EmitterLineItem *)lineItem
{
    _lineItem = lineItem;
    
    if (self.lineItem == nil)
        return;
    
    self.textLabel.text = [REEventLineItemCell textForLineItem:self.lineItem];
}

+ (NSString *) textForLineItem:(R1EmitterLineItem *) lineItem
{
    NSMutableString *str = [NSMutableString string];
    
    [str appendFormat:@"ProductID: %@", (lineItem.itemID != nil) ? lineItem.itemID : @"Empty"];
    
    if (lineItem.itemName != nil)
    {
        if ([str length] > 0)
            [str appendString:@"\n"];
        [str appendFormat:@"ProductName: %@", lineItem.itemName];
    }
    
    if (lineItem.quantity != 0)
    {
        if ([str length] > 0)
            [str appendString:@"\n"];
        
        [str appendFormat:@"Quantity: %@", [[NSNumber numberWithLong:lineItem.quantity] stringValue]];
    }
    
    if (lineItem.unitOfMeasure != nil)
    {
        if ([str length] > 0)
            [str appendString:@"\n"];
        
        [str appendFormat:@"UnitOfMeasure: %@", lineItem.unitOfMeasure];
    }
    
    
    if (lineItem.msrPrice != 0)
    {
        if ([str length] > 0)
            [str appendString:@"\n"];
        
        [str appendFormat:@"MsrPrice: %f", lineItem.msrPrice];
    }
    
    if (lineItem.pricePaid != 0)
    {
        if ([str length] > 0)
            [str appendString:@"\n"];
        
        [str appendFormat:@"PricePaid: %f", lineItem.pricePaid];
    }
    
    if (lineItem.currency != nil)
    {
        if ([str length] > 0)
            [str appendString:@"\n"];
        
        [str appendFormat:@"Currency: %@", lineItem.currency];
    }

    if (lineItem.itemCategory != nil)
    {
        if ([str length] > 0)
            [str appendString:@"\n"];
        
        [str appendFormat:@"Currency: %@", lineItem.itemCategory];
    }
    
    return str;
}

+ (CGFloat) heightForLineItem:(R1EmitterLineItem *) lineItem withWidth:(CGFloat) width
{
    NSString *text = [REEventLineItemCell textForLineItem:lineItem];

    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(width-72, FLT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    if (textSize.height < 44)
        return 44;
    return textSize.height;
}

@end
