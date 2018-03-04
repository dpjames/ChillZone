//
//  ChoreTableViewCell.swift
//  ChillZone
//
//  Created by David James on 3/3/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class ChoreTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var isMine : Bool = false;
    var theChore : Chore?;
    func make(isMine : Bool){
        self.isMine = isMine;
        descriptionLabel.text = theChore!.description;
        nameLabel.text = theChore!.name;
        daysLeftLabel.text = findDays(start: theChore!.startTime, length: theChore!.duration);
        let label = isMine ? "Done" : "Notify"
        //actionButton.titleLabel!.text = "hello wolrd";
        actionButton.setTitle(label, for: UIControlState.normal)
    }
    private func findDays(start : Double, length : Double) -> String{
        let curtime = Date().timeIntervalSince1970 * 1000;
        var timeLeft = (start + length) - curtime;
        let neg = timeLeft < 0;
        timeLeft = abs(timeLeft);
        let daysLeft = Int(floor(timeLeft/86400));
        var ret = String(daysLeft);
        print("below")
        print(curtime);
        print(start);
        print(length);
        print(length+start);
        print(timeLeft);
        print("above")
        ret = neg ? "-"+ret : ret;
        return ret;
    }
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBAction func actionButtonClick(_ sender: UIButton) {
        
    }
}
