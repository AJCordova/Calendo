//
//  EventTableViewCell.swift
//  Calendr
//
//  Created by Amiel Jireh Cordova on 5/15/22.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
