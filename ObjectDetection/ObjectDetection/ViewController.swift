//
//  ViewController.swift
//  ObjectDetection
//
//  Created by Wallace Wang on 9/6/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate{

    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        
        guard let storedObjects =  ARReferenceObject.referenceObjects(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing AR Resources images")
        }
        
        configuration.detectionObjects = storedObjects
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let objectAnchor = anchor as? ARObjectAnchor {
            let movingImage = SCNText(string: "Object Detected", extrusionDepth: 0.0)
            movingImage.flatness = 0.1
            movingImage.font = UIFont.boldSystemFont(ofSize: 10)
            
            let titleNode = SCNNode()
            titleNode.geometry = movingImage
            titleNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            titleNode.scale = SCNVector3(0.0015, 0.0015, 0.0015)
            
            node.addChildNode(titleNode)
        }
    }

}

