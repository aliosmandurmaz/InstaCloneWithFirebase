//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Ali Osman DURMAZ on 31.03.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var upload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Resme tıklanabilirlik kazandırma
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func chooseImage() {
        // Galeriye erişmek için
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // Kullanıcı resim seçtikten sonraki işlem
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func makeAlert(titleInput: String,messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        
        let mediaFolder = storageReferance.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            // if let işlemi db de veri UIimage olarak tutamayacağımız için data olarak tutmaya yarar...
            
            let uuid = UUID().uuidString // dosya depolama işlemini id ile yapmalıyız çünkü image.jpeg ile kaydettiğimiz her veri bir öncekinin üstüne yazılır ve db depolamada sadece bir dosya gözükür !
            
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: "\(error?.localizedDescription)")
                }else {
                    imageReferance.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            
                            // DATABASE
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReferance: DocumentReference? = nil
                            
                            let firestorePost = ["imageUrl": imageUrl!,"postedBy": Auth.auth().currentUser!.email!,"postComment": self.commentText.text!,"date": FieldValue.serverTimestamp(),"likes": 0] as [String : Any]
                            // FieldValue.serverTimestamp anlık tarihi çekmek için yazıldı
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                }else {
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    // Kullanıcı fotoğraf seçtikten sonra tekrar uploada dönüldüğünde alanı sıfırlar...
                                    self.tabBarController?.selectedIndex = 0
                                    // İndeks numarası tabbar daki itemler için gerekli Fields = 0 , Upload = 1 , Settings = 2 ...
                                    
                                }
                            })
                            
                        }
                    }
                    
                }
            }
        }
            
    }
    
  
}
