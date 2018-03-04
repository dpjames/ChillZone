//
//  PeopleDetailViewController.swift
//  ChillZone
//
//  Created by David James on 2/26/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class PeopleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "choreCell", for: indexPath);
        cell.textLabel?.text = chores[indexPath.section].name;
        return cell;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return chores.count
    }
    var who : String?;
    var chores : [Chore] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = who!;
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
