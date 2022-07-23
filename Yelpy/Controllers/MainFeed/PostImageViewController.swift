//
//  PostImageViewController.swift
//  Yelpy
//

import UIKit

// Create Protocol for PostImageViewControllerDelegate
protocol PostImageViewControllerDelegate: AnyObject {
    func imageSelected(controller: PostImageViewController, image: UIImage)
}

class PostImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    // Add delegate for the protocol you created
    weak var delegate: PostImageViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createImagePicker()
        navigationController?.navigationBar.isHidden = true
        
    }
    
    // Unwind back to Restaurant Detail after uploading image
    @IBAction func onFinishPosting(_ sender: Any) {
        performSegue(withIdentifier: "unwindToDetail", sender: self)
        
        // Pass image through protocol method
        delegate.imageSelected(controller: self, image: self.selectedImageView.image!)
    }
    
    // ImagePicker Delegate Methods
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage = info[.originalImage] as! UIImage
        
        self.selectedImageView.image = originalImage
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Create Image Picker
    func createImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            imagePicker.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}
