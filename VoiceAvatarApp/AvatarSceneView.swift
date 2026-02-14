import SwiftUI
import SceneKit

struct AvatarSceneView: UIViewRepresentable {
    let isSpeaking: Bool
    let audioLevel: Float
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = createScene()
        sceneView.backgroundColor = .clear
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = false
        
        // Add camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 5)
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        // Store reference to avatar head
        context.coordinator.avatarHead = sceneView.scene?.rootNode.childNode(withName: "avatarHead", recursively: true)
        context.coordinator.sceneView = sceneView
        
        return sceneView
    }
    
    func updateUIView(_ sceneView: SCNView, context: Context) {
        context.coordinator.updateAnimation(isSpeaking: isSpeaking, audioLevel: audioLevel)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    private func createScene() -> SCNScene {
        let scene = SCNScene()
        
        // Create avatar head (sphere)
        let headGeometry = SCNSphere(radius: 1.0)
        headGeometry.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.5, blue: 0.9, alpha: 1.0)
        headGeometry.firstMaterial?.specular.contents = UIColor.white
        headGeometry.firstMaterial?.shininess = 0.8
        
        let headNode = SCNNode(geometry: headGeometry)
        headNode.name = "avatarHead"
        scene.rootNode.addChildNode(headNode)
        
        // Create eyes
        let eyeGeometry = SCNSphere(radius: 0.15)
        eyeGeometry.firstMaterial?.diffuse.contents = UIColor.white
        
        let leftEye = SCNNode(geometry: eyeGeometry)
        leftEye.position = SCNVector3(x: -0.3, y: 0.2, z: 0.85)
        headNode.addChildNode(leftEye)
        
        let rightEye = SCNNode(geometry: eyeGeometry)
        rightEye.position = SCNVector3(x: 0.3, y: 0.2, z: 0.85)
        headNode.addChildNode(rightEye)
        
        // Create pupils
        let pupilGeometry = SCNSphere(radius: 0.08)
        pupilGeometry.firstMaterial?.diffuse.contents = UIColor.black
        
        let leftPupil = SCNNode(geometry: pupilGeometry)
        leftPupil.position = SCNVector3(x: 0, y: 0, z: 0.07)
        leftEye.addChildNode(leftPupil)
        
        let rightPupil = SCNNode(geometry: pupilGeometry)
        rightPupil.position = SCNVector3(x: 0, y: 0, z: 0.07)
        rightEye.addChildNode(rightPupil)
        
        // Create mouth
        let mouthGeometry = SCNBox(width: 0.4, height: 0.1, length: 0.1, chamferRadius: 0.05)
        mouthGeometry.firstMaterial?.diffuse.contents = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        let mouth = SCNNode(geometry: mouthGeometry)
        mouth.name = "mouth"
        mouth.position = SCNVector3(x: 0, y: -0.4, z: 0.85)
        headNode.addChildNode(mouth)
        
        // Add ambient light
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.color = UIColor(white: 0.6, alpha: 1.0)
        scene.rootNode.addChildNode(ambientLight)
        
        // Add directional light
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.color = UIColor.white
        directionalLight.position = SCNVector3(x: 5, y: 5, z: 5)
        directionalLight.look(at: SCNVector3Zero)
        scene.rootNode.addChildNode(directionalLight)
        
        // Add idle animation
        let rotateAction = SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 20)
        let repeatAction = SCNAction.repeatForever(rotateAction)
        headNode.runAction(repeatAction)
        
        return scene
    }
    
    class Coordinator {
        var avatarHead: SCNNode?
        var sceneView: SCNView?
        private var isSpeakingAnimation = false
        
        func updateAnimation(isSpeaking: Bool, audioLevel: Float) {
            guard let head = avatarHead else { return }
            
            if isSpeaking != isSpeakingAnimation {
                isSpeakingAnimation = isSpeaking
                
                if isSpeaking {
                    startSpeakingAnimation(head)
                } else {
                    stopSpeakingAnimation(head)
                }
            }
            
            // Update mouth based on audio level
            if isSpeaking, let mouth = head.childNode(withName: "mouth", recursively: true) {
                let scale = 1.0 + CGFloat(audioLevel * 0.5)
                mouth.scale = SCNVector3(scale, scale, 1.0)
            }
        }
        
        private func startSpeakingAnimation(_ head: SCNNode) {
            // Scale animation for speaking
            let scaleUp = SCNAction.scale(to: 1.05, duration: 0.3)
            let scaleDown = SCNAction.scale(to: 0.95, duration: 0.3)
            let sequence = SCNAction.sequence([scaleUp, scaleDown])
            let repeatAction = SCNAction.repeatForever(sequence)
            
            head.runAction(repeatAction, forKey: "speaking")
            
            // Glow effect when speaking
            if let geometry = head.geometry {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.3
                geometry.firstMaterial?.emission.contents = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
                SCNTransaction.commit()
            }
        }
        
        private func stopSpeakingAnimation(_ head: SCNNode) {
            head.removeAction(forKey: "speaking")
            
            // Reset scale
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.3
            head.scale = SCNVector3(1, 1, 1)
            SCNTransaction.commit()
            
            // Remove glow
            if let geometry = head.geometry {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.3
                geometry.firstMaterial?.emission.contents = UIColor.black
                SCNTransaction.commit()
            }
            
            // Reset mouth
            if let mouth = head.childNode(withName: "mouth", recursively: true) {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.2
                mouth.scale = SCNVector3(1, 1, 1)
                SCNTransaction.commit()
            }
        }
    }
}
