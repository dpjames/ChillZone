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
        cell.content.text = messages[indexPath.row].content
        cell.content.textAlignment = messages[indexPath.row].email == User.email! ? NSTextAlignment.right : NSTextAlignment.left;
        return cell
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            if(self.messages.count > 0){
                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                print("indide now to scroll. with ip \(indexPath.row) and length \(self.messages.count)")
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO save messages local and then remove getAllMessagesCall(). replaec with getmessages(since: last time message)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        MessageHandler.setUp(vc: self)
        MessageHandler.getAllMessages()
        Comet.key(key : "/Cnvs/1/Msgs")
        Comet.callback(){() in
            if(self.messages.isEmpty){
                MessageHandler.getAllMessages();
                return;
            }
            MessageHandler.getMessages(since: self.messages[self.messages.count-1].whenMade)
        }
    }
    
    @IBOutlet weak var composeMessage: UITextView!
    @IBAction func doSend(_ sender: UIButton) {
        MessageHandler.sendMessage(content: composeMessage.text!);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        Comet.reset();
    }

}
