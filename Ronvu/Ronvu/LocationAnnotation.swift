//
//  LocationAnnotation.swift
//  Ronvu
//
//  Created by Jessica Gillan on 7/26/16.
//  Copyright © 2016 JGilly. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class LocationAnnotation: NSObject, MKAnnotation

{
    let title: String?
    let address: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, address: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.address = address
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return address
    }
    
    // annotation callout info button opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDictionary = [String(CNPostalAddressStreetKey): subtitle as! AnyObject]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        
        return mapItem
    }
}