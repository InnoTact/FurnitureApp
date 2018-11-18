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
    let removeButton = UIButton()
    
    let button1 = UIButton()
    let button2 = UIButton()
    let button3 = UIButton()
    let button4 = UIButton()
    var buttonList =  [UIButton()]
    var Button1Constraint : NSLayoutConstraint!
    var Button2Constraint : NSLayoutConstraint!
    var Button3Constraint : NSLayoutConstraint!
    var Button4Constraint : NSLayoutConstraint!
    private var hud : MBProgressHUD!
    private var newAngleY : Float = 0.0
    private var currentAngleY : Float = 0.0
    private var localTranslatePosition: CGPoint!
    private var adding = true
    var selectedBuilding: String!
    let rootScene = SCNScene()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //self.view.layoutIfNeeded()
        Button1Constraint = NSLayoutConstraint(item: button1, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 0)
        Button2Constraint = NSLayoutConstraint(item: button2, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 0)
        Button3Constraint = NSLayoutConstraint(item: button3, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 0)
        Button4Constraint = NSLayoutConstraint(item: button4, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 0)
        
        
        let screenWidth: CGFloat = self.view.frame.size.width
        let screenHeight: CGFloat = self.view.frame.size.height
        let buttonWidth: CGFloat = 70
        let buttonHeight: CGFloat = 70
        let offSet: CGFloat = screenWidth / 25
        
        button1.frame = CGRect(x: offSet, y: self.view.frame.size.height - 100 + Button1Constraint.constant, width: buttonWidth, height: buttonHeight)
        // button.layer.cornerRadius = button.layer.borderWidth / 2
        // button.backgroundColor = UIColor.red
        button1.setImage(UIImage(named:"Medival_Building.DAE"), for: .normal)
        button1.setTitle("Medival", for: .normal)
        button1.addTarget(self, action: #selector(buttonAction1), for: .touchUpInside)
        self.view.addSubview(button1)
        
        button2.frame = CGRect(x: 2*offSet + buttonWidth, y: self.view.frame.size.height - 100 + Button2Constraint.constant , width: buttonWidth, height: buttonHeight)
        // button2.layer.cornerRadius = button.layer.borderWidth / 2
        // button2.backgroundColor = UIColor.red
        button2.setImage(UIImage(named:"hotel"), for: .normal)
        button2.setTitle("hotel", for: .normal)
        button2.addTarget(self, action: #selector(buttonAction2), for: .touchUpInside)
        self.view.addSubview(button2)
        
        button3.frame = CGRect(x: 3*offSet + 2*buttonWidth, y: self.view.frame.size.height - 100 + Button3Constraint.constant, width: buttonWidth, height: buttonHeight)
        // button2.layer.cornerRadius = button.layer.borderWidth / 2
        // button2.backgroundColor = UIColor.red
        button3.setImage(UIImage(named:"spooky"), for: .normal)
        button3.setTitle("spooky", for: .normal)
        button3.addTarget(self, action: #selector(buttonAction3), for: .touchUpInside)
        button3.imageView?.contentMode = .scaleAspectFill
        self.view.addSubview(button3)
        
        button4.frame = CGRect(x: 4*offSet + 3*buttonWidth, y: self.view.frame.size.height - 100 + Button4Constraint.constant, width: buttonWidth, height: buttonHeight)
        button4.setImage(UIImage(named:"bulldog"), for: .normal)
        button4.setTitle("dog", for: .normal)
        button4.addTarget(self, action: #selector(buttonAction4), for: .touchUpInside)
        //button4.imageView?.contentMode = .scaleAspectFill
        self.view.addSubview(button4)
        
        removeButton.frame = CGRect(x: self.view.frame.size.width - 80, y: 20, width: 60, height: 60)
        removeButton.layer.cornerRadius = removeButton.frame.width / 2
        //removeButton.backgroundColor = UIColor.red
        removeButton.setTitle("Remove", for: .normal)
        removeButton.setImage(UIImage(named:"remove"), for: .normal)
        removeButton.addTarget(self, action: #selector(removeOrAddButtonAction), for: .touchUpInside)
        self.view.addSubview(removeButton)
        
        buttonList = [button1, button2, button3, button4]
    }
    
    @objc func buttonAction1(sender: UIButton!) {
        selectedBuilding = "Medival_Building.DAE"
        sender.pulsate()
    }
    
    @objc func buttonAction2(sender: UIButton!) {
        selectedBuilding = "hotel.dae"
        sender.pulsate()
    }
    
    @objc func buttonAction3(sender: UIButton!) {
        selectedBuilding = "spooky.dae"
        sender.pulsate()
    }
    
    @objc func buttonAction4(sender: UIButton!) {
        selectedBuilding = "french_bulldog.dae"
        sender.pulsate()
    }
    
    @objc func removeOrAddButtonAction(sender: UIButton!) {
        let screenWidth: CGFloat = self.view.frame.size.width
        let screenHeight: CGFloat = self.view.frame.size.height
        let buttonWidth: CGFloat = 70
        let buttonHeight: CGFloat = 70
        let offSet: CGFloat = screenWidth / 25
        
        adding = !adding
        if(adding){
            removeButton.setImage(UIImage(named:"remove"), for: .normal)
            sender.flash()
            Button1Constraint.constant = 0
            Button2Constraint.constant = 0
            Button3Constraint.constant = 0
            Button4Constraint.constant = 0
            for button in buttonList{
                button.showButton()
            }
            UIView.animate(withDuration: 0.6) {
                
                self.button1.frame = CGRect(x: offSet, y: self.view.frame.size.height - 100 + self.Button1Constraint.constant, width: buttonWidth, height: buttonHeight)
                self.button2.frame = CGRect(x: 2*offSet + buttonWidth, y: self.view.frame.size.height - 100 + self.Button2Constraint.constant , width: buttonWidth, height: buttonHeight)
                self.button3.frame = CGRect(x: 3*offSet + 2*buttonWidth, y: self.view.frame.size.height - 100 + self.Button3Constraint.constant, width: buttonWidth, height: buttonHeight)
                self.button4.frame = CGRect(x: 4*offSet + 3*buttonWidth, y: self.view.frame.size.height - 100 + self.Button4Constraint.constant, width: buttonWidth, height: buttonHeight)
                self.view.layoutIfNeeded()
            }
        }
        else {
            removeButton.setImage(UIImage(named:"add"), for: .normal)
            sender.flash()
            Button1Constraint.constant = 100
            Button2Constraint.constant = 100
            Button3Constraint.constant = 100
            Button4Constraint.constant = 100
            for button in buttonList{
                button.hideButton()
            }
            UIView.animate(withDuration: 0.6) {
                self.button1.frame = CGRect(x: offSet , y: self.view.frame.size.height - 100 + self.Button1Constraint.constant, width: buttonWidth, height: buttonHeight)
                self.button2.frame = CGRect(x: 2*offSet + buttonWidth, y: self.view.frame.size.height - 100 + self.Button2Constraint.constant , width: buttonWidth, height: buttonHeight)
                self.button3.frame = CGRect(x: 3*offSet + 2*buttonWidth, y: self.view.frame.size.height - 100 + self.Button3Constraint.constant, width: buttonWidth, height: buttonHeight)
                self.button4.frame = CGRect(x: 4*offSet + 3*buttonWidth, y: self.view.frame.size.height - 100 + self.Button4Constraint.constant, width: buttonWidth, height: buttonHeight)
                self.view.layoutIfNeeded()
            }
            
            
        }
        
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
    
    @objc func moved(recognizer :UILongPressGestureRecognizer) {
        
        guard let recognizerView = recognizer.view as? ARSCNView else { return }
        let touch = recognizer.location(in: recognizerView)
        
        let hitTestResults = self.sceneView.hitTest(touch, options: nil)
        if let hitTest = hitTestResults.first {     //If house pressed
            if let houseNode = hitTest.node.parent { //set pressed house as active node
                
                if recognizer.state == .began {
                    
                }else if recognizer.state == .changed {
                    // perform continious hitTests of featurePoints and change houseNode position
                    
                    let hitTestPlane = self.sceneView.hitTest(touch, types: .existingPlane)
                    if let planeHit = hitTestPlane.first{
                        houseNode.position = SCNVector3(planeHit.worldTransform.columns.3.x,houseNode.position.y,planeHit.worldTransform.columns.3.z)
                    }
                    
                }else if recognizer.state == .ended {
                }
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
        
        guard let recognizerView = recognizer.view as? ARSCNView else { return }
        let touch = recognizer.location(in: recognizerView)
        
        let hitTestResults = recognizerView.hitTest(touch, types: .existingPlane)
        if let hitTest = hitTestResults.first {
            if(adding){
            guard let buildingScene = SCNScene(named: "art.scnassets/" + selectedBuilding ) else { return }
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
            case "spooky.dae":
                buildingNode.scale = SCNVector3(0.06, 0.06, 0.06)
            case "french_bulldog.dae":
                buildingNode.scale = SCNVector3(0.1, 0.1, 0.1)
            default:
                buildingNode.scale = SCNVector3(1, 1, 1)
                
            }
            rootScene.rootNode.addChildNode(buildingNode)
            }
            else{
                let hitTestResults2 = self.sceneView.hitTest(touch, options: nil)
                if let hitTest2 = hitTestResults2.first {     //If house pressed
                    if let houseNode2 = hitTest2.node.parent { //set pressed house as active node
                            houseNode2.removeFromParentNode()
                }
                
            }
            
            }
    
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
                self.hud.hide(animated: true, afterDelay: 1.4)
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

