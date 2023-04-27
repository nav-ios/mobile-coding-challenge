//
//  PodcastCell.swift
//  PodcastsFeed
//
//  Created by Nav on 27/04/23.
//

import UIKit

class PodcastCell: UITableViewCell {

    let labelDescription = UILabel()
    let labelTitle = UILabel()
    let labelFavorite = UILabel()
    let imageThumnail = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
