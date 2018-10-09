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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoURLs = []
        largePhotoURLs = []
        searchTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayuot), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLayuot), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        numberOfImages = Int(searchSlider.value)
        numberOfImagesLabel.text = String(numberOfImages)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        numberOfImages = Int(sender.value)
        numberOfImagesLabel.text = String(numberOfImages)
    }
    
    @IBAction func photostreamButtonPressed(_ sender: AnyObject) {
        searchNewURLs(forText: self.searchTextField.text!, andSegueFromVC: self, bySegueIdent: "segueToCollection")
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
    
    
    // MARK: Prepare for Segues
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        self.searchTextField.resignFirstResponder()
        if (segue.identifier == "SegueToPhotos") {
            let photosVC: PhotosViewController = segue.destination as! PhotosViewController
            photosVC.photoURLs = photoURLs
        }
        if (segue.identifier == "SegueToMyCells") {
        }
    }
    
    
}


