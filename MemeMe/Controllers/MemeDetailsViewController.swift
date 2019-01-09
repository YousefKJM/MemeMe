//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by Yousef Majeed on 03/05/1440 AH.
//  Copyright © 1440 YousefKJM. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var position: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (position != nil) {
            let meme = MemeStorage.get(position)
            memedImageView.image = meme.memedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (position == nil) {
            let alertController = UIAlertController(title: "No Meme Selected", message: "", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


