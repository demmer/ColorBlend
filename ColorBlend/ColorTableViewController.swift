//
//  ColorTableViewController.swift
//  ColorBlend
//
//  Created by Michael Demmer on 7/14/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import UIKit

extension UIImage {
    class func coloredSquare(color: UIColor, size: CGFloat) -> UIImage {
        let rect = CGRectMake(0.0, 0.0, size, size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

class ColorTableViewController: UITableViewController {
    var selectedColor: String?
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ColorName.ColorNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let spec = ColorName.ColorNames[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(spec.name)
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: spec.name);
            cell!.textLabel!.text = spec.name
            let color = UIColor(red: spec.red, green: spec.green, blue: spec.blue, alpha: 1)
            cell!.imageView!.image = UIImage.coloredSquare(color, size: 30.0)
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.row)")
        selectedColor = ColorName.ColorNames[indexPath.row].name
        self.performSegueWithIdentifier("ColorSelectionCompleteSegue", sender: self);
    }
    
    
}
