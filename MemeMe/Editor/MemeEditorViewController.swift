//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Yousef Majeed on 29/04/1440 AH.
//  Copyright © 1440 YousefKJM. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate {


    //Outlets
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var cameraButton: UIBarButtonItem!

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    //Variables/Constants
    let DEFAULT_TOP_TEXT = "TOP TEXT"
    let DEFAULT_BOTTOM_TEXT = "BOTTOM TEXT"
    
    let memeTextAttributes:[String:Any] = [
        NSAttributedString.Key.strokeColor.rawValue : UIColor.black,
        NSAttributedString.Key.foregroundColor.rawValue: UIColor.white,
        NSAttributedString.Key.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth.rawValue: -3.0]
    
    var isEdited = false
    var isShared = false
    
    
    //Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure TextFields
        configure(topTextField)
        configure(bottomTextField)
        
        // Set suitable View state
        setViewState(.BLANK)
    }
    
    func configure(_ textField: UITextField) -> Void {
        textField.defaultTextAttributes = convertToNSAttributedStringKeyDictionary(memeTextAttributes)
        textField.textAlignment = .center
        textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: Image picker methods
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        launchImagePicker(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        launchImagePicker(.camera)
    }
    
    func launchImagePicker(_ source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = source
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    

    // MARK: NavigationBar Button Outlets
    @IBAction func onShareClicked(_ sender: Any) {
        // Create MemeObject
        let memedImage = generateMemedImage()
        let itemsToShare = [ memedImage ]
        
        // Set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // Set completion
        activityViewController.completionWithItemsHandler = { (_, completed, _,  _) in
            if !completed {
                return
            }
            
            let meme = MemeObject(
                topText: self.topTextField.text!,
                bottomText: self.bottomTextField.text!,
                originalImage: self.imagePickerView.image!,
                memedImage: memedImage
            )
            
            // Save meme
            MemeStorage.addMeme(meme)
            
            
            self.isShared = true
            let alertMessage = "Meme was saved successfully."
            
            let alertController = UIAlertController(title: "Meme Saved", message: alertMessage , preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        
        }
        
        // present the view controller
        self.present(activityViewController, animated: true)
    }
    
    
    @IBAction func onCancelClicked(_ sender: Any) {
        if !isEdited || isShared {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        let alertController = UIAlertController(title: "Cancel Editing", message: "All the changes will be lost and Meme will reset. Are you sure?", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "No, go back to editor."), style: .default,
                                                handler: {(action:UIAlertAction!) in
                                                    
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Reset editor."), style: .destructive,
                                                handler: {(action:UIAlertAction!) in
                                                    self.setViewState(.BLANK)
                                                    self.dismiss(animated: true, completion: nil)
        }))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
            picker.dismiss(animated: true, completion: nil)
            if (topTextField.text != DEFAULT_TOP_TEXT) && (bottomTextField.text != DEFAULT_BOTTOM_TEXT ) {
                setViewState(.MEME_COMPLETE)
            } else {
                setViewState(.MEME_EDITING)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        let alertController = UIAlertController(title: "No Image Selected", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: UITextField Delegate methods

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (topTextField == textField && topTextField.text == DEFAULT_TOP_TEXT) {
            topTextField.text = ""
        }
        if (bottomTextField == textField && bottomTextField.text == DEFAULT_BOTTOM_TEXT) {
            bottomTextField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    // MARK: View State helper functions
    
    enum ViewState {
        case BLANK
        case MEME_EDITING
        case MEME_COMPLETE
    }
    
    func setViewState(_ state: ViewState) {
        switch state {
        case .MEME_EDITING:
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
            topTextField.alpha = 1.0
            bottomTextField.alpha = 1.0
            shareButton.isEnabled = false
            isEdited = true
            break
        case .MEME_COMPLETE:
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
            shareButton.isEnabled = true
            isEdited = true
            break
        default: // BLANK
            topTextField.isEnabled = false
            bottomTextField.isEnabled = false
            topTextField.alpha = 0.5
            bottomTextField.alpha = 0.5
            shareButton.isEnabled = false
            // Set to Defaults
            imagePickerView.image = nil
            topTextField.text = DEFAULT_TOP_TEXT
            bottomTextField.text = DEFAULT_BOTTOM_TEXT
            isEdited = false
            isShared = false
            break
        }
    }
    
    
    // MARK: Keyboard related methods

    func subscribeToKeyboardNotifications() {

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if (bottomTextField.isFirstResponder) {
            view.frame.origin.y = 0
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if (bottomTextField.isFirstResponder) {
            // Reset View to it's original position
            view.frame.origin.y = 0
        }
        
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Meme sharing methods
    
    func generateMemedImage() -> UIImage {
        // Hide NavigationBar and Toolbar
        toggleExtraViews(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.bounds.size)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show 'em again
        toggleExtraViews(hide: false)
        
        return memedImage
    }
    
    private func toggleExtraViews(hide: Bool) {
        navBar.isHidden = hide
        toolBar.isHidden = hide
    }

 
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToNSAttributedStringKeyDictionary(_ input: [String: Any]) -> [NSAttributedString.Key: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
