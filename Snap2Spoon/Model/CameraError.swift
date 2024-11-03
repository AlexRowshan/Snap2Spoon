//
//  CameraError.swift
//  Snap2Spoon
//
//  Created by Cory DeWitt on 11/2/24.
//

enum CameraError: Error {
    case deviceNotFound
    case inputError
    case outputError
    case captureError
    case authorizationDenied
}
