//
//  ViewController.swift
//  FurnitureApp
//
//  Created by Mohammad Azam on 3/2/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    private var hud : MBProgressHUD!
    private var newAngleY : Float = 0.0
    private var currentAngleY : Float = 0.0
    private var localTranslatePosition: CGPoint!
    var selectedBuilding: String!
    
    let rootScene = SCNScene()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedBuilding)
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.hud = MBProgressHUD.showAdded(to: self.sceneView, animated: true)
        self.hud.label.text = "Detecting Plane..."
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set the scene to the view
        sceneView.scene = rootScene
        
        registerGestureRecognizers()
        selectedBuilding = "Medival_Building.DAE"
    }
    override func viewDidAppear(_ animated: Bool) {
        let button = UIButton()
        button.frame = CGRect(x: 20, y: self.view.frame.size.height - 100, width: 75, height: 75)
        // button.layer.cornerRadius = button.layer.borderWidth / 2
        // button.backgroundColor = UIColor.red
        button.setImage(UIImage(named:"Medival_Building.DAE"), for: .normal)
        button.setTitle("Medival", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        
        
        let button2 = UIButton()
        button2.frame = CGRect(x: 120, y: self.view.frame.size.height - 100, width: 75, height: 75)
        // button2.layer.cornerRadius = button.layer.borderWidth / 2
        // button2.backgroundColor = UIColor.red
        button2.setImage(UIImage(named:"hotel"), for: .normal)
        button2.setTitle("hotel", for: .normal)
        button2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        self.view.addSubview(button2)
    }
    @objc func buttonAction(sender: UIButton!) {
        selectedBuilding = "Medival_Building.DAE"
    }
    @objc func buttonAction2(sender: UIButton!) {
        selectedBuilding = "hotel.dae"
    }
    
    
    
    
    private func registerGestureRecognizers(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinched))
        self.sceneView.addGestureRecognizer(pinchGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panned))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(moved))
        self.sceneView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    /*
     @objc func moved(recognizer :UILongPressGestureRecognizer) {
     guard let recognizerView = recognizer.view as? ARSCNView else {
     return
     }
     
     let touch = recognizer.location(in: recognizerView)
     let hitTestResult = self.sceneView.hitTest(touch, options: nil)
     
     if let hitTest = hitTestResult.first {
     guard let houseNode = hitTest.node.parent else { return }
     
     if recognizer.state == .began {
     self.localTranslatePosition = touch
     houseNode.opacity = 0.5
     
     } else if recognizer.state == .changed {
     let deltaX = Float(touch.x - self.localTranslatePosition.x) / 300
     let deltaY = Float(touch.y - self.localTranslatePosition.y) / 300
     
     houseNode.localTranslate(by: SCNVector3(deltaX, 0.0, deltaY))
     self.localTranslatePosition = touch
     } else if recognizer.state == .ended {
     houseNode.opacity = 1.0
     
     }
     }
     }
     */
    
    @objc func moved(recognizer :UILongPressGestureRecognizer) {
        
        guard let recognizerView = recognizer.view as? ARSCNView else { return }
        let touch = recognizer.location(in: recognizerView)
        
        let hitTestResults = self.sceneView.hitTest(touch, options: nil)
        if let hitTest = hitTestResults.first {     //If house pressed
            if let houseNode = hitTest.node.parent { //set pressed house as active node
                
                if recognizer.state == .began {
                    houseNode.opacity = 0.5
                    
                }else if recognizer.state == .changed {
                    // perform continious hitTests of featurePoints and change houseNode position
                    
                    let hitTestFeaturePoints = self.sceneView.hitTest(touch, types: .featurePoint)
                    if let featurePointHit = hitTestFeaturePoints.first{
                        houseNode.position = SCNVector3(featurePointHit.worldTransform.columns.3.x,houseNode.position.y,featurePointHit.worldTransform.columns.3.z)
                    }
                    
                }else if recognizer.state == .ended {
                    houseNode.opacity = 1.0
                }
                houseNode.opacity = 1.0
            }
            
        }
        
    }
    
    
    
    @objc func panned(recognizer :UIPanGestureRecognizer) {
        if recognizer.state == .changed {
            guard let recognizerView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: recognizerView)
            let translation = recognizer.translation(in: recognizerView)
            
            let hitTestResult = self.sceneView.hitTest(touch, options: nil)
            if let hitTest = hitTestResult.first {
                guard let houseNode = hitTest.node.parent else { return }
                self.newAngleY = Float(translation.x) * (Float) (Double.pi) / 180
                self.newAngleY += self.currentAngleY
                houseNode.eulerAngles.y = self.newAngleY
            }
        } else if recognizer.state == .ended {
            self.currentAngleY = self.newAngleY
        }
    }
    
    @objc func tapped(recognizer :UITapGestureRecognizer) {
        
        guard let recognizerView = recognizer.view as? ARSCNView else {
            return
        }
        let touch = recognizer.location(in: recognizerView)
        
        let hitTestResults = recognizerView.hitTest(touch, types: .existingPlane)
        if let hitTest = hitTestResults.first {
            guard let buildingScene = SCNScene(named: "art.scnassets/" + selectedBuilding ) else { return }
            print(buildingScene)
            let buildingNode = SCNNode()
            for buildingPart in buildingScene.rootNode.childNodes {
                buildingNode.addChildNode(buildingPart)
            }
            buildingNode.position = SCNVector3(hitTest.worldTransform.columns.3.x,  hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
            
            switch selectedBuilding{
            case "Medival_Building.DAE":
                buildingNode.scale = SCNVector3(0.1, 0.1, 0.1)
            case "hotel.dae":
                buildingNode.scale = SCNVector3(0.02, 0.02, 0.02)
            default:
                buildingNode.scale = SCNVector3(1, 1, 1)
                
            }
            
            rootScene.rootNode.addChildNode(buildingNode)
        }
        
    }
    
    @objc func pinched(recognizer :UIPinchGestureRecognizer) {
        
        if recognizer.state == .changed {
            guard let recognizerView = recognizer.view as? ARSCNView else {
                return
            }
            
            let touch = recognizer.location(in: recognizerView)
            let hitTestResult = self.sceneView.hitTest(touch, options: nil)
            
            if let hitTest = hitTestResult.first {
                guard let houseNode = hitTest.node.parent else { return }
                let pinchScaleX = Float(recognizer.scale) * houseNode.scale.x
                let pinchScaleY = Float(recognizer.scale) * houseNode.scale.y
                let pinchScaleZ = Float(recognizer.scale) * houseNode.scale.z
                
                houseNode.scale = SCNVector3(x: pinchScaleX, y: pinchScaleY, z: pinchScaleZ)
                
                recognizer.scale = 1
            }
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor {
            
            DispatchQueue.main.async {
                self.hud.label.text = "Plane Detected!"
                self.hud.hide(animated: true, afterDelay: 1.0)
            }
            
            // Add a plane
            let plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
            plane.materials.first?.diffuse.contents = UIColor.red.withAlphaComponent(0)
            
            let planeNode = SCNNode(geometry: plane)
            
            planeNode.position = SCNVector3(CGFloat(anchor.center.x), CGFloat(anchor.center.y), CGFloat(anchor.center.z))
            planeNode.eulerAngles.x = -.pi / 2
            
            rootScene.rootNode.addChildNode(planeNode)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
}

