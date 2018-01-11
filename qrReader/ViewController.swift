//
//  ViewController.swift
//  qrReader
//
//  Created by Romain on 09/01/2018.
//  Copyright © 2018 Romain. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
	@IBOutlet weak var mainLabel: UILabel!
	
    
	override func viewDidLoad() {
		super.viewDidLoad()
		sceneView.delegate = self
		
		//timer calls the vision function 10 times per second
		_ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
			
			//change to self.detectFace() if you want to detect face landmarks
			self.detectQR()
		})
	}
	
	
////////////////////    VISION     /////////////////////////////
	
	//QR CODE DETECTION
	
	func detectQR() {
		//image
		guard let image = sceneView.session.currentFrame?.capturedImage else {return}
		//request
		let request = VNDetectBarcodesRequest { (request, error) in
			//result
			guard let barcode = request.results?.first as? VNBarcodeObservation else {return}
			self.mainLabel.text = barcode.payloadStringValue
		}
		//handler
		let handler = VNImageRequestHandler(cvPixelBuffer: image, options: [ : ])
		guard let _ = try? handler.perform([request]) else {return}
	}
	
	
	//FACE LANDMARKS DETECTION

	func detectFace() {
		guard let image = sceneView.session.currentFrame?.capturedImage else {return}
		let request = VNDetectFaceLandmarksRequest { (request, error) in
			guard let result = request.results?.first as? VNFaceObservation else {return}
			print(result.landmarks?.nose?.normalizedPoints)
		}
		let handler = VNImageRequestHandler(cvPixelBuffer: image, options: [ : ])
		guard let _ = try? handler.perform([request]) else {return}
	}
	
	
////////////////////    END OF VISION     /////////////////////////////
	
	
	
	
	//App lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
	
}
