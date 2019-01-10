//
//  GridViewController.swift
//  MemeMe
//
//  Created by Yousef Majeed on 03/05/1440 AH.
//  Copyright © 1440 YousefKJM. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCellView"

class GridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {

    
    @IBOutlet var gridView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()



        gridView.delegate = self
        gridView.dataSource = self
        
        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        gridView.reloadData()
        emptyLabel.isHidden = (MemeStorage.getCount() != 0)
    }

  

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return MemeStorage.getCount()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
    
        // Configure the cell
        cell.imageView.image = MemeStorage.get(indexPath.item).memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Process selection
        let detailViewController: MemeDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailsViewController") as! MemeDetailsViewController
        detailViewController.position = indexPath.item
        navigationController?.pushViewController(detailViewController, animated: true)
    }


    // MARK: UICollectionViewDelegateFlowLayout Methods
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
