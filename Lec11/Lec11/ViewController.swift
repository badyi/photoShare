//
//  ViewController.swift
//  Lec11
//
//  Created by badyi on 17.05.2021.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap on the cute cat to choose a picture and share it"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = label.font.withSize(16)
        label.textColor = .systemBlue
        label.contentMode = .center
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemTeal
        view.image = UIImage(named: "cuteCat")
        view.contentMode = .scaleAspectFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.setTitle("Share", for: .normal)
        button.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.height / 2
        imageView.clipsToBounds = true
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        imageView.image = selectedImage
        infoLabel.text = "Tap on the image to choose another and share"
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {
    func configView() {
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapImage)
        
        view.backgroundColor = .white
        view.addSubview(infoLabel)
        view.addSubview(imageView)
        view.addSubview(shareButton)
        
        infoLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: -20).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        shareButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        shareButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
    }
    
    @objc func didTapShare() {
        presentActivityViewController()
    }
    
    @objc func didTapImageView() {
        presentPhotoActionSheet()
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self 
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentActivityViewController() {
        guard let image = imageView.image else {
            return
        }
        
        let customActivity = CustomActivity(title: "Am i cute?", imageName:"cuteCat2", performAction: { [weak self] in
            let alert = UIAlertController(title: "", message: "He is cute and adorable", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Agreed", style: .cancel, handler: nil))
            self?.present(alert, animated: true, completion: nil)
        })
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [customActivity])
        vc.isModalInPresentation = true
        vc.excludedActivityTypes = [.postToFlickr, .postToVimeo, .saveToCameraRoll]
        
        self.present(vc, animated: true)
    }
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
}
