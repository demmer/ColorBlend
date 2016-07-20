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

class ColorTableViewController: UITableViewController, UISearchResultsUpdating {
    var selectedColor: String?
    var allColors: [ColorName] = [];
    var colors: [ColorName] = [];
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let search = searchController.searchBar.text!.lowercaseString
        colors = allColors.filter { color in
            return search == "" || color.name.lowercaseString.containsString(search)
        }
        
        tableView.reloadData()
    }
    
    func initColors() {
        allColors = ColorName.ColorNames.sort({ (a: ColorName, b: ColorName) -> Bool in
            var h: CGFloat = 0
            var h2: CGFloat = 0
            var s: CGFloat = 0
            var s2: CGFloat = 0
            var v: CGFloat = 0
            var v2: CGFloat = 0	
            
            a.color.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
            b.color.getHue(&h2, saturation: &s2, brightness: &v2, alpha: nil)
            
            return h < h2 || (h == h2 && v < v2) || (h == h2 && v == v2 && s < s2)
        })

        colors = allColors
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (allColors.count == 0) {
            self.initColors()
        }
        return colors.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let spec = colors[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(spec.name)
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Default, reuseIdentifier: spec.name);
            cell!.textLabel!.text = spec.name
            cell!.imageView!.image = UIImage.coloredSquare(spec.color, size: 30.0)
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedColor = colors[indexPath.row].name
        dispatch_async(dispatch_get_main_queue(),{
            self.performSegueWithIdentifier("ColorSelectionSegue", sender: self);
        })
    }

    
}
