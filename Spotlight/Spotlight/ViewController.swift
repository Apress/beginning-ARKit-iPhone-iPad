//
//  ViewController.swift
//  Spotlight
//
//  Created by Wallace Wang on 7/17/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    let showLight = SCNNode()
    var currentX : Float = 0
    var currentY : Float = 0
    var currentZ : Float = 0
    
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
        let plane = SCNPlane(width: 0.75, height: 0.75)
        plane.firstMaterial?.diffuse.contents = UIColor.yellow
        
        let node = SCNNode()
        node.geometry = plane
        node.position = SCNVector3(0, 0, -0.3)
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func lightOn() {
        showLight.light = SCNLight()
        showLight.light?.type = .spot
        showLight.light?.color = UIColor(white: 0.6, alpha: 1.0)
        showLight.position = SCNVector3(0, 0, 0)
        showLight.eulerAngles = SCNVector3(0, 0, 0)

        sceneView.scene.rootNode.addChildNode(showLight)
    }
    

    @IBAction func pitchChanged(_ sender: UISlider) {
        currentX = GLKMathDegreesToRadians(sender.value)
        showLight.eulerAngles = SCNVector3(currentX, currentY, currentZ)
    }
    
    @IBAction func yawChanged(_ sender: UISlider) {
        currentY = GLKMathDegreesToRadians(sender.value)
        showLight.eulerAngles = SCNVector3(currentX, GLKMathDegreesToRadians(sender.value), currentZ)
    }
    
    @IBAction func rollChanged(_ sender: UISlider) {
        currentZ = GLKMathDegreesToRadians(sender.value)
        showLight.eulerAngles = SCNVector3(currentX, currentY, currentZ)
    }
    
    
}

