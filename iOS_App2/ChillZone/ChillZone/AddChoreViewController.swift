//
//  AddChoreViewController.swift
//  ChillZone
//
//  Created by David James on 3/3/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class AddChoreViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        isRepeating.isOn = false;
        // Do any additional setup after loading the view.
    }
    var who : String?
    @IBOutlet weak var isRepeating: UISwitch!
    @IBOutlet weak var daysToComplete: UITextField!
    @IBOutlet weak var choreDescirption: UITextField!
    @IBOutlet weak var choreName: UITextField!
    @IBAction func doneClick(_ sender: UIButton) {
        let name : String? = choreName.text;
        let days : Int? = daysToComplete.text == nil ? nil : Int(daysToComplete.text!);
        let description : String? = choreDescirption.text;
        if(name == nil || days == nil || description == nil){
            print("bad input")
            return;
        }
        let duration : Double = Double(days!) * 86400000;
        let chore : Chore = Chore(name : name!, description : description!, duration : duration, isRecurring : isRepeating.isOn ? 1 : 0, owner : who!);
        ChoreHandler.add(chore: chore);
        choreName.text = "";
        isRepeating.isOn = false;
        daysToComplete.text = "";
        choreDescirption.text = "";
        let alert = UIAlertController(title: "Add", message: "Chore Added", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default));
        self.present(alert, animated : true, completion : nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    var vc : PeopleDetailViewController?
    func setDataSource(vc : PeopleDetailViewController){
        self.vc = vc;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillDisappear(_ animated: Bool) {
        print("goodbye");
    }

}
