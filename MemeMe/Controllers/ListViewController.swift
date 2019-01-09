//
//  ListViewController.swift
//  MemeMe
//
//  Created by Yousef Majeed on 03/05/1440 AH.
//  Copyright © 1440 YousefKJM. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController  {

    
    @IBOutlet var tablView: UITableView!
    
    @IBOutlet weak var EmptyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register XIB file to UITableView
        tablView.register(UINib(nibName: "MemeTableViewCell", bundle: nil), forCellReuseIdentifier: "MemeCellView")
        
        tablView.delegate = self
        tablView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MemeStorage.getCount() == 0 {
            tablView.isHidden = true
            EmptyLabel.isHidden = false
        } else {
            tablView.isHidden = false
            EmptyLabel.isHidden = true
            tablView.reloadData()
        }
    }


    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MemeStorage.getCount()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memeObject = MemeStorage.get(indexPath.row)
        let titleText = memeObject.topText + " " + memeObject.bottomText
        
        let cell: MemeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MemeCellView") as! MemeTableViewCell
        // Configure the cell...
        cell.memeTitleLabel.text = titleText
        cell.memeImageView.image = memeObject.memedImage
        return cell
    }
 

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController: MemeDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailViewController.position = indexPath.item
        navigationController?.pushViewController(detailViewController, animated: true)
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
