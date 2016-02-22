//
//  MailboxViewController.swift
//  Mailbox
//
//  Created by Marc Haumann on 2/20/16.
//  Copyright © 2016 Marc Haumann. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tabControl: UISegmentedControl!
    @IBOutlet weak var tabContainer: UIView!
    @IBOutlet weak var snoozedSectionView: UIView!
    @IBOutlet weak var archiveSectionView: UIView!
    @IBOutlet weak var viewsContainer: UIView!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var snoozeView: UIView!
    @IBOutlet weak var feedView: UIImageView!
    @IBOutlet weak var iconArchiveView: UIImageView!
    @IBOutlet weak var iconLaterView: UIImageView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    var screenEdgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var messageState: String!
    var blue: UIColor! = UIColor(red: 81/255, green: 185/255, blue: 219/255, alpha: 1)
    var green: UIColor! = UIColor(red: 99/255, green: 218/255, blue: 98/255, alpha: 1)
    var red: UIColor! = UIColor(red: 235/255, green: 84/255, blue: 51/255, alpha: 1)
    var yellow: UIColor! = UIColor(red: 250/255, green: 211/255, blue: 50/255, alpha: 1)
    var brown: UIColor! = UIColor(red: 216/255, green: 166/255, blue: 117/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 1276)
        snoozeView.alpha = 0
        listView.alpha = 0
        screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "moveMenu:")
        screenEdgeRecognizer.edges = .Left
        view.addGestureRecognizer(screenEdgeRecognizer)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        if event?.subtype == UIEventSubtype.MotionShake{
            UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
                self.feedView.transform = CGAffineTransformMakeTranslation(0, 84)
                self.messageContainer.frame.size.height = 84
                self.messageView.frame.origin.x = 0
                self.iconArchiveView.frame.origin.x = 19
                self.iconLaterView.frame.origin.x = 278
                }, completion: nil)
        }
    }
    
    func moveMenu(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        if sender.state == UIGestureRecognizerState.Began {
//            print("began")
        } else if sender.state == UIGestureRecognizerState.Changed {
            self.viewsContainer.frame.origin.x = translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
//            print(velocity)
            if velocity.x > 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: [], animations: { () -> Void in
                    self.viewsContainer.frame.origin.x = 290
                    }, completion: nil)
            } else if velocity.x < 0 {
                UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
                    self.viewsContainer.frame.origin.x = 0
                    }, completion: nil)
            }
        }
    }
    
    @IBAction func messageDidPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        messageView.frame.origin.x = translation.x
        
        if sender.state == UIGestureRecognizerState.Began {
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            iconArchiveView.alpha = convertValue(translation.x, r1Min: 0, r1Max: 60, r2Min: 0, r2Max: 1)
            iconLaterView.alpha = convertValue(translation.x, r1Min: 0, r1Max: -60, r2Min: 0, r2Max: 1)
            if 60 ... 240 ~= translation.x {
                messageContainer.backgroundColor = green
                iconArchiveView.image = UIImage(named: "archive_icon")
                iconArchiveView.frame.origin.x = translation.x - 40
                messageState = "archive"
            } else if -240 ... -60 ~= translation.x {
                messageContainer.backgroundColor = yellow
                iconLaterView.image = UIImage(named: "later_icon")
                iconLaterView.frame.origin.x = translation.x + 340
                messageState = "later"
            } else if translation.x > 240 {
                messageContainer.backgroundColor = red
                iconArchiveView.image = UIImage(named: "delete_icon")
                iconArchiveView.frame.origin.x = translation.x - 40
                messageState = "delete"
            } else if translation.x < -240 {
                messageContainer.backgroundColor = brown
                iconLaterView.image = UIImage(named: "list_icon")
                iconLaterView.frame.origin.x = translation.x + 340
                messageState = "list"
            } else {
                messageContainer.backgroundColor = UIColor.grayColor()
                messageState = "release"
            }
        } else if sender.state == UIGestureRecognizerState.Ended {
            switch messageState {
                case "archive": UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                        self.messageView.frame.origin.x = 320
                        self.iconArchiveView.frame.origin.x = 320-25-19
                    }, completion: {(Bool) -> Void in
                        self.collapseView()
                })
                case "later": UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                    self.messageView.frame.origin.x = -320
                    self.iconLaterView.frame.origin.x = 19
                    }, completion: {(Bool) -> Void in
                        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
                            self.snoozeView.alpha = 1
                            
                            }, completion: nil)
                })
                case "delete": UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                    self.messageView.frame.origin.x = 320
                    self.iconArchiveView.frame.origin.x = 320-25-19
                    }, completion: {(Bool) -> Void in
                        self.collapseView()
                })
            case "list": UIView.animateWithDuration(0.2, delay: 0, options: [], animations: { () -> Void in
                self.messageView.frame.origin.x = -320
                self.iconLaterView.frame.origin.x = 19
                }, completion: {(Bool) -> Void in
                    UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
                        self.listView.alpha = 1
                        
                        }, completion: nil)
            })
                default: UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                    }, completion: nil)
            }
        }
        
    }
    @IBAction func listDidTap(sender: AnyObject) {
        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
            self.listView.alpha = 0
            
            }, completion: {(Bool) -> Void in
                self.collapseView()
        })
    }
    @IBAction func snoozeDidTap(sender: AnyObject) {
        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
            self.snoozeView.alpha = 0
            
            }, completion: {(Bool) -> Void in
                self.collapseView()
        })
    }
    func collapseView() {
        UIView.animateWithDuration(0.4, delay: 0, options: [], animations: { () -> Void in
            self.iconArchiveView.alpha = 0
            self.iconLaterView.alpha = 0
            self.feedView.transform = CGAffineTransformMakeTranslation(0, -84)
            //                            self.messageContainer.transform = CGAffineTransformMakeTranslation(0, -42)
            self.messageContainer.frame.size.height = 0
            //                            self.messageContainer.transform = CGAffineTransformScale(self.messageContainer.transform, 1, 0.00000000001)
            }, completion: nil)
    }

    @IBAction func tabValueChanged(sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            self.tabControl.tintColor = yellow
            UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                self.tabContainer.transform = CGAffineTransformMakeTranslation(320, 0)
                }, completion: nil)
        } else if index == 1 {
            self.tabControl.tintColor = blue
            UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                self.tabContainer.transform = CGAffineTransformIdentity
                }, completion: nil)
        } else if index == 2 {
            self.tabControl.tintColor = green
            UIView.animateWithDuration(0.3, delay: 0, options: [], animations: { () -> Void in
                self.tabContainer.transform = CGAffineTransformMakeTranslation(-320, 0)
                }, completion: nil)
        }
    }
    @IBAction func menuDidTap(sender: AnyObject) {
        if self.viewsContainer.frame.origin.x == 0 {
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: [], animations: { () -> Void in
                self.viewsContainer.frame.origin.x = 290
                }, completion: nil)
        } else {
            UIView.animateWithDuration(0.2, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
                self.viewsContainer.frame.origin.x = 0
                }, completion: nil)
        }
    }
}
