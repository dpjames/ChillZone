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
        return 1;
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return messages.count+1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! MessageTableViewCell;
        if(indexPath.section == 0){
            cell.left.backgroundColor = UIColor.clear
            cell.left.text = "";
            cell.right.backgroundColor = UIColor.clear;
            cell.right.text = "";
            cell.textLabel!.text = "<LOAD ALL MESSAGES>";
            cell.textLabel!.textAlignment = .center;
        }else{
            cell.textLabel!.text = "";
            cell.left.layer.masksToBounds = true;
            cell.right.layer.masksToBounds = true;
            cell.left.layer.cornerRadius = 10.0;
            cell.right.layer.cornerRadius = 10.0;
            if(messages[indexPath.section-1].email == User.email!){
                cell.right.text = messages[indexPath.section-1].email + ":\n" + messages[indexPath.section-1].content
                cell.right.backgroundColor = UIColor.cyan;
                cell.left.backgroundColor = UIColor.clear;
                cell.left.text = ""
            }else{
                cell.left.text = messages[indexPath.section-1].email + ":\n" + messages[indexPath.section-1].content
                cell.right.text = "";
                cell.left.backgroundColor = UIColor.lightGray
                cell.right.backgroundColor = UIColor.clear;
            }
        }
        return cell
    }
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: self.messages.count)
            //print("indide now to scroll. with ip \(indexPath.row) and length \(self.messages.count)")
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let ret = UIView();
        ret.backgroundColor = tableView.backgroundColor;
        return ret;
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(messages.count);
        composeMessage.layer.masksToBounds = true;
        composeMessage.layer.borderColor = UIColor.black.cgColor;
        composeMessage.layer.borderWidth = 3;
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        MessageHandler.setUp(vc: self)
        MessageHandler.getMessages(since: 0, all: false);
        Comet.key(key : "/Cnvs/1/Msgs")
        Comet.callback(){() in
            print("callback-----------")
            if(self.messages.isEmpty){
                MessageHandler.getAllMessages();
                return;
            }
            MessageHandler.getMessages(since: self.messages[self.messages.count-1].whenMade, all : false)
        
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height+45
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y = 0;
            }
        }
    }
    @IBOutlet weak var composeMessage: UITextView!
    @IBAction func doSend(_ sender: UIButton) {
        //composeMessage.resignFirstResponder();
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        MessageHandler.sendMessage(content: composeMessage.text!.replacingOccurrences(of: "\n", with: " \\n"));
        composeMessage.text = "";
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            MessageHandler.getAllMessages();
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        Comet.reset();
    }

}
