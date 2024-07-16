//
//  CameraCoordinator.swift
//  Landmark ID
//
//  Created by Pete Chambers on 10/07/24.
//  Copyright © 2024 Pete Chambers. All rights reserved.
//

import UIKit

class CameraCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: CameraAccessView
    
    init(picker: CameraAccessView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        self.picker.selectedImage = selectedImage
        self.picker.isPresented.wrappedValue.dismiss()
    }
}
