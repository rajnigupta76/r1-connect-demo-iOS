import UIKit

protocol R1SampleInboxViewControllerDelegate {
    func sampleInboxViewControllerDidFinished(sampleInboxViewController: R1SampleInboxViewController);
}

class R1SampleInboxViewController: UITableViewController, R1InboxMessagesDelegate {
    
    var inboxMessages: R1InboxMessages?
    var inboxDelegate: R1SampleInboxViewControllerDelegate?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        inboxMessages = R1Inbox.sharedInstance().messages;
        
        updateTitle();
    }
    
    func updateTitle() {
        if (inboxMessages?.unreadMessagesCount == 0) {
            navigationItem.title = "Inbox";
        } else {
            navigationItem.title = String.init(format: "Inbox (%lu unread)", (inboxMessages?.unreadMessagesCount)!);
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        updateTitle();
        inboxMessages?.addDelegate(self);
    }
    
    override func viewDidDisappear(animated: Bool) {
        inboxMessages?.removeDelegate(self);
    }
    
    @IBAction func closeButtonPressed(sender: UIBarButtonItem) {
        inboxDelegate?.sampleInboxViewControllerDidFinished(self);
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int((inboxMessages?.messagesCount)!);
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
        
        return R1SampleInboxTableViewCell.heightForCell(message, cellWidth: tableView.frame.size.width)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! R1SampleInboxTableViewCell;
        
        let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
        
        cell.setInboxMessage(message);

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
            
            inboxMessages?.deleteMessage(message);
        }
    }
    
    // MARK: - Table view delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let message : R1InboxMessage = (inboxMessages?.messages[indexPath.row])! as! R1InboxMessage;
        
        R1Inbox.sharedInstance().showMessage(message) { () -> Void in
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    // MARK: - R1InboxMessagesDelegate
    
    func inboxMessagesWillChanged() {
        tableView.beginUpdates()
    }
    
    func inboxMessagesDidChangeMessage(inboxMessage: R1InboxMessage!, atIndex index: UInt, forChangeType changeType: UInt, newIndex: UInt) {
        if (changeType == UInt(R1InboxMessagesChangeInsert)) {
            tableView.insertRowsAtIndexPaths([ NSIndexPath.init(forRow: Int(index), inSection: 0)], withRowAnimation: .Automatic);
        } else if (changeType == UInt(R1InboxMessagesChangeDelete)) {
            tableView.deleteRowsAtIndexPaths([ NSIndexPath.init(forRow: Int(index), inSection: 0)], withRowAnimation: .Automatic);
        } else if (changeType == UInt(R1InboxMessagesChangeUpdate)) {
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath.init(forRow: Int(index), inSection: 0)) as! R1SampleInboxTableViewCell;
            let message : R1InboxMessage = (inboxMessages?.messages[Int(index)])! as! R1InboxMessage;
            
            cell.setInboxMessage(message);
        }
    }
    
    func inboxMessagesDidChanged() {
        tableView.endUpdates()
    }
    
    func inboxMessageUnreadCountChanged() {
        updateTitle()
    }
}
