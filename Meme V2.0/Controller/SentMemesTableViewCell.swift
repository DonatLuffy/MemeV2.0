//
//  SentMemesTableViewCell.swift
//  Meme V2.0
//
//  Created by Muhammed on 27/04/1440 AH.
//  Copyright © 1440 Udaicty. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    //MARK: Custom Cell's Functions
    
    func updateCell(_ meme: Meme) {
        
        //update cell's view
        memedImage.image = meme.memedImage
        topText.text = meme.topText
        bottomText.text = meme.bottomText
    }
}
