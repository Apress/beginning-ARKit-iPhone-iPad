//
//  ViewController.swift
//  PlacingObjects
//
//  Created by Wallace Wang on 8/15/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        configuration.planeDetection = .vertical
        
        sceneView.session.run(configuration)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapResponse))
        sceneView.addGestureRecognizer(tapGesture)
        
    }

    @objc func tapResponse(sender: UITapGestureRecognizer) {
        let scene = sender.view as! ARSCNView
        let tapLocation = sender.location(in: scene)
        let hitTest = scene.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if hitTest.isEmpty{
            print ("no plane detected")
        } else {
            print("found a vertical plane")
            guard let hitResult = hitTest.first else { return }
            addObject(hitResult: hitResult)
        }
    }
    
    func addObject(hitResult: ARHitTestResult) {
        let objectNode = SCNNode()
        objectNode.geometry = SCNPlane(width: 0.3, height: 0.3)
        objectNode.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "Mona_Lisa.jpg")

        objectNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(objectNode)
    }

}

