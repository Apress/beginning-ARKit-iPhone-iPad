//
//  ViewController.swift
//  RotatePinch
//
//  Created by Wallace Wang on 8/6/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var newAngleZ : Float = 0.0
    var currentAngleZ : Float = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    @IBAction func pinchGesture(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .changed {
            let areaPinched = sender.view as? SCNView
            let location = sender.location(in: areaPinched)
            let hitTestResults = sceneView.hitTest(location, options: nil)
            
            if let hitTest = hitTestResults.first {
                let plane = hitTest.node
                
                let scaleX = Float(sender.scale) * plane.scale.x
                let scaleY = Float(sender.scale) * plane.scale.y
                let scaleZ = Float(sender.scale) * plane.scale.z
                
                plane.scale = SCNVector3(scaleX, scaleY, scaleZ)
                
                sender.scale = 1
            }
        }
    }
    
    @IBAction func rotationGesture(_ sender: UIRotationGestureRecognizer) {
        if sender.state == .changed {
            let areaTouched = sender.view as? SCNView
            let location = sender.location(in: areaTouched)

            let hitTestResults = sceneView.hitTest(location, options: nil)
            
            if let hitTest = hitTestResults.first {
                let plane = hitTest.node
                newAngleZ = Float(-sender.rotation)
                newAngleZ += currentAngleZ
                plane.eulerAngles.z = newAngleZ
            }
        } else if sender.state == .ended {
                currentAngleZ = newAngleZ
        }
    }
    
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        let areaPanned = sender.view as? SCNView
        let location = sender.location(in: areaPanned)
        let hitTestResults = areaPanned?.hitTest(location, options: nil)
        
        if let hitTest = hitTestResults?.first {
            if let plane = hitTest.node.parent {
                if sender.state == .changed {
                    let translate = sender.translation(in: areaPanned)
                    plane.localTranslate(by: SCNVector3(translate.x/8000,-translate.y/8000,0.0))
                 }
            }
        }
    }
}
