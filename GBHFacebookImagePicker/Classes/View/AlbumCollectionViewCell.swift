//
//  AlbumCollectionViewCell.swift
//  FBSDKCoreKit
//
//  Created by Loi Tran on 8/31/20.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell, Reusable {
    
    // MARK: - Var

    /// Album's cover image views
    @IBOutlet weak var photoImageView: AsyncImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var albumCount: UILabel!

    /// Width of the album's cover
    private let imageWidth = 120

    /// Height of the album's cover
    private let imageHeight = 120
    
    /// Override the initializer
    ///
    /// - Parameter frame: the new frame of the cell
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Cell background
        self.backgroundColor = FacebookImagePicker.pickerConfig.uiConfig.backgroundColor
        self.photoImageView?.contentMode = .scaleAspectFill
        self.photoImageView?.clipsToBounds = true
        self.photoImageView?.layer.cornerRadius = FacebookImagePicker.pickerConfig.pictureCornerRadius
    }
    
    /// Override prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Set default image
        self.photoImageView?.image = AssetsController.getImage(name: AssetImage.loader)
    }
    
    /// Required init for deserialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Configure
    
    /// Configure collection cell with image
    ///
    /// - Parameter picture: Facebook's image model
    func configure(album: FacebookAlbum) {
        albumName.text = album.name ?? ""

        if let count = album.count {
            albumCount.text = "\(count.locallyFormattedString())"
        } else {
            albumCount.text = ""
        }

        // Album cover image
        if album.albumId == FacebookController.idTaggedPhotosAlbum {
            // Special cover for tagged album : user facebook account picture
            FacebookController.shared.getProfilePicture(completion: { (result) in
                switch result {
                case .success(let url):
                    if let url = URL(string: url) {
                        self.photoImageView?.imageUrl = url
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        } else if let url = album.coverUrl {
            // Regular album, load the album cover from de Graph API url
            self.photoImageView?.imageUrl = url
        }
    }
}
