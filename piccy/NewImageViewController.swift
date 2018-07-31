//
//  NewImageViewController.swift
//  piccy
//
//  Created by Amanda Reinhard on 7/17/18.
//  Copyright © 2018 Amanda Reinhard. All rights reserved.
//

import UIKit

class NewImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: NewImageViewControllerDelegate?
    var data: Data?
    var image: UIImage?
    var filename: String?
    
    let picker = UIImagePickerController()
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var enterImageTitle: UITextField!
    @IBOutlet weak var enterImageDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        let newImage = ImgurImageUpload(image: data!,
                                        title: enterImageTitle.text ?? "",
                                        description: enterImageDescription.text ?? "",
                                        fileName: filename ?? "")
        delegate?.newImageViewControllerDidCreate(image: newImage)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let picked = info[UIImagePickerControllerOriginalImage] as? UIImage, let url = info[UIImagePickerControllerImageURL] as? URL {
            imagePreview.contentMode = .scaleAspectFit
            imagePreview.image = picked
            let data = try? Data(contentsOf: url)
            self.data = data
            self.image = picked
            self.filename = url.lastPathComponent
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
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

protocol NewImageViewControllerDelegate {
    func newImageViewControllerDidCreate(image: ImgurImageUpload)
}
