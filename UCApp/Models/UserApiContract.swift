//
// UserApiContract.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation


class UserApiContract: JSONEncodable {

    var defaultAddressId: Int?
    var defaultPaymentId: Int?
    

    // MARK: JSONEncodable
    func encode() -> AnyObject {
        var nillableDictionary = [String:AnyObject?]()
        nillableDictionary["defaultAddressId"] = self.defaultAddressId
        nillableDictionary["defaultPaymentId"] = self.defaultPaymentId
        let dictionary: [String:AnyObject] = APIHelper.rejectNil(nillableDictionary) ?? [:]
        return dictionary
    }
}
