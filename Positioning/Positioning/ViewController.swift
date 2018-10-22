//
//  ViewController.swift
//  Positioning
//
//  Created by Wallace Wang on 7/20/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate  {

    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        showShape()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(configuration)
    }
    
    func showShape() {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = UIColor.orange
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)
        box.firstMaterial?.diffuse.contents = UIColor.green
        let boxNode = SCNNode()
        boxNode.geometry = box
        // boxNode.position = SCNVector3(-0.2, -0.2, 0.1) //0.4 meters to the left (the x-axis), 0.3 meters lower (the y-axis), and 0.2 meters in front (the z-axis)
        // sceneView.scene.rootNode.addChildNode(boxNode)
        boxNode.position = SCNVector3(-0.4, -0.3, 0.2)
        
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.2, 0.1, -0.1)
        sceneView.scene.rootNode.addChildNode(node)
        
        node.addChildNode(boxNode)
    }

}

