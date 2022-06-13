//
//  ViewController.swift
//  OverlapImage
//
//  Created by Rishabh Ganesh on 5/30/22.
//

import UIKit

//put two images together in a graphics context while adjusting position before drawing
extension UIImage
{
    func overlayWith(image: UIImage, posX: CGFloat, posY: CGFloat) -> UIImage
    {
        let newWidth = posX < 0 ? abs(posX) + max(self.size.width, image.size.width) :
            size.width < posX + image.size.width ? posX + image.size.width : size.width
        let newHeight = posY < 0 ? abs(posY) + max(size.height, image.size.height) :
            size.height < posY + image.size.height ? posY + image.size.height : size.height
        let newSize = CGSize(width: newWidth, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let originalPoint = CGPoint(x: posX < 0 ? abs(posX) : 0, y: posY < 0 ? abs(posY) : 0)
        self.draw(in: CGRect(origin: originalPoint, size: self.size))
        let overLayPoint = CGPoint(x: posX < 0 ? 0 : posX, y: posY < 0 ? 0 : posY)
        image.draw(in: CGRect(origin: overLayPoint, size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }

}

class ViewController: UIViewController {


    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*imageView1.image = UIImage(named: "under")
        let newImage1 = imageView1.image?.overlayWith(image: (UIImage(named: "over") ?? UIImage(named: "over"))!, posX: 275, posY: 345)
        imageView1.image = newImage1
        imageView2.image = UIImage(named: "approx")
        */
        let bottomImage = UIImage(named: "under")
        let topImage = UIImage(named: "over")

        let sizeUnder = CGSize(width: 256, height: 337)
        let sizeOver = CGSize(width: 118, height: 56)
        UIGraphicsBeginImageContext(sizeUnder)

        let areaSizeUnder = CGRect(x: 0, y: 0, width: sizeUnder.width, height: sizeUnder.height)
        //let areaSizeOver = CGRect(x: 0, y: 0, width: sizeOver.width, height: sizeOver.height)
        
        //bottomImage!.draw(in: areaSizeUnder)

        //topImage!.draw(in: areaSizeUnder, blendMode: .normal, alpha: 0.5)

        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        imageView1.image = newImage
        /*let bottomImage = UIImage(named: "under")
        let topImage1 = UIImage(named: "over")
        imageView1.image = bottomImage
        let newImage1 = mergeImages(imageView: imageView1)
        imageView1.image = newImage1
        imageView2.image = UIImage(named: "approx")
        imageView3.image = newImage1*/
    }

    //put two images together within a graphics context
    func mergeImages(imageView: UIImageView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        imageView.superview!.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    //best method to merge images after testing
    func blendImages(_ img: UIImage,_ imgTwo: UIImage) -> UIImage
    {
        let bottomImage = img
        let topImage = imgTwo

        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        let imgView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))

        // - Set Content mode to what you desire
        imgView.contentMode = .scaleAspectFill
        imgView2.contentMode = .scaleAspectFit

        // - Set Images
        imgView.image = bottomImage
        imgView2.image = topImage

        // - Create UIView
        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: 125, height: 125))
        contentView.addSubview(imgView)
        contentView.addSubview(imgView2)

        // - Set Size
        let size = CGSize(width: 125, height: 125)

        // - Where the magic happens
        UIGraphicsBeginImageContextWithOptions(size, false, 0)

        //contentView.drawHierarchy(in: contentView.bounds, afterScreenUpdates: true)
        contentView.layer.render(in: UIGraphicsGetCurrentContext()!)
        //contentView.snapshotView(afterScreenUpdates: true)
        //guard
        let i = UIGraphicsGetImageFromCurrentImageContext()
            //let data = UIImageJPEGRepresentation(i, 1.0)
           // else {return nil}

        UIGraphicsEndImageContext()

        return i!
    }
    
}

