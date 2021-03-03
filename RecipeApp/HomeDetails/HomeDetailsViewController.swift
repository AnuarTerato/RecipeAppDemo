//
//  HomeDetailsViewController.swift
//  RecipeApp
//
//  Created by Anuar Nordin on 02/03/2021.
//

import UIKit
import SDWebImage
import RealmSwift
import SwiftyUserDefaults

class HomeDetailsViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var ingredientsTextField: UITextField!
    @IBOutlet weak var stepsTextField: UITextField!
    @IBOutlet weak var backgroundBtnView: UIView!
    @IBOutlet weak var addPictureView: UIView!
    @IBOutlet weak var addPictureBtn: UIButton!
    
    var indexNumber = Int()
    var checkBool = Bool()
    var addImagesData = UIImage()
    let picker = UIImagePickerController()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toolBar()
        setupView()
    }

    @IBAction func addPictureBtnPressed(_ sender: UIButton) {
        callImages()
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        if checkBool == true{
            let listRecipeNameArrayTempRealm = self.realm.objects(RecipeNameArrayTempRealm.self)
            let listRecipeNameArrayRealm = self.realm.objects(RecipeNameArrayRealm.self)
            let listRecipeIngredientsArrayRealm = self.realm.objects(RecipeIngredientsArrayRealm.self)
            let listRecipeStepsArrayRealm = self.realm.objects(RecipeStepsArrayRealm.self)

            try! self.realm.write {
                self.realm.delete(listRecipeNameArrayTempRealm)
                self.realm.delete(listRecipeNameArrayRealm)
                self.realm.delete(listRecipeIngredientsArrayRealm)
                self.realm.delete(listRecipeStepsArrayRealm)
            }
            
            Global.recipeNameArray[indexNumber] = nameTextField.text!
            Global.recipeNameArrayTemp[indexNumber] = nameTextField.text!

            Global.recipeIngredientsArray[indexNumber] = ingredientsTextField.text!
            Global.recipeStepsArray[indexNumber] = stepsTextField.text!
            
            Global.recipeNameArray.forEach { (item) in
                let each = RecipeNameArrayRealm()
                each.recipeNameArray.append(item)
                try! self.realm.write {
                    self.realm.add(each)
                }
            }
            
            Global.recipeNameArrayTemp.forEach { (item) in
                let eachTwo = RecipeNameArrayTempRealm()
                eachTwo.recipeNameArrayTemp.append(item)
                try! self.realm.write {
                    self.realm.add(eachTwo)
                }
            }
            
            Global.recipeIngredientsArray.forEach { (item) in
                let eachThree = RecipeIngredientsArrayRealm()
                eachThree.recipeIngredientsArray.append(item)
                try! self.realm.write {
                    self.realm.add(eachThree)
                }
            }
            
            Global.recipeStepsArray.forEach { (item) in
                let eachFour = RecipeStepsArrayRealm()
                eachFour.recipeStepsArray.append(item)
                try! self.realm.write {
                    self.realm.add(eachFour)
                }
            }
        }else{
            if nameTextField.text!.count == 0{
                displayAlertMessage(message: "Please fill name!")
                return
            }
            
            if ingredientsTextField.text!.count == 0{
                displayAlertMessage(message: "Please fill ingredients!")
                return
            }
            
            if stepsTextField.text!.count == 0{
                displayAlertMessage(message: "Please fill steps!")
                return
            }
            
            let each = RecipeNameArrayRealm()
            each.recipeNameArray.insert(nameTextField.text!, at: 0)
            
            let eachTwo = RecipeNameArrayTempRealm()
            eachTwo.recipeNameArrayTemp.insert(nameTextField.text!, at: 0)
            
            let eachThree = RecipeIngredientsArrayRealm()
            eachThree.recipeIngredientsArray.insert(ingredientsTextField.text!, at: 0)
            
            let eachFour = RecipeStepsArrayRealm()
            eachFour.recipeStepsArray.insert(stepsTextField.text!, at: 0)
            
            let data = addImagesData
            let bildData = data.jpegData(compressionQuality: 1.0)
            let eachFive = RecipePictureUIImageArrayRealm()
            eachFive.recipePictureUIImageArray.insert(bildData ?? Data(), at: 0)
            
            let eachSix = RecipePictureUIImageArrayTempRealm()
            eachSix.recipePictureUIImageArrayTemp.insert(bildData ?? Data(), at: 0)
            
            try! self.realm.write {
                self.realm.add(each)
                self.realm.add(eachTwo)
                self.realm.add(eachThree)
                self.realm.add(eachFour)
                self.realm.add(eachFive)
                self.realm.add(eachSix)
            }
            
            Global.recipeNameArray.append(nameTextField.text!)
            Global.recipeNameArrayTemp.append(nameTextField.text!)
            Global.recipeIngredientsArray.append(ingredientsTextField.text!)
            Global.recipeStepsArray.append(stepsTextField.text!)
            Global.recipePictureUIImageArray.append(addImagesData)
            Global.recipePictureUIImageArrayTemp.append(addImagesData)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func setupView(){
        backgroundBtnView.backgroundColor = .black
        backgroundBtnView.rounded(radius: 30)

        if checkBool == true{
            addPictureView.isHidden = true
            titleLbl.text = Global.recipeNameArray[indexNumber]
            nameTextField.text = Global.recipeNameArray[indexNumber]
            menuImageView.image = Global.recipePictureUIImageArray[indexNumber]
            ingredientsTextField.text = Global.recipeIngredientsArray[indexNumber]
            stepsTextField.text = Global.recipeStepsArray[indexNumber]
        }else{
            titleLbl.text = "Add recipe"
            addPictureView.isHidden = false
        }
    }
    
    func toolBar(){
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([spaceButton,spaceButton,doneButton], animated: false)

        nameTextField.inputAccessoryView = toolbar
        ingredientsTextField.inputAccessoryView = toolbar
        stepsTextField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

extension HomeDetailsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func callImages(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)//actionSheet
        alertController.view.tintColor = UIColor(red: 22/255, green: 16/255, blue: 21/255, alpha: 1.0)
        
        let fromCamera = UIAlertAction(title: "Take photo", style: .default) { (action:UIAlertAction!) in
            print("Take Photo tapped")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.delegate = self
                self.picker.allowsEditing = false
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            } else {
                self.noCamera()
            }
        }
        
        let fromGallery = UIAlertAction(title: "Gallery", style: .default) { (action:UIAlertAction!) in
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            print("cancel tapped")
        }
        
        alertController.addAction(fromCamera)
        alertController.addAction(fromGallery)
        alertController.addAction(cancel)
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No camera", message: "Sorry, this device no camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        addImagesData = selectedImage.normalizedImage()
        menuImageView.image = addImagesData
        addPictureView.isHidden = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
