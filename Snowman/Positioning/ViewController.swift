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
        let sphere = SCNSphere(radius: 0.04)
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.05, 0.05, -0.05)
        sceneView.scene.rootNode.addChildNode(node)
        
        let middleSphere = SCNSphere(radius: 0.03)
        middleSphere.firstMaterial?.diffuse.contents = UIColor.blue
        let middleNode = SCNNode()
        middleNode.geometry = middleSphere
        middleNode.position = SCNVector3(0, 0.06, 0)
        node.addChildNode(middleNode)
        
        let topSphere = SCNSphere(radius: 0.02)
        topSphere.firstMaterial?.diffuse.contents = UIColor.white
        let topNode = SCNNode()
        topNode.geometry = topSphere
        topNode.position = SCNVector3(0, 0.04, 0)
        middleNode.addChildNode(topNode)
        
        let hatRim = SCNCylinder(radius: 0.03, height: 0.002)
        hatRim.firstMaterial?.diffuse.contents = UIColor.black
        let rimNode = SCNNode()
        rimNode.geometry = hatRim
        rimNode.position = SCNVector3(0, 0.016, 0)
        topNode.addChildNode(rimNode)
        
        let hatTop = SCNCylinder(radius: 0.015, height: 0.025)
        hatTop.firstMaterial?.diffuse.contents = UIColor.black
        let hatNode = SCNNode()
        hatNode.geometry = hatTop
        hatNode.position = SCNVector3(0, 0.01, 0)
        rimNode.addChildNode(hatNode)
        
    }

}

