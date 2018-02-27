//
//  ChatViewController.swift
//  ChillZone
//
//  Created by David James on 2/26/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate{
    var messages : [Message] = [];
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell;
        // Configure the cell...
        //cell.textLabel!.text = String(indexPath.row);
        //cell.content.text = "a very very very very very long text tstring that should exceep the row or something idk"
        cell.content.text = messages[indexPath.row].content
        print(User.email);
        print(messages[indexPath.row].email);
        cell.content.textAlignment = messages[indexPath.row].email == User.email! ? NSTextAlignment.right : NSTextAlignment.left;
        return cell
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            if(self.messages.count > 0){
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        MessageHandler.setUp(vc: self)
        MessageHandler.comet();
        MessageHandler.getAllMessages()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var composeMessage: UITextView!
    @IBAction func doSend(_ sender: UIButton) {
        print(composeMessage.text!)
        print("look above!!!");
        MessageHandler.sendMessage(content: composeMessage.text!);
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
