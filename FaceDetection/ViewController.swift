//
//  ViewController.swift
//  FaceDetection
//
//  Created by Danilo Requena on 28/07/19.
//  Copyright © 2019 Danilo Requena. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let image = UIImage(named: "sample1") else { return }
        let imageView = UIImageView(image: image)
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
        
        imageView.backgroundColor = .blue
        
        view.addSubview(imageView)
        
        let request = VNDetectRectanglesRequest { (req, err) in
            if let err = err {
                print("Failed to detect Faces:", err)
                return
            }
            
            req.results?.forEach({ (res) in
                print(res)
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    let height = scaledHeight * faceObservation.boundingBox.height
                    let y  = scaledHeight  * (1 - faceObservation.boundingBox.height) - height
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                    
                    print(faceObservation.boundingBox)
                }
                
            })
        }
    
        guard let cgImage = image.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do{
                try handler.perform([request])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
            
        }
    }
        


}

