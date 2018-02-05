//
//  InstallManager.swift
//  OSFramework
//
//  Created by Daniel Vela on 22/01/2018.
//  Copyright © 2018 Daniel Vela. All rights reserved.
//

import Foundation

/// This class manages the installation of files from a bundle

public class InstallManager {
    public init() {
    }

    public func destinationFileURL(_ fileName: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }

    public func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    public func saveFileToDocumentsDirectory(fileName: String) {
        let toUrl = destinationFileURL(fileName)
        guard let fromUrl = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            NSLog("File %@ doesn't exists", fileName)
            return
        }
        let fm = FileManager()
        try? fm.copyItem(at: fromUrl, to: toUrl)
    }
//    if let image = UIImage(named: "example.png") {
//        if let data = UIImageJPEGRepresentation(image, 0.8) {
//            let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
//            try? data.write(to: filename)
//        }
//    }
}
