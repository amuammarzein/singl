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
    var data: ResponseData
}
struct ResponseData: Codable, Hashable {
    var sourceFile: String
    var musicFile: String
    var vocalFile: String
    var sourceName: String
    var musicName: String
    var vocalName: String
}
struct ResponseModelConverter: Codable {
    var code: Int
    var status: Bool
    var message: String
    var data: ResponseDataConverter
}
struct ResponseDataConverter: Codable, Hashable {
    var fileName: String
    var output: String
    var pitch: Float
}
