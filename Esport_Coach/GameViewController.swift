//
//  GameViewController.swift
//  Esport_Coach
//
//  Created by 陈皓宇 on 05/05/2018.
//  Copyright © 2018 Haoyu Chen. All rights reserved.
//

import UIKit
import ARKit
import Parse


enum BitMaskCategory: Int {
    case bullet = 2
    case target = 3
}


class GameViewController: UIViewController, SCNPhysicsContactDelegate,UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    let effects = ["confetti","fire","smoke"]
    
    var effectsure = "confetti"
    
    var playscore = 0
    
    @IBOutlet weak var EffectPick: UIPickerView!
    
    
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: { action in
            // do something like...
            self.StartGame((Any).self)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return effects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return effects[row]
    }
    
    // delegate method
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedeffect = effects[row]
        effectsure =  selectedeffect
    }
    

    @IBOutlet weak var SceneViewAR: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    var power: Float = 50
    var Target: SCNNode?
    @IBOutlet weak var GravitySwitch: UISwitch!

    @IBAction func Back2Main(_ sender: Any) {
        performSegue(withIdentifier: "Back2MainfromGame", sender: self)
    }
    
    @objc func gameover(){
        displayAlert(title:"Game Over", message:"Time is up!")
        let upscore = PFObject(className: "Score")
        var currentUser = PFUser.current()
        
        print(currentUser)
        
        upscore["username"] = currentUser?.username
        upscore["score"] = playscore
        if currentUser != nil {
            upscore.saveInBackground {(success, error) in
                if (success) {
                    print(success)
                } else  {
                    print(error)
                }
            }

        } else {
            // Show the signup or login screen
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        

        EffectPick.delegate = self
        EffectPick.dataSource = self
        self.SceneViewAR.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.SceneViewAR.session.run(configuration)
        self.SceneViewAR.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view.
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.SceneViewAR.addGestureRecognizer(gestureRecognizer)
        self.SceneViewAR.scene.physicsWorld.contactDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else {return}
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let position = orientation + location
        let bullet = SCNNode(geometry: SCNSphere(radius: 0.1))
        bullet.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        bullet.position = position
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: bullet, options: nil))
        if GravitySwitch.isOn {
            body.isAffectedByGravity = true
        }else{
            body.isAffectedByGravity = false
        }
        bullet.physicsBody = body
        bullet.physicsBody?.applyForce(SCNVector3(orientation.x*power, orientation.y*power, orientation.z*power), asImpulse: true)
        bullet.physicsBody?.categoryBitMask = BitMaskCategory.bullet.rawValue
        bullet.physicsBody?.contactTestBitMask = BitMaskCategory.target.rawValue
        
        self.SceneViewAR.scene.rootNode.addChildNode(bullet)
        bullet.runAction(
            SCNAction.sequence([SCNAction.wait(duration: 2.0),
                                SCNAction.removeFromParentNode()])
        )
    }

    
    @IBAction func StartGame(_ sender: Any) {
        
        for _ in 1...30 {
            let xtmp = randomNumber(inRange: (-10)...10)
            let ytmp = randomNumber(inRange: (-15)...15)
            let ztmp = randomNumber(inRange: (-80)...20)
            self.addEgg(x:Float(xtmp), y:Float(ytmp), z:Float(ztmp))
        }
        
        var timer  = Timer()
        
        timer = Timer.scheduledTimer(timeInterval: 20, target: self, selector: Selector(("gameover")), userInfo: nil, repeats: false)
        
    }
    
    func addEgg(x:Float, y:Float, z:Float){
        let eggScene = SCNScene(named:"Media.scnassets/egg.scn")
        let eggNode = (eggScene?.rootNode.childNode(withName: "egg", recursively: false))!
        eggNode.position = SCNVector3(x,y,z)
        eggNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: eggNode, options: nil))
        eggNode.physicsBody?.categoryBitMask = BitMaskCategory.target.rawValue
        eggNode.physicsBody?.contactTestBitMask = BitMaskCategory.bullet.rawValue
        self.SceneViewAR.scene.rootNode.addChildNode(eggNode)
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        if nodeA.physicsBody?.categoryBitMask == BitMaskCategory.target.rawValue {
            self.Target = nodeA
        } else if nodeB.physicsBody?.categoryBitMask == BitMaskCategory.target.rawValue {
            self.Target = nodeB
        }

        let effectname = "Media.scnassets/" + effectsure + ".scnp"
        
        let confetti = SCNParticleSystem(named: effectname, inDirectory: nil)
        confetti?.loops = false
        confetti?.particleLifeSpan = 4
        confetti?.emitterShape = Target?.geometry
        let confettiNode = SCNNode()
        confettiNode.addParticleSystem(confetti!)
        confettiNode.position = contact.contactPoint
        self.SceneViewAR.scene.rootNode.addChildNode(confettiNode)
        Target?.removeFromParentNode()
        self.playscore = self.playscore + 1
        
    }

}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

public func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...6) -> T {
    let length = Int64(range.upperBound - range.lowerBound + 1)
    let value = Int64(arc4random()) % length + Int64(range.lowerBound)
    return T(value)
}

extension Collection {
    func randomItem() -> Self.Iterator.Element {
        let count = distance(from: startIndex, to: endIndex)
        let roll = randomNumber(inRange: 0...count-1)
        return self[index(startIndex, offsetBy: roll)]
    }
}

