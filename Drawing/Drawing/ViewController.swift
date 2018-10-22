//
//  ViewController.swift
//  Drawing
//
//  Created by Wallace Wang on 7/28/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var switchDraw: UISwitch!
    @IBOutlet var clearButton: UIButton!
    
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(configuration)
    }
   
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pov = sceneView.pointOfView else {return}
        let transform = pov.transform
        
        let rotation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPosition = SCNVector3(rotation.x + location.x, rotation.y + location.y, rotation.z + location.z)
        
        DispatchQueue.main.async {
            if self.switchDraw.isOn {
                let drawNode = SCNNode()
                drawNode.geometry = SCNSphere(radius: 0.01)
                drawNode.geometry?.firstMaterial?.diffuse.contents = UIColor.green
                drawNode.position = currentPosition
                self.sceneView.scene.rootNode.addChildNode(drawNode)
                
            } else {
                let point = SCNNode()
                point.name = "aiming point"
                point.geometry = SCNSphere(radius: 0.005)
                point.position = currentPosition
                point.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "aiming point" {
                        node.removeFromParentNode()
                    }
                })
                
                self.sceneView.scene.rootNode.addChildNode(point)
            }
            if self.clearButton.isHighlighted {
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    node.removeFromParentNode()
                })
            }
            
        }
    }
}

