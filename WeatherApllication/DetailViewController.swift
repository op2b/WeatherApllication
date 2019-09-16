
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var cityName = ""
    var icon = UIImage()
    var temp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = cityName
        imageLabel.image = icon
        tempLabel.text = temp
        
    }
    
    
    
}
