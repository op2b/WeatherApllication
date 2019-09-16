import UIKit
import CoreLocation
import MapKit

class MainTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var addButtom: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var citysArray = [OfferModel?]()
    var timer = Timer()
    var weatherModel:[IdAttribute]?
    let locationManager: CLLocationManager = CLLocationManager()
    var offerModel:OfferModel?  {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citysArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomTableViewCell
        cell.cityLabel.text = citysArray[indexPath.row]?.name
        cell.tempLabel.text = ((citysArray[indexPath.row]?.main?.temp!.integerPart().description)!) + " \u{2103}"
        cell.imageView?.image = weatherIcon(stringIcon: (citysArray[indexPath.row]?.getWeatherID())!)
        
        return cell
    }
    
    
    @IBAction func addNewCity(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Add new City", message: "Enter your city", preferredStyle: .alert)
        
        alertController.addTextField { (cityTf) in
            cityTf.placeholder = "Enter your citys"
            
        }
        
        let alertControllerOk = UIAlertAction(title: "Ok", style: .default) { (action) in
            let city = alertController.textFields![0].text
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (timer) in
                if city != "" {
                    Manager.shared.getWeather(city: city!, result: { (model) in
                        self.offerModel = model
                        if model?.name != nil {
                            self.citysArray.append(model!)
                        } else {
                            let alertDinide = UIAlertController(title: "Somthing wrong...", message: "This city is not created", preferredStyle: .alert)
                            alertDinide.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                            self.present(alertDinide, animated: true, completion: nil)
                            
                        }
                    })
                }
            })
        }
        alertController.addAction(alertControllerOk)
        
        let alertCOntrollerCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(alertCOntrollerCancel)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func weatherIcon(stringIcon: String) -> UIImage {
        print(stringIcon)
        var imageName: String?
        
        switch stringIcon {
        case "01d": imageName = "01d"
        case "02d": imageName = "02d"
        case "03d": imageName = "03d"
        case "04d": imageName = "04d"
        case "09d": imageName = "09d"
        case "10d": imageName = "10d"
        case "11d": imageName = "11d"
        case "13d": imageName = "13d"
        case "50d": imageName = "50d"
        case "01n": imageName = "01n"
        case "02n": imageName = "02n"
        case "03n": imageName = "03n"
        case "04n": imageName = "04n"
        case "09n": imageName = "09n"
        case "10n": imageName = "10n"
        case "11n": imageName = "11n"
        case "13n": imageName = "13n"
        case "50n": imageName = "50n"
            
        default: imageName = "none"
        }
        
        let iconImage = UIImage(named: imageName!)
        return  iconImage!
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last! as CLLocation
        
        if(currentLocation.horizontalAccuracy > 0) {
            
            self.fetchCityAndCountry(from: currentLocation) { city, country, error in
                guard let city = city, let _ = country, error == nil else { return }
                DispatchQueue.main.async{
                    Manager.shared.getWeather(city: city) { (model) in
                        self.offerModel = model
                        if model?.name == city {
                            self.citysArray.append(model)
                        }
                    }
                }
            }
            
            locationManager.stopUpdatingLocation()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("we cant get him")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailsSegue" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                let currentCell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
                destinationVC.cityName = currentCell.cityLabel.text!
                destinationVC.temp = currentCell.tempLabel.text!
                destinationVC.icon = (tableView.cellForRow(at: indexPath)?.imageView!.image)!
            }
        }
        
    }
    
    
}

extension Float{
    func integerPart()->String{
        let result = floor(self).description.dropLast(2).description
        return result
    }
    func fractionalPart(_ withDecimalQty:Int = 2)->String{
        let valDecimal = self.truncatingRemainder(dividingBy: 1)
        let formatted = String(format: "%.\(withDecimalQty)f", valDecimal)
        return formatted.dropFirst(2).description
    }
}


