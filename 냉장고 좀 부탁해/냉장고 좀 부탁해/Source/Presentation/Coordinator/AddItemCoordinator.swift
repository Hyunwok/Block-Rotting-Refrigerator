//
//  AddItemCoordinator.swift
//  냉장고 좀 부탁해
//
//  Created by 이현욱 on 2022/08/10.
//

import UIKit
import PhotosUI

import RxSwift

protocol AddItemCoordinatorProtocol: Coordinator {
    func camera()
    func imagePicker()
    func pop()
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action>
}

final class AddItemCoordinator: NSObject, AddItemCoordinatorProtocol {
    var childCoordinator: [Coordinator] = []
    let nav: UINavigationController
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc: AddItemViewController = AppDIContainer.shared.resolve()
        vc.modalPresentationStyle = .fullScreen
        self.nav.present(vc, animated: true)
    }
    
    func camera() {
        let vc: UIImagePickerController = AppDIContainer.shared.resolve(registrationName: "camera")
        vc.delegate = self
        nav.presentedViewController?.present(vc, animated: true, completion: nil)
    }
    
    func imagePicker() {
        let vc: PHPickerViewController = AppDIContainer.shared.resolve(registrationName: "OneImage")
        vc.delegate = self
        nav.presentedViewController?.present(vc, animated: true)
    }
    
    func pop() {
        self.nav.dismiss(animated: true)
        self.removeChild(self)
    }
    
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertController.Style,
        actions: [Action]
    ) -> Observable<Action> {
        return Observable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alert.addAction(alertAction)
            }
            self.nav.presentedViewController?.present(alert, animated: true)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension AddItemCoordinator: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let useImage = image as? UIImage else { return }
                    event.onNext(.updateImage(useImage))
                }
            }
        }
    }
}

extension AddItemCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage! // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        event.onNext(.updateImage(newImage))
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
