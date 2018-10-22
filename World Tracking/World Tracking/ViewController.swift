//
//  ViewController.swift
//  World Tracking
//
//  Created by Wallace Wang on 7/2/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
     let configuration = ARWorldTrackingConfiguration()
    
    @IBAction func resetButton(_ sender: UIButton) {
        sceneView.session.pause()
        sceneView.session.run(configuration, options: [.resetTracking])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        sceneView.session.run(configuration)
    }
    
}

