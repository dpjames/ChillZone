//
//  PeopleTableViewController.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class PeopleTableViewController: UITableViewController{
    private var people = ["David","Cameron","Hans","Ryan","Josh"];
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height - 20 - self.navigationController!.navigationBar.frame.height)/5;
    }
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "peopleDetail", sender: indexPath.row);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peoplecell", for: indexPath) as! PeopleTableViewCell;
        cell.nameLabel?.text = people[indexPath.row];
        // Configure the cell...
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! PeopleDetailViewController).setView(who: people[(sender as! Int)])
    }

}
