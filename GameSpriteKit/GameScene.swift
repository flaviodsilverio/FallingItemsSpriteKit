//
//  GameScene.swift
//  GameSpriteKit
//
//  Created by Flávio Silvério on 11/11/2018.
//  Copyright © 2018 Flávio Silvério. All rights reserved.
//

import SpriteKit
import GameplayKit

enum ItemType {
    case normal
    case bonus
}

class Enemy: SKSpriteNode {

    init(){
        let texture = SKTexture(imageNamed: "red")
        super.init(texture: texture, color: UIColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

class Item: SKSpriteNode {

    var itemValue: Int = 1

    init(with type: ItemType) {

        var textureName = ""

        switch type {
        case .bonus:
            itemValue = 5
            textureName = "star"
            break
        default:
            itemValue = 1
            textureName = "green"
        }

        let texture = SKTexture(imageNamed: textureName)
        super.init(texture: texture, color: UIColor(), size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

        let number = arc4random_uniform(3)

        var sprite = SKSpriteNode()

        switch number {
        case 0:
            sprite = Enemy()
            break
        case 2:
            sprite = Item(with: .bonus)
            break
        default:
            sprite = Item(with: .normal)
        }

        sprite.setScale(0.3)
        sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let number2 = Int.random(in: -180 ... 180)

        sprite.position = CGPoint(x: CGFloat(number2), y: 300)
        sprite.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        sprite.physicsBody?.affectedByGravity = true
        sprite.physicsBody?.categoryBitMask = ColliderType.Enemy
        sprite.physicsBody?.collisionBitMask = ColliderType.Player
        sprite.physicsBody?.friction = 10.0

        self.addChild(sprite)

        self.run(SKAction.wait(forDuration: 0.5)) {
            self.addEnemy()
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {


        var item = SKPhysicsBody()

        if contact.bodyA.node?.name == "Player" {
            item = contact.bodyB
        } else {
            item = contact.bodyA
        }

        if let enemy = item.node as? Enemy {

            pointsLabel.text = "GAME OVER"
            enemy.removeFromParent()

        } else if let item = item.node as? Item {

            score = score + item.itemValue
            item.removeFromParent()

        } else {
            changeDirection()
        }
    }


    func touchDown(atPoint pos : CGPoint) {

    }

    func touchMoved(toPoint pos : CGPoint) {

    }

    func touchUp(atPoint pos : CGPoint) {

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        changeDirection()
    }

    func changeDirection(){
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
