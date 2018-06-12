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
        
        if(theChore!.notify == 1 || Int(daysLeftLabel.text!)! < 0){
            self.backgroundColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 0.4);
        }else{
            self.backgroundColor = UIColor.white;
        }
        self.selectionStyle = .none;
        //actionButton.titleLabel!.text = "hello wolrd";
        actionButton.setTitle(label, for: UIControlState.normal)
    }
    private func findDays(start : Double, length : Double) -> String{
        let curtime = Date().timeIntervalSince1970 * 1000;
        var timeLeft = (start + length) - curtime;
        var neg = timeLeft < 0;
        timeLeft = abs(timeLeft);
        let daysLeft = Int(floor(timeLeft/86400000));
        neg = daysLeft == 0 ? false : neg;
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
        if(isMine){
            print("do a done")
            //print(theChore!.isRecurring)
            
            if(theChore!.isRecurring == 1){
                //Peo.people
                let index = PeopleTableViewController.people.index(of: theChore!.owner)
                ChoreHandler.push(chore: theChore!, to: PeopleTableViewController.people[(index!+1)%PeopleTableViewController.people.count]);
            }else{
                ChoreHandler.remove(chore: theChore!.id, who: theChore!.owner)
            }
        }else{
            ChoreHandler.notify(chore: theChore!.id, who : theChore!.owner);
        }
    }
}
