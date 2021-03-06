//
//  LightsViewController.swift
//  ChillZone
//
//  Created by David James on 2/9/18.
//  Copyright © 2018 David James. All rights reserved.
//

import UIKit

class LightsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var presets : [Preset] = [];
    static var docDir = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!;
    static let archURL = docDir.appendingPathComponent("savedLightsPresets");
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presets.count;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        presets.remove(at: indexPath.row);
        presetTable.reloadData();
        updatePresets();
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "presetcell", for: indexPath) as! LightsTableViewCell;
        cell.theLabel.text = presets[indexPath.row].name;
        print(presets[indexPath.row].name);
        return cell
    }
    @IBOutlet weak var globeSwitch: UISwitch!
    @IBOutlet weak var readingSwitch: UISwitch!
    @IBOutlet weak var ambientSwitch: UISwitch!
    @IBAction func globeHandler(_ sender: UISwitch) {
        LightHandler.send(preset: Preset(name : "", globe : sender.isOn, reading : LightHandler.states["reading"]!, ambient : LightHandler.states["ambient"]!))
    }
    
    @IBAction func readingHandler(_ sender: UISwitch) {
        LightHandler.send(preset: Preset(name : "", globe : LightHandler.states["globe"]!, reading : sender.isOn, ambient : LightHandler.states["ambient"]!))
    }
    @IBAction func ambientHandler(_ sender: UISwitch) {
        LightHandler.send(preset: Preset(name : "", globe : LightHandler.states["globe"]!, reading : LightHandler.states["reading"]!, ambient : sender.isOn))
    }
    @IBOutlet weak var presetTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let curState : Preset = LightHandler.setUp(self);
        
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action : #selector(adPreset));
        navigationItem.rightBarButtonItem = button;
        globeSwitch.setOn(curState.globe, animated: false);
        readingSwitch.setOn(curState.reading, animated: false);
        ambientSwitch.setOn(curState.ambient, animated: false);
        if let tempArr = NSKeyedUnarchiver.unarchiveObject(withFile: LightsViewController.archURL.path) as? [Preset] {
            presets = tempArr;
        }else{
            presets.append(Preset(name: "Off",globe: false,reading: false,ambient: false));
            presets.append(Preset(name: "Chill",globe: true,reading: false,ambient: false));
            presets.append(Preset(name: "Study", globe: true,reading: true,ambient: false));
            presets.append(Preset(name: "Lights", globe: false, reading: false, ambient: true));
        }
        presetTable.reloadData();
        LightHandler.getState();
        Comet.key(key: "/Lights")
        Comet.callback(){ () -> Void in
            LightHandler.getState();
        }
    }
    public func updateStates(_ states : [String : Bool]){
        print(states)
        ambientSwitch.isOn = states["ambient"]!
        globeSwitch.isOn = states["globe"]!
        readingSwitch.isOn = states["reading"]!
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @objc private func adPreset(){
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
    private func updatePresets(){
        //func updatePresets(){
            print("updateing");
            NSKeyedArchiver.archiveRootObject(presets, toFile: LightsViewController.archURL.path)
        //}
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LightHandler.send(preset: presets[indexPath.row]);
    }
    override func viewWillDisappear(_ animated: Bool) {
        Comet.reset();
    }

}
