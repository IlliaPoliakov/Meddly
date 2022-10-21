//
//  SaveNewGroupRepository.swift
//  Meedly
//
//  Created by Illia Poliakov on 20.10.22.
//

import Foundation

protocol SaveNewChanelRepository{
  func saveNewChanel(_ newChanelURl: URL, _ group: Group)
}
