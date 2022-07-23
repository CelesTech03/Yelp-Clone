//
//  DetailViewController.swift
//  Yelpy
//

import UIKit
import AlamofireImage
import MapKit

class RestaurantDetailViewController: UIViewController, MKMapViewDelegate, PostImageViewControllerDelegate {
    
    // Configure outlets
    // NOTE: Make sure to set images to "Content Mode: Aspect Fill" on the
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    
    // Connect MapView + Add annotation view
    @IBOutlet weak var mapView: MKMapView!
    var annotationView: MKAnnotationView!
    
    // Initialize restaurant variable
    var r: Restaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureOutlets()
        // 11) purposely wait until last minute to configure this to explain to students delegation!
        // step 10) is running the app
        mapView.delegate = self
    }
    
    // Add image to MapView Annotation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostImageVC" {
            let postImageVC = segue.destination as! PostImageViewController
            // NOTE: PLEASE FOLLOW LAB BEFORE ASKING FOR HELP ON THIS
            postImageVC.delegate = self
        }
    }
    
    // Configure outlets
    func configureOutlets() {
        nameLabel.text = r.name
        reviewsLabel.text = String(r.reviews)
        starImage.image = Stars.dict[r.rating]!
        headerImage.af.setImage(withURL: r.imageURL!)
        
        // Extra: Add tint opacity to image to make text stand out
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.3) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: headerImage.frame.width, height: headerImage.frame.height)
        
        headerImage.addSubview(tintView)
        
        // Set region for map to be coordinates of restaurant
        // get longitude and latitude from coordinates property
        let latitude = r.coordinates["latitude"]!
        let longitude = r.coordinates["longitude"]!
        
        // test coordinates are being printed
        
        // 2) initialize coordinate point for restaurant
        let locationCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees.init(latitude), CLLocationDegrees.init(longitude))
        
        // 3) initialize region object using restaurant's coordinates
        let restaurantRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(latitude, longitude), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        // 4) set region in mapView to be that of restaurants
        mapView.setRegion(restaurantRegion, animated: true)
        
        // 5) instantiate annotation object to show pin on map
        let annotation = MKPointAnnotation()
        
        // 6) set annotation's properties
        annotation.coordinate = locationCoordinate
        annotation.title = r.name
        
        // 7) drop pin on map using restaurant's coordinates
        mapView.addAnnotation(annotation)
        
    }
    
    // MARK: 8) Configure annotation view using protocol method
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "myAnnotationView"
        print("mapView protocol called!")
        self.annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil){
            // MARK: USE MKPinAnnotationView and NOT MKAnnotationView
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
            // 9) Add info button to annotation view
            let annotationViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            annotationViewButton.setImage(UIImage(named: "camera"), for: .normal)
            annotationView?.leftCalloutAccessoryView = annotationViewButton
        }
        return annotationView
    }
    
    // MARK: 12) action to execute when user taps annotation views accessory buttons
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // 14) performSegue to PostImageVC
        self.performSegue(withIdentifier: "toPostImageVC", sender: nil)
    }
    
    // MARK: 19) Conform to PostImageViewDelegate protocol
    func imageSelected(controller: PostImageViewController, image: UIImage) {
        // 9) Add info button to annotation view
        let annotationViewButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        annotationViewButton.setImage(image, for: .normal)
        self.annotationView?.leftCalloutAccessoryView = annotationViewButton
    }
    
    // Unwind segue after user finishes uploading image for map annotation
    @IBAction func unwind(_ seg: UIStoryboardSegue) {
        
    }
}
