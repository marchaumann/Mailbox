//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Marc Haumann on 2/20/16.
//  Copyright © 2016 Marc Haumann. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var iconArchiveView: UIImageView!
    @IBOutlet weak var iconLaterView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var inboxView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var initialAlpha: CGFloat! = 0

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
        self.messageView.frame.origin.x = translation.x
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            iconArchiveView.alpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: initialAlpha, r2Max: 1)
            iconLaterView.alpha = convertValue(translation.x, r1Min: 0, r1Max: -60, r2Min: initialAlpha, r2Max: 1)
            if 60 ... 250 ~= translation.x {
                self.messageContainer.backgroundColor = UIColor.greenColor()
                iconArchiveView.image = UIImage(named: "archive_icon")
            }
            else if -250 ... -60 ~= translation.x {
                self.messageContainer.backgroundColor = UIColor.yellowColor()
                iconLaterView.image = UIImage(named: "later_icon")
            }
            else if translation.x > 250 {
                self.messageContainer.backgroundColor = UIColor.redColor()
                iconArchiveView.image = UIImage(named: "delete_icon")
            }
            else if translation.x < -250 {
                self.messageContainer.backgroundColor = UIColor.brownColor()
                iconLaterView.image = UIImage(named: "list_icon")
            }
            else {
                self.messageContainer.backgroundColor = UIColor.grayColor()
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            
        }
        
    }

}
