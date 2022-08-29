//
//  AddItemAssembly.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/11.
//

import Foundation
import PhotosUI

import Swinject

class AddItemAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PHPickerViewController.self, name: "OneImage") { _ in
            var conf = PHPickerConfiguration()
            conf.selectionLimit = 1
            conf.filter = .images
            return PHPickerViewController(configuration: conf)
        }.inObjectScope(.container)
        
        container.register(UIImagePickerController.self, name: "camera") { _ in
            let camera = UIImagePickerController()
            camera.sourceType = .camera
            camera.allowsEditing = true
            camera.cameraDevice = .rear
            camera.cameraCaptureMode = .photo
            return camera
        }.inObjectScope(.container)
    }
}
