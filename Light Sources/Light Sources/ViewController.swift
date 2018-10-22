//
//  ViewController.swift
//  Light Sources
//
//  Created by Wallace Wang on 7/14/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    let showLight = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showShape()
        lightOn()
        sceneView.session.run(configuration)
    }

    func showShape() {
        let sphere = SCNSphere(radius: 0.03)
        sphere.firstMaterial?.diffuse.contents = UIColor.white
        
        let node = SCNNode()
        node.geometry = sphere
        node.position = SCNVector3(0.1, 0, 0)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func lightOn() {
        showLight.light = SCNLight()
        showLight.light?.type = .omni
        showLight.light?.color = UIColor(white: 0.6, alpha: 1.0)
        showLight.position = SCNVector3(0,0,0)
        
//        showLight.light?.type = .spot
//        showLight.position = SCNVector3(0.05, 0, 0.1)
//         showLight.eulerAngles = SCNVector3(0, GLKMathDegreesToRadians(-10), 0)
        
        sceneView.scene.rootNode.addChildNode(showLight)
    }
    
    
    @IBAction func temperatureChange(_ sender: UISlider) {
        showLight.light?.temperature = CGFloat(sender.value)
    }
    
    @IBAction func intensityChange(_ sender: UISlider) {
        showLight.light?.intensity = CGFloat(sender.value)
    }
    
    @IBAction func colorButton(_ sender: UIButton) {
         showLight.light?.color = sender.backgroundColor!
    }
}

