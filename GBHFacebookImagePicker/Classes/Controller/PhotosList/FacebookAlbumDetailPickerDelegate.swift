//
//  FacebookAlbumPickerDelegate.swift
//  GBHFacebookImagePicker
//
//  Created by Florian Gabach on 01/12/2018.
//

import Foundation

protocol FacebookAlbumDetailPickerDelegate: class {
    func didSelectImages(images: [FacebookImage])
    func didPressFinishSelection(images: [FacebookImage])
    
    func didPickImage(image: FacebookImage)
    func didRemoveImage(image: FacebookImage)
}
