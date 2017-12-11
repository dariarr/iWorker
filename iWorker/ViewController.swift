//
//  ViewController.swift
//  hex2ios
//
//  Created by Daria.R on 5/24/15.
//  Copyright (c) 2015 iWorker. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var txtCode: NSTextField!
    @IBOutlet weak var txtRgb: NSTextField!
    @IBOutlet weak var txtSwift: NSTextField!
    @IBOutlet weak var txtObjC: NSTextField!
    @IBOutlet var boxColor: NSBox!

    var pasteBoard = NSPasteboard.generalPasteboard()

    @IBAction func rgbConvert(sender: AnyObject) {
        var str = txtRgb.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString

        let rgbArray = str.componentsSeparatedByString(",")

        if rgbArray.count != 3 {
            txtSwift.stringValue = ""
            txtObjC.stringValue = ""
            return
        }
        guard let fR = Float(rgbArray[0]),
              let fG = Float(rgbArray[1]),
              let fB = Float(rgbArray[2]) else {
            txtSwift.stringValue = ""
            txtObjC.stringValue = ""
            return
        }

        var code = ""
        for n in rgbArray {
            str = String(Int(n)!, radix: 16)
            if str.characters.count == 1 {
                code += "0"
            }
            code += str
        }
        txtCode.stringValue = code

        showResult(fR / 255.0, green: fG / 255.0, blue: fB / 255.0, hex: code)
    }

    @IBAction func convert(sender: AnyObject) {
        var str: NSString = txtCode.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        if (str.hasPrefix("#")) {
            str = str.substringFromIndex(1)
        }

        var hexArray: [String] = []

        switch str.length {
        case 3:
            for i in 0...2 {
                let hex = str.substringWithRange(NSRange(location: i, length: 1))
                hexArray.append(hex + hex)
            }
        case 6:
            
            for i in [0,2,4] {
                let hex = str.substringWithRange(NSRange(location: i, length: 2))
                hexArray.append(hex)
            }
        default:
            txtSwift.stringValue = ""
            txtObjC.stringValue = ""
            return
        }

        var uInt: CUnsignedInt
        var floatArray: [Float] = []
        var rgb = ""
        for hex in hexArray {
            uInt = 0
            NSScanner(string: hex).scanHexInt(&uInt)
            floatArray.append(Float(uInt))
            rgb += "," + uInt.description
        }
        txtRgb.stringValue = rgb.substringFromIndex(rgb.startIndex.advancedBy(1))

        showResult(floatArray[0] / 255.0, green: floatArray[1] / 255.0, blue: floatArray[2] / 255.0, hex: str as String)
    }

    func showResult(red: Float, green: Float, blue: Float, hex: String) {
        txtSwift.stringValue = "UIColor(red: \(red), green: \(green), blue: \(blue), alpha: 1.0) //\(hex)"
        txtObjC.stringValue = "[UIColor colorWithRed:\(red) green:\(green) blue:\(blue) alpha: 1.0]; //\(hex)"

        boxColor.layer?.backgroundColor = CGColorCreateGenericRGB(
            CGFloat(red),
            CGFloat(green),
            CGFloat(blue),
            1.0
        )

        pasteBoard.clearContents()
        pasteBoard.writeObjects([txtSwift.stringValue])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

