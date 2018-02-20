//
//  LightsViewController.swift
//  ChillZone
//
//  Created by David James on 1/27/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork;
class LightsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    static var docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!;
    static let archURL = docDir.appendingPathComponent("savedLightsPresets");
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count;
    }
    
    
    @IBOutlet weak var ambientSwitch: UISwitch!
    @IBOutlet weak var globeSwitch: UISwitch!
    @IBOutlet weak var readingSwitch: UISwitch!
    @IBAction func ambientToggle(_ sender: UISwitch) {
        LightHandler.toggle(light : "ambient", state : sender.isOn);
    }
    @IBAction func globeToggle(_ sender: UISwitch) {
        LightHandler.toggle(light : "globe", state : sender.isOn);
    }
    @IBAction func readingToggle(_ sender: UISwitch) {
        LightHandler.toggle(light : "reading", state : sender.isOn);
    }
    
    @IBAction func addClick(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Preset", message: "Enter a Name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = ""
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            let name = textField.text;
            self.presets.append(Preset(name: name!, globe: self.globeSwitch.isOn, reading: self.readingSwitch.isOn, ambient: self.ambientSwitch.isOn));
            self.presetTable.reloadData();
            self.updatePresets();
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        presets.remove(at: indexPath.row);
        presetTable.reloadData();
        updatePresets();
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetcell", for: indexPath) as! LightPresetTableViewCell;
        cell.thelabel.text = presets[indexPath.row].name;
        print(presets[indexPath.row].name);
        return cell
    }
    
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editClick(_ sender: UIButton) {
        presetTable.setEditing(!presetTable.isEditing, animated: true);
        if(presetTable.isEditing){
            editButton.titleLabel?.text = "cancel";
        }else{
            editButton.titleLabel?.text = "edit";
        }
    }
    @IBOutlet weak var presetTable: UITableView!
    var presets : [Preset] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        let curState : Preset = LightHandler.setUp();
        globeSwitch.setOn(curState.globe, animated: false);
        readingSwitch.setOn(curState.reading, animated: false);
        ambientSwitch.setOn(curState.ambient, animated: false);
        //if there is a saved preset table, then load it, else load the default 3 presets.
        if let tempArr = NSKeyedUnarchiver.unarchiveObject(withFile: LightsViewController.archURL.path) as? [Preset] {
            presets = tempArr;
        }else{
            presets.append(Preset(name: "Off",globe: false,reading: false,ambient: false));
            presets.append(Preset(name: "Chill",globe: true,reading: false,ambient: false));
            presets.append(Preset(name: "Study", globe: true,reading: true,ambient: false));
            presets.append(Preset(name: "Lights", globe: false, reading: false, ambient: true));
        }
        presetTable.reloadData();
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updatePresets(){
        print("updateing");
        NSKeyedArchiver.archiveRootObject(presets, toFile: LightsViewController.archURL.path)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("going to send");
        LightHandler.send(preset: presets[indexPath.row]);
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
