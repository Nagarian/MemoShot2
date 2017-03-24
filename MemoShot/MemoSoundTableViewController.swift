//
//  MemoSoundTableViewController.swift
//  MemoShot
//
//  Created by Developer on 23/03/2017.
//  Copyright © 2017 Nagarian. All rights reserved.
//

import UIKit

class MemoSoundTableViewController: UITableViewController {

    private var sounds : [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arr = UserDefaults.standard.stringArray(forKey: "MemoSound") ?? [String]()
        sounds = arr.map { v in URL(fileURLWithPath: v) }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    @IBOutlet var soundTabView: UITableView!
    
    @IBAction func addNewMemoSound(_ sender: Any) {
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("MemoSound-" + UUID().uuidString + ".m4a")
        
        sounds.append(soundURL)
        
        let arr = sounds.map {v in v.absoluteString }
        UserDefaults.standard.set(arr, forKey: "MemoSound")
        
        soundTabView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sounds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "soundCell", for: indexPath) as! MemoSoundTableViewCell

        cell.soundUrl = sounds[indexPath.row]

        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .default, title: "🗑") { action, index in
            self.sounds.remove(at: editActionsForRowAt[1])
            let arr = self.sounds.map {v in v.absoluteString }
            UserDefaults.standard.set(arr, forKey: "MemoSound")
            self.soundTabView.reloadData()
        }
        
        more.backgroundColor = UIColor(red:1, green:0, blue:0, alpha:1.0)
        return [more]
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
