//
//  MemeEditorViewController.swift
//  Meme V2.0
//
//  Created by Muhammed on 25/04/1440 AH.
//  Copyright © 1440 Udaicty. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    //MARK: properties
    
    //top of view
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    //middle of view
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    //bottom of view
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    

    //MARK: dictionaries
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -4
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyBoardNotification()
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyBoardNotification()
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureTextField(textField: topTextField, withText: "TOP")
        configureTextField(textField: bottomTextField, withText: "BOTTOM")
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        configureButtons(false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
        if textField.tag == 2 { //only bottom text will subscribe
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        self.presentImagePickerWith(sourceType: .photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        self.presentImagePickerWith(sourceType: .camera)
    }
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated:true, completion:nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        configureButtons(true)
        picker.dismiss(animated: true, completion: nil)
    }
    @IBAction func share() {
        let memedImage = self.generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, completed, items, error in
            
            if completed {
                
                //save the image
                self.save(memedImage: memedImage)
                
                //Dismiss the shareActivityViewController
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    // rest the properties to initialization state
//    @IBAction func resetState() {
//        topTextField.text = "TOP"
//        bottomTextField.text = "BOTTOM"
//        imagePickerView.image = nil
//        shareButton.isEnabled = false
//        cancelButton.isEnabled = false
//    }
    @IBAction func cancelEditor(){
        self.dismiss(animated: true, completion: nil)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func KeyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyBoardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    // save struct of Meme
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // rettun the image with text
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        configureBars(true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        configureBars(false)
        
        return memedImage
    }
    
    func configureBars(_ isHidden: Bool) {
        toolbar.isHidden = isHidden
        navigationBar.isHidden = isHidden
    }
    func configureButtons(_ isEnabled: Bool) {
        shareButton.isEnabled = isEnabled
    }
    func configureTextField(textField :UITextField, withText text: String){
        textField.delegate = self
        textField.defaultTextAttributes = self.memeTextAttributes
        textField.textAlignment = NSTextAlignment.center
        textField.text = text
    }
}

