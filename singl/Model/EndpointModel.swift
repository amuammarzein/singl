//
//  EndpointModel.swift
//  singl
//
//  Created by Aang Muammar Zein on 18/07/23.
//

import Foundation

struct ResponseModelWithoutData: Codable {
    var code: Int
    var status: Bool
    var message: String
}

struct ResponseModel: Codable {
    var code: Int
    var status: Bool
    var message: String
    var data:ResponseData
}

struct ResponseData: Codable,Hashable {
    var source_file: String
    var music_file: String
    var vocal_file: String
    var source_name: String
    var music_name: String
    var vocal_name: String
}


struct ResponseModelConverter: Codable {
    var code: Int
    var status: Bool
    var message: String
    var data:ResponseDataConverter
}

struct ResponseDataConverter: Codable,Hashable {
    var file_name: String
    var output: String
    var pitch: Float
}
