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
    

}
