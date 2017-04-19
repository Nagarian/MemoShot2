//
//  MemoShotTableViewController.swift
//  MemoShot
//
//  Created by Developer on 23/03/2017.
//  Copyright © 2017 Nagarian. All rights reserved.
//

import UIKit

class MemoShotTableViewController: UITableViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    private var images : [UIImage?] = []
    private var imagesName: [String] = []
    var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let arr = UserDefaults.standard.stringArray(forKey: "MemoShot") ?? [String]()
        for str in arr {
            
            if let img = try? UIImage(data: try Data(contentsOf: URL(string: str)!)) {
                images.append(img)
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            return images.count
        // #warning Incomplete implementation, return the number of rows
    }
    @IBOutlet var tabView: UITableView!
    
    @IBAction func addNewMemoShot(_ sender: UIBarButtonItem) {
         imagePicker =  UIImagePickerController()
         imagePicker?.delegate = self
         imagePicker?.sourceType = .photoLibrary
         
         present(imagePicker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let data = UIImagePNGRepresentation(pickedImage) {
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentDirectory = urls[0] as URL
                let filename = documentDirectory.appendingPathComponent("MemoShot-" + UUID().uuidString + ".png")
                imagesName.append(filename.absoluteString)
                
                UserDefaults.standard.set(imagesName, forKey: "MemoShot")
                try? data.write(to: filename)
            }
            
            images.append(pickedImage)
            
            tabView.reloadData()
        }
        
        imagePicker?.dismiss(animated: true, completion: nil)
        
        //imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! MemoShotTableViewCell
        
        cell.imageView?.image = images[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let more = UITableViewRowAction(style: .default, title: "🗑") { action, index in
            do {
                try FileManager.default.removeItem(atPath: self.imagesName[editActionsForRowAt[1]])
            }
            catch let error as NSError {
                print("Ooops! Something went wrong: \(error)")
            }
            self.images.remove(at: editActionsForRowAt[1])
            self.imagesName.remove(at: editActionsForRowAt[1])
            UserDefaults.standard.set(self.imagesName, forKey: "MemoShot")
            self.tabView.reloadData()
        }
        
        more.backgroundColor = UIColor(red:1, green:0, blue:0, alpha:1.0)
        return [more]
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
