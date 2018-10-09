

import UIKit

class LargeImageViewController: UIViewController, UIScrollViewDelegate {
    
    var tempURL : URL?
    var imageURL: URL? {
        didSet {
            largeImageView.image = nil
            if view.window != nil {
                fetchImage(to: self)
            }
        }
    }
    
    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var largeImageScrollView: UIScrollView! {
        didSet {
            largeImageScrollView.minimumZoomScale = 1/25
            largeImageScrollView.maximumZoomScale = 5
            largeImageScrollView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageURL = tempURL
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if largeImageView.image == nil {
            fetchImage(to: self)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return largeImageView
    }
    
}
