import UIKit
import FlickrKit

class LogAndSearchViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var labelLoged: UILabel!
    @IBOutlet weak var labelSetNumber: UILabel!
    @IBOutlet weak var buttonSCollection: UIButton!
    @IBOutlet weak var buttonSMy: UIButton!
    @IBOutlet weak var buttonSNice: UIButton!
    @IBOutlet weak var photoStreamButton: UIButton!
    @IBOutlet weak  var searchTextField: UITextField!
    @IBOutlet weak var searchSlider: UISlider!
    @IBOutlet weak var numberOfImagesLabel: UILabel!
    @IBOutlet weak var searchTextFieldBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var searchSwitch: UISwitch!
    
    
    static var numberOfImages = Int()
    static var tagValue : String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoURLs = []
        largePhotoURLs = []
        
        searchTextField.delegate = self
        
        searchSwitch.isOn = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayuot), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayuot), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchSlider.value = Float(defaults.integer(forKey: "numberOfImage"))
        LogAndSearchViewController.numberOfImages = Int(searchSlider.value)
        numberOfImagesLabel.text = String(LogAndSearchViewController.numberOfImages)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        LogAndSearchViewController.numberOfImages = Int(sender.value)
        numberOfImagesLabel.text = String(LogAndSearchViewController.numberOfImages)
        defaults.set(Int(sender.value), forKey: "numberOfImage")
        
    }
    
    @IBAction func photostreamButtonPressed(_ sender: AnyObject) {
        if searchSwitch.isOn {
            searchNewURLs(forText: self.searchTextField.text!, completion: performSegueToCollection)
        } else {
            searchNewURLs(forText: self.searchTextField.text!, completion: {})
        }
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Update Layout for Keyboard 
    
    @objc func updateLayuot (param: Notification){
        let userInfo = param.userInfo
        let keyboardRect = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardFrame = self.view.convert(keyboardRect, to: view.window)
        
        if param.name == Notification.Name.UIKeyboardWillShow {
            if searchTextFieldBottomMargin.constant < keyboardFrame.height {
                searchTextFieldBottomMargin.constant = keyboardFrame.height
                print(searchTextFieldBottomMargin.constant)
            }
        } else {
            searchTextFieldBottomMargin.constant = 150
        }
    }
    
    
    // MARK: ? Search/Search and Go
    
    @IBAction func searchSwitchChanged(_ sender: UISwitch) {
        if searchSwitch.isOn {
            photoStreamButton.setTitle("Search and Go", for: .normal)
        } else {
            photoStreamButton.setTitle("Search", for: .normal)
        }
    }
    
    
    // MARK: Perform Segues
    
    func performSegueToCollection() {
        performSegue(withIdentifier: "segueToCollection", sender: nil)
    }
    
    
    // MARK: Prepare for Segues
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        self.searchTextField.resignFirstResponder()
        if (segue.identifier == "SegueToFavourites") {
            //let favoritsVC: FavouritesViewController = segue.destination as! FavouritesViewController
           // favoritsVC.photoURLs = photoURLs
        }
        if (segue.identifier == "SegueToMyCells") {
        }
    }
    
    
    // MARK: Save and Exit
    
    @IBAction func saveAndExit(_ sender: Any) {
        updateDefaults()
    }
    
    
    
}


