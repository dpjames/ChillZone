//
//  PeopleDetailViewController.swift
//  ChillZone
///Users/davidjames/Desktop/ChillZone/iOS_App2/ChillZone/ChillZone/Chore.swift
//  Created by David James on 2/26/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class PeopleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.section);
        print(chores.count)
        print("above you nimwit")
        if(indexPath.section == chores.count){
            let cell = UITableViewCell();
            cell.textLabel!.text = "Add New";
            cell.textLabel?.textAlignment = NSTextAlignment.center;
            return cell;
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "choreCell", for: indexPath) as! ChoreTableViewCell;
        cell.theChore = chores[indexPath.section];
        cell.make(isMine : User.email?.caseInsensitiveCompare(who!) == ComparisonResult.orderedSame);
        //cell.textLabel?.text = chores[indexPath.section].name;
        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == chores.count){
            performSegue(withIdentifier: "addSeg", sender: nil)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return chores.count + 1
    }
    var who : String?;
    var chores : [Chore] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.rightBarButtonItem = addButton;
        self.title = who!;
        table.delaysContentTouches = false;
        table.sectionHeaderHeight = 100;
        self.table.estimatedRowHeight = 100;
        table.rowHeight = UITableViewAutomaticDimension;
        
        //self.table.estimatedRowHeight = 200.0;
        ChoreHandler.setup(view: self);
        ChoreHandler.getChores(for : who!);
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var table: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setView(who : String){
        self.who = who;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! AddChoreViewController).who = who!;
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
