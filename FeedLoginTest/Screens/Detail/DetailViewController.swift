//
//  DetailViewController.swift
//  WebMastersTest
//
//  Created by Innakentiy Lukin on 5/19/18.
//  Copyright © 2018 Innakentiy Lukin. All rights reserved.
//

import UIKit
import AVFoundation

protocol DetailViewDelegate: class {
    func onArticleImageChanged()
}

class DetailViewController: UIViewController, UINavigationControllerDelegate {
    
    weak public var delegate: DetailViewDelegate?
    
    @IBOutlet weak var articleTextArea: UITextView!
    @IBOutlet weak var articleSource: UILabel!
    @IBOutlet weak var articlePublishDate: UILabel!
    @IBOutlet weak var articleAuthor: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var changeImageButton: UIButton!

    var article: Article!

    private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customLayout()
        setupArticleInfo()
        addButtonTargets()
    }
    
    private func addButtonTargets() {
        closeButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        changeImageButton.addTarget(self, action: #selector(changeImageTapped), for: .touchUpInside)
    }
    
    private func customLayout() {
        closeButton.layer.cornerRadius = 17
        changeImageButton.layer.cornerRadius = 22
    }
    
    private func setupArticleInfo() {
        articleAuthor.text = article.author
        articleTitle.text = article.title
        articleSource.text = "via \(article.source.name ?? "")"
        
        if let imageUrl = article.imageUrl {
            articleImageView.setImageWith(url: imageUrl)
        } else {
            articleImageView.setImageWith(url: article.strHash)
        }
        articleTextArea.text = article.description
        articlePublishDate.text = article.getPublishDate()
    }

    
    @objc func dismissTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeImageTapped() {
        let actionSheet = UIAlertController(title: "New Image", message: "Select your new image", preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: "Take a picture", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) { self.setupAction(type: .camera) }
        }
        
        let libraryAction = UIAlertAction(title: "Select from Camera roll", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) { self.setupAction(type: .photoLibrary) }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            actionSheet.dismiss(animated: true, completion: nil)
        }
        
        actionSheet.addAction(photoAction)
        actionSheet.addAction(libraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func setupAction(type: UIImagePickerControllerSourceType) {
        picker.delegate = self
        picker.sourceType = type
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
}

extension DetailViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        if let imageUrl = article.imageUrl {
            articleImageView.setImageWith(url: imageUrl, image: image)
        } else {
            articleImageView.setImageWith(url: article.strHash, image: image)
        }
        
        delegate?.onArticleImageChanged()
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    
}



