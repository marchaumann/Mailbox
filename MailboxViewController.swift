//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Marc Haumann on 2/20/16.
//  Copyright © 2016 Marc Haumann. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var iconArchiveView: UIImageView!
    @IBOutlet weak var iconLaterView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var inboxView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var messageState: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1202)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func messageDidPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        messageView.frame.origin.x = translation.x
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            iconArchiveView.alpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
            iconLaterView.alpha = convertValue(translation.x, r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
            if 60 ... 240 ~= translation.x {
                messageContainer.backgroundColor = UIColor.greenColor()
                iconArchiveView.image = UIImage(named: "archive_icon")
                iconArchiveView.frame.origin.x = translation.x - 40
                messageState = "archive"
            }
            else if -240 ... -60 ~= translation.x {
                messageContainer.backgroundColor = UIColor.yellowColor()
                iconLaterView.image = UIImage(named: "later_icon")
                iconLaterView.frame.origin.x = translation.x + 340
                messageState = "later"
            }
            else if translation.x > 240 {
                messageContainer.backgroundColor = UIColor.redColor()
                iconArchiveView.image = UIImage(named: "delete_icon")
                iconArchiveView.frame.origin.x = translation.x - 40
                messageState = "delete"
            }
            else if translation.x < -240 {
                messageContainer.backgroundColor = UIColor.brownColor()
                iconLaterView.image = UIImage(named: "list_icon")
                iconLaterView.frame.origin.x = translation.x + 340
                messageState = "list"
            }
            else {
                messageContainer.backgroundColor = UIColor.grayColor()
                messageState = "release"
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            switch messageState {
                case "archive": UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                        self.messageView.frame.origin.x = 320
                        self.iconArchiveView.frame.origin.x = 320-25-19
                    }, completion: {(Bool) -> Void in
                        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
                            self.feedView.transform = CGAffineTransformMakeTranslation(0, -84)
                            self.messageContainer.transform = CGAffineTransformMakeTranslation(0, -42)
                            self.messageContainer.transform = CGAffineTransformScale(self.messageContainer.transform, 1, 0.00000000001)
                            }, completion: nil)
                })
                case "later": UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                    self.messageView.frame.origin.x = -320
                    }, completion: nil)
                case "delete": UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.messageView.frame.origin.x = 320
                    self.iconArchiveView.frame.origin.x = 320-25-19
                    }, completion: {(Bool) -> Void in
                        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
                            self.feedView.transform = CGAffineTransformMakeTranslation(0, -84)
                            self.messageContainer.transform = CGAffineTransformMakeTranslation(0, -42)
                            self.messageContainer.transform = CGAffineTransformScale(self.messageContainer.transform, 1, 0.00000000001)

                            }, completion: nil)
                })
            case "list": UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                self.messageView.frame.origin.x = -320
                }, completion: nil)
                default: UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                    }, completion: nil)
            }
        }
        
    }

}
