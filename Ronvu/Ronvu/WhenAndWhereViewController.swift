//
//  WhenAndWhereViewController.swift
//  Ronvu
//
//  Created by Jessica Gillan on 7/25/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import UIKit
import MapKit

class WhenAndWhereViewController: UIViewController {
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var ronvu: Ronvu!
    
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
        locationTitleLabel.text = ronvu.locationTitle
        if let date = ronvu.dateOfRonvu {
           dateAndTimeLabel.text = date.asRonvuString
        }
        
        // FIXME: Remove Address altogether and just have location title? Show map if have coordinates.
        // add new line chars so it doesnt make map too small in compact height 
        if let address = ronvu.locationAddress {
            addressLabel.text = address
        } else {
            addressLabel.text = ""
            mapView.hidden = true
        }
        
        if let lat = ronvu.locationLat {
            if let long = ronvu.locationLong {
                mapView.delegate = self
                let location = CLLocation(latitude: lat, longitude: long)
                centerMapOnLocation(location)
                let annotation = LocationAnnotation(title: ronvu.locationTitle, address: ronvu.locationAddress, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
                mapView.addAnnotation(annotation)
            } else {
                mapView.hidden = true
            }
        } else { // FIXME: remove test code
            // mapView.hidden = true
            let lat = 21.4
            let long = -157.929444
            mapView.delegate = self
            let location = CLLocation(latitude: lat, longitude: long)
            centerMapOnLocation(location)
            let annotation = LocationAnnotation(title: ronvu.locationTitle, address: ronvu.locationAddress, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: long))
            mapView.addAnnotation(annotation)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension WhenAndWhereViewController: MKMapViewDelegate
{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? LocationAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! LocationAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMapsWithLaunchOptions(launchOptions)
    }
}
