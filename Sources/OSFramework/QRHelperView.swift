//
//  QRHelperViewController.swift
//  QRHelper
//
//  Created by Daniel Vela on 05/12/2017.
//  Copyright © 2017 veladan. All rights reserved.
//
// Doc: https://www.unicorn-it.de/developing-reusable-views-in-a-swift-framework/
// Doc: https://www.appcoda.com/qr-code-generator-tutorial/

@objc public protocol QRViewDataSource {
    func qrValueToShow() -> String
}

@IBDesignable
public class QRHelperView: UIView {

    @IBOutlet var dataSource: QRViewDataSource? {
        didSet {
            qrLabel.text = dataSource?.qrValueToShow()
            qrImage.image = qrImage.image ?? makeQrImage(text: qrLabel.text)
        }
    }
    @IBOutlet weak var qrLabel: UILabel!
    @IBOutlet weak var qrImage: UIImageView!

    let nibName: String = "QRHelperView"
    var view: UIView!

    func setup() {
        self.view = UINib(nibName: self.nibName, bundle:
            Bundle(for: type(of: self))).instantiate(withOwner: self, options: nil)[0] as? UIView
        self.view.frame = bounds
        self.view.autoresizingMask =  [.flexibleWidth, .flexibleHeight]
        self.addSubview(self.view)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func makeQrImage(text: String?) -> UIImage? {
        let data = text?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")

            if let ciImage = filter.outputImage {
                let scaleX = self.frame.size.width / ciImage.extent.size.width
                let scaleY = self.frame.size.height / ciImage.extent.size.height

                let transformedImage = ciImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))

                return UIImage(ciImage: transformedImage)
            }
        }
        return nil
    }
}
