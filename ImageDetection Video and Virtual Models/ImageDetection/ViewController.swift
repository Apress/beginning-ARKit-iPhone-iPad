//
//  ViewController.swift
//  ImageDetection
//
//  Created by Wallace Wang on 8/22/18.
//  Copyright © 2018 Wallace Wang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate  {
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    struct Images {
        var title: String
        var info: String
    }
    
    var imageArray: [Images] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        sceneView.delegate = self
        
        guard let storedImages =  ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing AR Resources images")
        }
        
        configuration.detectionImages = storedImages
        
        getData()
        
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }

        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor.clear
        
        let planeNode = SCNNode()
        planeNode.geometry = plane
        
        let ninetyDegrees = GLKMathDegreesToRadians(-90)
        planeNode.eulerAngles = SCNVector3(ninetyDegrees, 0, 0)
        
        switch imageAnchor.referenceImage.name {
        case "CRS-15":
            print("1st image")
            let item = SCNScene(named: "ship.scn")
            let itemNode = item?.rootNode.childNode(withName: "ship", recursively: true)
            
            let rotateMe = SCNAction.rotateBy(x: 0.5, y: 0.1, z: 0.2, duration: 1)
            let repeatMe = SCNAction.repeatForever(rotateMe)
            itemNode?.runAction(repeatMe)
            
            itemNode?.position = SCNVector3(anchor.transform.columns.3.x, anchor.transform.columns.3.y,anchor.transform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(itemNode!)
        case "SaturnV":
            print("2nd image")
            
            guard let currentFrame = sceneView.session.currentFrame else { return nil }
            
            let videoNode = SKVideoNode(fileNamed: "SaturnV.mov")
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 640, height: 480))
            videoScene.scaleMode = .aspectFit
            videoScene.addChild(videoNode)
            
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)

            let videoPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            videoPlane.firstMaterial?.diffuse.contents = videoScene
 
            videoPlane.firstMaterial?.isDoubleSided = true

            let tvPlaneNode = SCNNode(geometry: videoPlane)
            
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -1.0

            tvPlaneNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
            tvPlaneNode.eulerAngles = SCNVector3(Double.pi, 0, 0)
            
            tvPlaneNode.position = SCNVector3(0,0,0)
            planeNode.addChildNode(tvPlaneNode)
            
        default:
            print("Nothing found")
        }
        
        let node = SCNNode()
        node.addChildNode(planeNode)
        
        return node
    }
    
    func getData() {
        let item1 = Images(title: "CRS-15 SpaceX rocket", info: "Commercial Resupply Service")
        let item2 = Images(title: "Saturn V rocket", info: "Apollo moon launch vehicle")
        
        imageArray.append(item1)
        imageArray.append(item2)
    }
    
}

