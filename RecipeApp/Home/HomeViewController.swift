//
//  HomeViewController.swift
//  RecipeApp
//
//  Created by Anuar Nordin on 01/03/2021.
//

import UIKit
import SVProgressHUD
import SDWebImage
import RealmSwift
import SwiftyUserDefaults

struct Recipe {
    var recipeName: String
    var recipePictureURL: String
    var recipeIngredients: String
    var recipeSteps: String
}

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    var elementName: String = String()
    var recipeName = String()
    var recipePictureURL = String()
    var recipeIngredients = String()
    var recipeSteps = String()

    var fullStack = [String : UIImage]()
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        toolBar()
        
        if Defaults[\.initialFetch] == false{
            readXML()
        }else{
            readRealm()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchTextField.text = ""
        fullStack = Dictionary(zip(Global.recipeNameArray, Global.recipePictureUIImageArray), uniquingKeysWith: { (first, _) in first })
        tableView.reloadData()
    }
    
    @IBAction func addBtnPressed(_ sender: UIButton) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeDetailsViewController") as! HomeDetailsViewController
        nextVC.checkBool = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func callDeleteCell(_ notification: Notification){
        if let passDeleteTag = notification.userInfo?["passInt"] as? Int {
            displayAlertMessage(messageToDisplay: "Confirm to delete recipe?", passDeleteTag: passDeleteTag)
        }
    }
    
    func setupView(){
        NotificationCenter.default.addObserver(self, selector: #selector(callDeleteCell), name: Notification.Name("deleteCell"), object: nil)
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: .editingChanged)
        addBtn.rounded(radius: 30)
    }
    
    func readRealm(){
        let listRecipeNameArrayTempRealm = self.realm.objects(RecipeNameArrayTempRealm.self)
        let listRecipeNameArrayRealm = self.realm.objects(RecipeNameArrayRealm.self)
        let listRecipePictureUIImageArrayTempRealm = self.realm.objects(RecipePictureUIImageArrayTempRealm.self)
        let listRecipePictureUIImageArrayRealm = self.realm.objects(RecipePictureUIImageArrayRealm.self)
        let listRecipeIngredientsArrayRealm = self.realm.objects(RecipeIngredientsArrayRealm.self)
        let listRecipeStepsArrayRealm = self.realm.objects(RecipeStepsArrayRealm.self)
        
        for data in listRecipeNameArrayTempRealm{
            Global.recipeNameArray.append(contentsOf: data.recipeNameArrayTemp)
        }
        
        for data in listRecipeNameArrayRealm{
            Global.recipeNameArrayTemp.append(contentsOf: data.recipeNameArray)
        }

        for data in listRecipePictureUIImageArrayTempRealm{
            let each = Array(data.recipePictureUIImageArrayTemp).first
            let image = UIImage(data: each ?? Data())
            Global.recipePictureUIImageArrayTemp.append(image ?? UIImage())
        }
        
        for data in listRecipePictureUIImageArrayRealm{
            let each = Array(data.recipePictureUIImageArray).first
            let image = UIImage(data: each ?? Data())
            Global.recipePictureUIImageArray.append(image ?? UIImage())
        }

        for data in listRecipeIngredientsArrayRealm{
            Global.recipeIngredientsArray.append(contentsOf: data.recipeIngredientsArray)
        }
        
        for data in listRecipeStepsArrayRealm{
            Global.recipeStepsArray.append(contentsOf: data.recipeStepsArray)
        }
        
        tableView.reloadData()
    }
    
    func readXML(){
        let listRecipeNameArrayTempRealm = self.realm.objects(RecipeNameArrayTempRealm.self)
        let listRecipeNameArrayRealm = self.realm.objects(RecipeNameArrayRealm.self)
        let listRecipePictureUIImageArrayTempRealm = self.realm.objects(RecipePictureUIImageArrayTempRealm.self)
        let listRecipePictureUIImageArrayRealm = self.realm.objects(RecipePictureUIImageArrayRealm.self)
        let listRecipeIngredientsArrayRealm = self.realm.objects(RecipeIngredientsArrayRealm.self)
        let listRecipeStepsArrayRealm = self.realm.objects(RecipeStepsArrayRealm.self)
        
        try! self.realm.write {
            self.realm.delete(listRecipeNameArrayTempRealm)
            self.realm.delete(listRecipeNameArrayRealm)
            self.realm.delete(listRecipePictureUIImageArrayTempRealm)
            self.realm.delete(listRecipePictureUIImageArrayRealm)
            self.realm.delete(listRecipeIngredientsArrayRealm)
            self.realm.delete(listRecipeStepsArrayRealm)
        }
        
        if let path = Bundle.main.url(forResource: "recipetypes", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
                
            }else{
                print("parserElse")
            }
        }else{
            print("readXMLElse")
        }
        
        fullStack = Dictionary(zip(Global.recipeNameArray, Global.recipePictureUIImageArray), uniquingKeysWith: { (first, _) in first })
        print("fullStack", fullStack)
        Defaults[\.initialFetch] = true
    }
    
    func displayAlertMessage(messageToDisplay: String, passDeleteTag: Int) {
        SVProgressHUD.show()
        
        let alertController = UIAlertController(title: "Info", message: messageToDisplay, preferredStyle: .alert)
        alertController.view.tintColor = UIColor(red: 22/255, green: 16/255, blue: 21/255, alpha: 1.0)
        
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (action:UIAlertAction!) in
            print("OK")
            
            let listRecipeNameArrayTempRealm = self.realm.objects(RecipeNameArrayTempRealm.self)
            let listRecipeNameArrayRealm = self.realm.objects(RecipeNameArrayRealm.self)
            let listRecipePictureUIImageArrayTempRealm = self.realm.objects(RecipePictureUIImageArrayTempRealm.self)
            let listRecipePictureUIImageArrayRealm = self.realm.objects(RecipePictureUIImageArrayRealm.self)
            let listRecipeIngredientsArrayRealm = self.realm.objects(RecipeIngredientsArrayRealm.self)
            let listRecipeStepsArrayRealm = self.realm.objects(RecipeStepsArrayRealm.self)
            
            try! self.realm.write {
                self.realm.delete(listRecipeNameArrayTempRealm)
                self.realm.delete(listRecipeNameArrayRealm)
                self.realm.delete(listRecipePictureUIImageArrayTempRealm)
                self.realm.delete(listRecipePictureUIImageArrayRealm)
                self.realm.delete(listRecipeIngredientsArrayRealm)
                self.realm.delete(listRecipeStepsArrayRealm)
            }
            
            
            Global.recipeNameArray.remove(at: passDeleteTag)
            Global.recipeNameArrayTemp.remove(at: passDeleteTag)
            Global.recipePictureUIImageArray.remove(at: passDeleteTag)
            Global.recipePictureUIImageArrayTemp.remove(at: passDeleteTag)
            Global.recipeIngredientsArray.remove(at: passDeleteTag)
            Global.recipeStepsArray.remove(at: passDeleteTag)
            
            self.fullStack = Dictionary(zip(Global.recipeNameArray, Global.recipePictureUIImageArray), uniquingKeysWith: { (first, _) in first })
            
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
            
            Global.recipePictureUIImageArray.forEach { (item) in
                let eachFive = RecipePictureUIImageArrayRealm()
                let data = item.pngData() ?? Data()
                eachFive.recipePictureUIImageArray.append(data)
                try! self.realm.write {
                    self.realm.add(eachFive)
                }
            }
            
            Global.recipePictureUIImageArrayTemp.forEach { (item) in
                let eachSix = RecipePictureUIImageArrayTempRealm()
                let data = item.pngData() ?? Data()
                eachSix.recipePictureUIImageArrayTemp.append(data)
                try! self.realm.write {
                    self.realm.add(eachSix)
                }
            }
            
            self.tableView.reloadData()
        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) in
            print("Cancel")
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(Cancel)
        self.present(alertController, animated: true, completion:nil)
        SVProgressHUD.dismiss()
    }
    
}

