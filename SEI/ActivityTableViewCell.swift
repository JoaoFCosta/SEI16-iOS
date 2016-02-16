//
//  ActivityTableViewCell.swift
//  SEI
//
//  Created by Joao Costa on 16/02/16.
//  Copyright © 2016 Joao Costa. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
	@IBOutlet weak var activityName: UILabel!
	@IBOutlet weak var activityTime: UILabel!
	@IBOutlet weak var activityLocal: UILabel!
	@IBOutlet weak var addButton: UIButton!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	@IBAction func addToAgenda(sender: UIButton!) {
		print("Added")
	}
	
}
