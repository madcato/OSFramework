//
//  QRCaptureView.swift
//  QRHelper
//
//  Created by Daniel Vela on 05/12/2017.
//  Copyright © 2017 veladan. All rights reserved.
//
// Doc: https://www.appcoda.com/barcode-reader-swift/

import AVFoundation

@objc
public protocol QRCaptureViewDelegate {
    func captured(string value: String, valid: Bool)
}

@IBDesignable
public class QRCaptureView: UIView, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var delegate: QRCaptureViewDelegate?
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView {
        // Initialize QR Code Frame to highlight the QR code
        let temp = UIView()
        temp.layer.borderColor = UIColor.green.cgColor
        temp.layer.borderWidth = 4
        self.addSubview(temp)
        self.bringSubview(toFront: temp)
        return temp
    }

    public func startCapture() {
        // Get an instance of the AVCaptureDevice class to initialize a device
        // object and provide the video as the media type parameter.
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            NSLog("AVCaptureDevice.default FAILED")
            return
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            if let captureSession = captureSession {
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                videoPreviewLayer?.frame = self.layer.bounds
                self.layer.addSublayer(videoPreviewLayer!)
            }
            // Start video capture.
            captureSession?.startRunning()
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        guard metadataObjects.count != 0 else {
            delegate?.captured(string: "No QR code is detected", valid: false)
            return
        }
        // Get the metadata object.
        if let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject {
            if metadataObj.type == AVMetadataObject.ObjectType.qr {
                // If the found metadata is equal to the QR code metadata then
                // update the status label's text and set the bounds
                let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
                qrCodeFrameView.frame = barCodeObject!.bounds
                if let result = metadataObj.stringValue {
                    delegate?.captured(string: result, valid: true)
                    captureSession?.stopRunning()
                }
            }
        }
    }
}
