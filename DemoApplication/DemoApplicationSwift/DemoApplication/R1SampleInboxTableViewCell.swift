import UIKit

class R1SampleInboxTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unreadMarkerView: UIView?
    @IBOutlet weak var alertLabel: UILabel?
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
    
    var dateFormatter: NSDateFormatter?
    
    func setInboxMessage(inboxMessage: R1InboxMessage) {
        unreadMarkerView?.hidden = !inboxMessage.unread;
        
        self.messageLabel?.text = inboxMessage.title;
        self.alertLabel?.text = inboxMessage.alert;
        self.dateLabel?.text = dateFormatter?.stringFromDate(inboxMessage.createdDate);
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateFormatter = NSDateFormatter?.init();
        dateFormatter?.dateStyle = .ShortStyle;
        dateFormatter?.timeStyle = .MediumStyle;
    }
    
    static func heightForCell(inboxMessage: R1InboxMessage, cellWidth: CGFloat) -> CGFloat {
        var height: CGFloat = 16+40;
        
        if (inboxMessage.alert != nil) {
            let paragraph : NSMutableParagraphStyle = NSMutableParagraphStyle.init();
            paragraph.lineBreakMode = .ByWordWrapping;
            
            height += inboxMessage.alert!._bridgeToObjectiveC().boundingRectWithSize(CGSize.init(width: cellWidth-16-15, height: 100), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFontOfSize(14), NSParagraphStyleAttributeName: paragraph], context: nil).size.height;
        }
        
        return height;
    }
}
