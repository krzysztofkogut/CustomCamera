//
//  PreviewViewController.swift
//  CustomCamera
//
//  Created by Kris on 11/02/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import UIKit
import CoreLocation

class PreviewViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var photoDimensionsLabel: UILabel!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    var image:UIImage?
    var location:CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = image
        
        // Getting the height and width of UIImage
        let heightInPoints = image!.size.height
        let heightInPixels = heightInPoints * image!.scale
        let widthInPoints = image!.size.width
        let widthInPixels = widthInPoints * image!.scale
        
        photoDimensionsLabel.text = "\(heightInPixels) x \(widthInPixels)"
        
        let lat = location!.coordinate.latitude
        let lon = location!.coordinate.longitude
        
        coordinatesLabel.text = "\(lat), \(lon)"
    }
    
    // Save photo to the library and send JSON data to the server
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        guard let imageToSave = image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        dismiss(animated: true, completion: nil)
        
        let parameters: [String: String] = ["dimensions": photoDimensionsLabel.text ?? "0 x 0", "coordinates": coordinatesLabel.text ?? "0.0, 0.0"]
        
        // Create the url with URL
        let url = URL(string: "https://customcamera.requestcatcher.com/test")!
        
        let session = URLSession.shared
        
        // Create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

        } catch let error {
            print(error.localizedDescription)
        }

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                return
            }

            guard let data = data else {
                return
            }

            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }

            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    @IBAction func closeBtn_TouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

