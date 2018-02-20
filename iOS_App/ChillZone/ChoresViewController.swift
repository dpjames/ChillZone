//
//  ChoresViewController.swift
//  ChillZone
//
//  Created by David James on 1/27/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class ChoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height -  (self.navigationController?.navigationBar.frame.size.height)!) / CGFloat(persons.count);
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peoplecell", for: indexPath) as! ChorePersonTableViewCell;
        cell.theLabel.text = persons[indexPath.row];
        return cell
    }
    
    let persons : [String] = ["David","Cameron","Ryan","Hans","Josh"];
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
