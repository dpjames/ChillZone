//
//  PeopleTableViewCell.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class PeopleTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isHome: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func make(_ row : Int){
        self.nameLabel!.text = PeopleTableViewController.people[row];
        doHome(row);
    }
    
    private func doHome(_ row : Int){
        let _ = HttpHandler.request(method: "GET", path: "/Prss?email="+PeopleTableViewController.people[row], body: ""){(data, response, error) in
            if(HttpHandler.noConnection){
                print("error in request fpr is home");
                return;
            }
            let code = (response as! HTTPURLResponse).statusCode;
            if(code == 200){
                print("it worked")
                do{
                    let people = try JSONDecoder().decode(Array<Person>.self, from: data!);
                    let isHome = people[0].isHome;
                    DispatchQueue.main.async {
                        if(isHome == 1){
                            self.isHome.backgroundColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.4)
                        }else{
                            self.isHome.backgroundColor = UIColor(displayP3Red: 1, green: 0, blue: 0, alpha: 0.4)
                        }
                    }
                }catch{
                    print("there was a json error")
                }
            }else{
                print("it did not work")
            }
        }
    }
}
struct Person : Codable {
    var isHome : Int;
}

