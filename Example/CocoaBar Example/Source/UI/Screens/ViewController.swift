//
//  ViewController.swift
//  CocoaBar Example
//
//  Created by Merrick Sapsford on 23/05/2016.
//  Copyright © 2016 Merrick Sapsford. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CocoaBarDelegate {

    // MARK: Properties
    
    @IBOutlet weak var gradientView: GradientView?
    @IBOutlet weak var tableView: UITableView?
    
    var styles: [BarStyle] = []
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.gradientView?.colors = [UIColor.purpleColor(), UIColor(red: 29, green: 0, blue: 174)]
        
        self.styles.append(BarStyle(title: "Condensed Error",
            description: "Condensed Error Layout with extra light blur background",
            backgroundStyle: .BlurExtraLight,
            barStyle: .ErrorCondensed,
            duration: .Long))
        self.styles.append(BarStyle(title: "Expanded Error - Light",
            description: "Expanded Error layout with extra light blur background",
            backgroundStyle: .BlurExtraLight,
            barStyle: .ErrorExpanded,
            duration: .Long))
        self.styles.append(BarStyle(title: "Expanded Error - Dark",
            description: "Expanded Error Layout with dark blur background",
            backgroundStyle: .BlurDark,
            barStyle: .ErrorExpanded,
            duration: .Long))
        self.styles.append(BarStyle(title: "Custom Layout",
            description: "Custom CocoaBarLayout",
            backgroundStyle: .BlurDark,
            barStyle: .ErrorExpanded,
            duration: .Long))
        
        self.tableView?.rowHeight = UITableViewAutomaticDimension
        self.tableView?.estimatedRowHeight = 96.0
        self.tableView?.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        CocoaBar.keyCocoaBar?.delegate = self
    }

    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.styles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let barStyleCell = tableView.dequeueReusableCellWithIdentifier("BarStyleCell") as! BarStyleCell
        let style = self.styles[indexPath.row]
        
        barStyleCell.titleLabel?.text = style.title
        barStyleCell.descriptionLabel?.text = style.styleDescription
        
        // alternate row colours
        if indexPath.row % 2 != 0 {
            barStyleCell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.15)
        }
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
        barStyleCell.selectedBackgroundView = selectedBackgroundView
        
        return barStyleCell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let style = self.styles[indexPath.row]
        
        if let keyCocoaBar = CocoaBar.keyCocoaBar {
            if keyCocoaBar.isShowing {
                keyCocoaBar.delegate = nil // temporarily ignore cocoa bar delegate
                keyCocoaBar.hideAnimated(true, completion: { (animated, completed, visible) in
                    self.showBarWithStyle(style)
                    keyCocoaBar.delegate = self
                })
            } else {
                self.showBarWithStyle(style)
            }
        }
    }
    
    // MARK: CocoaBarDelegate
    
    func cocoaBar(cocoaBar: CocoaBar, didShowAnimated animated: Bool) {
        // did show bar
    }
    
    func cocoaBar(cocoaBar: CocoaBar, didHideAnimated animated: Bool) {
        if let indexPath = self.tableView?.indexPathForSelectedRow {
            self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func cocoaBar(cocoaBar: CocoaBar, actionButtonPressed actionButton: UIButton?) {
        // Do an action
    }
    
    // MARK: Private
    
    private func showBarWithStyle(style: BarStyle) {
        CocoaBar.showAnimated(true, duration: style.duration, style: style.barStyle, populate: { (layout) in
            layout.backgroundStyle = style.backgroundStyle
            
            }, completion: nil)
    }
}

