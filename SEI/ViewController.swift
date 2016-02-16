//
//  ViewController.swift
//  SEI
//
//  Created by Joao Costa on 11/02/16.
//  Copyright © 2016 Joao Costa. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet weak var tableView: UITableView!
	
	var json: JSON?
	var section: Int?
	var row: Int?

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Set 'ViewController' as 'tableView' delegate.
		tableView.delegate				= self
		tableView.dataSource			= self
		
		// Load 'agenda.json' file.
		if let path = NSBundle.mainBundle().pathForResource("agenda", ofType: "json") {
			if let data = NSData(contentsOfFile: path) {
				json = JSON(data: data, options: .AllowFragments, error: nil)
			}
		}
		
		// Change navigation bar background color and text color.
		self.navigationController?.navigationBar.barStyle	= .BlackTranslucent
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	// MARK: UITableViewDataSource

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		if let json = json { return json.count }
		return 0
	}
	
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if let json = json {
			if let date = json[section]["date"].string { return date }
		}
		
		return nil
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if let json = json {
			if let activities = json[section]["activities"].array { return activities.count }
		}
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell: ActivityTableViewCell = tableView.dequeueReusableCellWithIdentifier("ActivityCell",
			forIndexPath: indexPath) as! ActivityTableViewCell
		
		if let json = json {
			if let activities = json[indexPath.section]["activities"].array {
				if let activity = activities[indexPath.row]["name"].string {
					// Activitiy.
					cell.activityName.text			= activity
					cell.activityTime.text			= activities[indexPath.row]["time"].string!
					cell.activityLocal.text			= activities[indexPath.row]["place"].string!
					cell.accessoryType					= .DisclosureIndicator
					cell.selectionStyle					= .Default
					cell.userInteractionEnabled	= true
					cell.addButton.hidden				= false
				} else if let _ = activities[indexPath.row]["coffee"].bool {
					// Coffee Break.
					/*
					var timeBefore: String = "", timeAfter: String = ""
					if let aux = activities[indexPath.row - 1]["time"].string {
						timeBefore	= aux.componentsSeparatedByString("-")[1]
					}
					if let aux = activities[indexPath.row + 1]["time"].string {
						timeAfter		= aux.componentsSeparatedByString("-")[0]
					}
          */
					
					// cell.detailTextLabel?.text	= "\(timeBefore) - \(timeAfter)"
					cell.activityName.text			= "Coffee Break"
					cell.activityTime.text			= ""
					cell.activityLocal.text			= ""
					// Remove user interaction with this cell.
					cell.accessoryType					= .None
					cell.selectionStyle					= .None
					cell.userInteractionEnabled	= false
					cell.addButton.hidden				= true
					
				} else if let _ = activities[indexPath.row]["meal"].bool {
					// Meal, can be lunch or dinner.
					if let time = activities[indexPath.row - 1]["time"].string {
						let times: [String] = time.componentsSeparatedByString("-")
						/*
  					let timeBefore: String	= activities[indexPath.row - 1]["time"].string!.componentsSeparatedByString("-")[1]
  					let timeAfter: String		= activities[indexPath.row + 1]["time"].string!.componentsSeparatedByString("-")[0]
						*/
						
						if (times[1] as NSString).doubleValue <= 13.0 {
							cell.activityName.text	= "Almoço"
						} else {
							cell.activityName.text	= "Jantar"
						}
  					//cell.detailTextLabel?.text	= "\(timeBefore) - \(timeAfter)"
  					cell.accessoryType					= UITableViewCellAccessoryType.None
						cell.activityTime.text			= ""
						cell.activityLocal.text			= ""
						cell.addButton.hidden				= true
						// Remove user interaction with this cell.
  					cell.accessoryType					= .None
  					cell.selectionStyle					= .None
  					cell.userInteractionEnabled	= false
					}
				}
			}
		}
		return cell
	}
	
	func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		if let json = json {
			if let activites = json[indexPath.section]["activities"].array {
				if let _ = activites[indexPath.row]["meal"].bool { return 40.0 }
				else if let _ = activites[indexPath.row]["coffee"].bool { return 40.0 }
			}
		}
		return 71.0
	}
	
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let viewController = segue.destinationViewController as? DetailViewController {
			if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
  			if let json = json {
    			if let activity = json[indexPath.section]["activities"][indexPath.row].dictionary {
  					viewController.json = activity
					}
  			}
			}
		}
	}
	
}

