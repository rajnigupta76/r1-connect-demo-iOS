import UIKit

class ViewController: UIViewController, R1InboxMessagesDelegate, R1SampleInboxViewControllerDelegate {
    
    @IBOutlet weak var inboxButton: UIButton?

    func addInboxMessagesDelegate() {
        R1Inbox.sharedInstance().messages.addDelegate(self);
    }
    
    func inboxMessageUnreadCountChanged() {
        let btnTitle = String.init(format: "Inbox unread cound: %d", R1Inbox.sharedInstance().messages.unreadMessagesCount);
        
        inboxButton?.setTitle(btnTitle, forState: .Normal);
    }
    
    deinit {
        R1Inbox.sharedInstance().messages.removeDelegate(self);
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navController: UINavigationController = segue.destinationViewController as? UINavigationController {
            if let viewController: R1SampleInboxViewController = navController.viewControllers[0] as? R1SampleInboxViewController {
                viewController.inboxDelegate = self;
            }
        }
    }

    func sampleInboxViewControllerDidFinished(sampleInboxViewController: R1SampleInboxViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