extension HomeViewController: XMLParserDelegate{
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == "Menu" {
            recipeName = String()
            recipePictureURL = String()
            recipeIngredients = String()
            recipeSteps = String()
        }

        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        tableView.reloadData()
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == "Name" {
                Global.recipeNameArrayTemp.append(data)
                Global.recipeNameArray.append(data)
                
                let each = RecipeNameArrayRealm()
                let eachTwo = RecipeNameArrayTempRealm()
                each.recipeNameArray.append(data)
                eachTwo.recipeNameArrayTemp.append(data)
                
                try! self.realm.write {
                    self.realm.add(each)
                    self.realm.add(eachTwo)
                }
            } else if self.elementName == "PictureURL" {
                let imageUrlString = data
                let imageUrl = URL(string: imageUrlString)!
                let imageData = try! Data(contentsOf: imageUrl)
                let image = UIImage(data: imageData)
                Global.recipePictureUIImageArray.append(image ?? UIImage())
                Global.recipePictureUIImageArrayTemp.append(image ?? UIImage())
                
                let each = RecipePictureUIImageArrayRealm()
                let eachTwo = RecipePictureUIImageArrayTempRealm()
                each.recipePictureUIImageArray.append(imageData)
                eachTwo.recipePictureUIImageArrayTemp.append(imageData)
                
                try! self.realm.write {
                    self.realm.add(each)
                    self.realm.add(eachTwo)
                }
            }else if self.elementName == "Ingredients" {
                Global.recipeIngredientsArray.append(data)
                
                let each = RecipeIngredientsArrayRealm()
                each.recipeIngredientsArray.append(data)
                
                try! self.realm.write {
                    self.realm.add(each)
                }
            }else if self.elementName == "Steps" {
                Global.recipeStepsArray.append(data)
                
                let each = RecipeStepsArrayRealm()
                each.recipeStepsArray.append(data)
                
                try! self.realm.write {
                    self.realm.add(each)
                }
            }
        }
    }
    
    func toolBar(){
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolbar.setItems([spaceButton,spaceButton,doneButton], animated: false)

        searchTextField.inputAccessoryView = toolbar
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell

        cell.cellName.text = Global.recipeNameArray[indexPath.row]
        if Global.recipePictureUIImageArray.count == Global.recipeNameArray.count{
            cell.cellImages.image = Global.recipePictureUIImageArray[indexPath.row]
        }

        cell.cellDeleteBtn.tag = indexPath.row
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Global.recipeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeDetailsViewController") as! HomeDetailsViewController
        nextVC.checkBool = true
        nextVC.indexNumber = indexPath.row
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

extension HomeViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        Global.recipeNameArray.removeAll()
        Global.recipePictureUIImageArray.removeAll()
        
        if textField.text!.count == 0{
            Global.recipeNameArray = Global.recipeNameArrayTemp
            Global.recipePictureUIImageArray = Global.recipePictureUIImageArrayTemp
            tableView.reloadData()
        }else{
            fullStack.forEach { (item) in
                if item.key.localizedCaseInsensitiveContains(textField.text!){
                    Global.recipeNameArray.append(item.key)
                    Global.recipePictureUIImageArray.append(item.value)
                    tableView.reloadData()
                }
            }
        }
    }
}
