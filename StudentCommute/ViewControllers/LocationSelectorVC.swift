import MapKit

class LocationSelectorVC: UIViewController, MKMapViewDelegate, UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!

    var searchController: UISearchController!
    var searchCompleter: MKLocalSearchCompleter!
    var searchResults = [MKLocalSearchCompletion]()
    var selectedLocation: CLLocationCoordinate2D?
    var pinAnnotation: MKPointAnnotation?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        // Register the cell with the table view
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
      
        // Set the delegate for the map view
        mapView.delegate = self

        // Set up the search completer
        searchCompleter = MKLocalSearchCompleter()
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address

        // Set up the search controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search for location"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Add the map view's default annotation view
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
    }

    // Handle search bar text changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }

    
    // Handle search bar selection
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // Handle selecting a search result
    func selectSearchResult(_ result: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let placemark = response?.mapItems.first?.placemark else { return }
            self.selectedLocation = placemark.location?.coordinate

            // Remove any previous annotations
            if let annotation = self.pinAnnotation {
                self.mapView.removeAnnotation(annotation)
            }

            // Add a new annotation to the map
            let pin = MKPointAnnotation()
            pin.coordinate = placemark.coordinate
            self.pinAnnotation = pin
            self.mapView.addAnnotation(pin)

            // Zoom in to the selected location
            let region = MKCoordinateRegion(center: placemark.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            self.mapView.setRegion(region, animated: true)

            // Display location name in label
            self.locationLabel.text = placemark.name
        }
    }

    // Handle pin selection to display location name in text field
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let pin = view.annotation as? MKPointAnnotation else { return }
        let location = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else { return }
            self.locationLabel.text = placemark.name
        }
    }

    @IBAction func onSubmit(_ sender: Any) {
        
        if(locationLabel.text!.isEmpty) {
            showAlert(message: "Please add Location")
        }else {
            print("Location entered: \(locationLabel.text!)")
        }
      
      
    }
}



extension LocationSelectorVC: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
                tableView.reloadData()

                if searchResults.count > 0 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
       }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}


extension LocationSelectorVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        selectSearchResult(result)
        tableView.isHidden = true
    }
}
 



