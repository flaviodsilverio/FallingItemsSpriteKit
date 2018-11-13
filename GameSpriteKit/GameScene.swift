//
//  GameScene.swift
//  GameSpriteKit
//
//  Created by Flávio Silvério on 11/11/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import SpriteKit
import GameplayKit

struct ColliderType {

    static let Player: UInt32 = 0x1 << 1
    static let Enemy: UInt32 = 0x1 << 2
    static let Screen: UInt32 = 0x1 << 3

}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player = SKSpriteNode()
    var direction: Int = 1
    var pointsLabel = SKLabelNode()
    var score: Int = 0 {
        didSet {
            pointsLabel.text = String(score)
        }
    }

    override func didMove(to view: SKView) {

        self.physicsWorld.contactDelegate = self

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody?.friction = 0
        //        self.physicsBody?.affectedByGravity = false
        //        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = ColliderType.Screen
        self.physicsBody?.collisionBitMask = ColliderType.Player

        player = SKSpriteNode(imageNamed: "mario")
        player.name = "Player"
        player.setScale(0.1)
        player.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        player.position = CGPoint(x: 0, y: -200)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = ColliderType.Player
        player.physicsBody?.collisionBitMask = ColliderType.Screen
        player.physicsBody?.contactTestBitMask = ColliderType.Enemy | ColliderType.Screen

        self.addChild(player)

        pointsLabel = self.childNode(withName: "label") as! SKLabelNode

        addEnemy()
    }

    func addEnemy(){

        let number = arc4random_uniform(4)

        var name = ""

        switch number {
        case 0:
            name = "star"
            break
        case 1:
            name = "green"
            break
        case 2:
            name = "red"
            break
        default:
            name = "yellow"
        }

        var enemy =  SKSpriteNode(imageNamed: name)
        enemy.name = "Enemy"
        enemy.setScale(0.3)
        enemy.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let number2 = Int.random(in: -200 ... 200)

        enemy.position = CGPoint(x: CGFloat(number2), y: 100)
        enemy.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        enemy.physicsBody?.affectedByGravity = true
        enemy.physicsBody?.categoryBitMask = ColliderType.Enemy
        enemy.physicsBody?.collisionBitMask = ColliderType.Player
        enemy.physicsBody?.friction = 10.0

        self.addChild(enemy)

        //score = score + 1

        self.run(SKAction.wait(forDuration: 0.5)) {
            self.addEnemy()
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {


        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()

        if contact.bodyA.node?.name == "Player" {

            firstBody = contact.bodyA
            secondBody = contact.bodyB

        } else {

            firstBody = contact.bodyB
            secondBody = contact.bodyA

        }

        if firstBody.node?.name == "Player" && secondBody.node?.name == "Enemy" {

            secondBody.node?.removeFromParent()
            score += score + 1

            print("item")

        } else {
            print("walls")
        }

    }


    func touchDown(atPoint pos : CGPoint) {

    }

    func touchMoved(toPoint pos : CGPoint) {

    }

    func touchUp(atPoint pos : CGPoint) {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        direction = direction * -1

    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }


    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        player.position.x = player.position.x + CGFloat(direction * 2)
    }
}
