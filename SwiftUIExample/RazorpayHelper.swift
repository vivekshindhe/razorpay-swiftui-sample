//
//  ButtonActions.swift
//  SwiftUIExample
//
//  Created for handling button actions
//

import Foundation
import Razorpay
import Combine
import SwiftUI

struct ResponseStruct: Equatable {
    var response: String = "No data"
    var isSuccess: Bool = false
    var paymentId: String = ""
    var errorCode: Int32 = 0
    var errorDescription: String = ""
    var rawResponse: [AnyHashable: Any]? = nil
    
    // Implementation of Equatable
    static func == (lhs: ResponseStruct, rhs: ResponseStruct) -> Bool {
        return lhs.response == rhs.response &&
               lhs.isSuccess == rhs.isSuccess &&
               lhs.paymentId == rhs.paymentId &&
               lhs.errorCode == rhs.errorCode &&
               lhs.errorDescription == rhs.errorDescription
        // Note: We're not comparing rawResponse as dictionary comparison can be complex
    }
}

class ResponseViewModel: ObservableObject {
    @Published var responseStruct = ResponseStruct()
    
    func updateWithSuccess(paymentId: String, response: [AnyHashable: Any]?) {
        DispatchQueue.main.async {
            self.responseStruct = ResponseStruct(
                response: "Payment Success: \(paymentId)",
                isSuccess: true,
                paymentId: paymentId,
                rawResponse: response
            )
        }
    }
    
    func updateWithError(code: Int32, description: String, response: [AnyHashable: Any]?) {
        DispatchQueue.main.async {
            self.responseStruct = ResponseStruct(
                response: "Payment Error: \(code) - \(description)",
                isSuccess: false,
                errorCode: code,
                errorDescription: description,
                rawResponse: response
            )
        }
    }
}

class RazorpayHelper : NSObject, RazorpayPaymentCompletionProtocolWithData, ObservableObject {
    
    var responseViewModel: ResponseViewModel? = nil
    
    override init() {
        super.init()
    }

    
    func onPaymentError(_ code: Int32, description str: String, andData response: [AnyHashable : Any]?) {
        print("Payment Error: \(code) - \(str)")
        responseViewModel?.updateWithError(code: code, description: str, response: response)
    }
    
    func onPaymentSuccess(_ payment_id: String, andData response: [AnyHashable : Any]?) {
        print("Payment Success: \(payment_id)")
        responseViewModel?.updateWithSuccess(paymentId: payment_id, response: response)
    }
    
    var razorpay: RazorpayCheckout!

    func handlePayWithRazorpay(_ responseViewModel: ResponseViewModel) {
        self.responseViewModel = responseViewModel
        let options: [String:Any] = [
            "key": "rzp_test_1DP5mmOlF5G5ag",
            "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "purchase description",
            "name": "business or product name",
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        razorpay.open(options)
    }
    
    func onViewAppeared() {
        print("View has appeared - performing initialization tasks")
        //fetch the key from either a constant or your backend
        razorpay = RazorpayCheckout.initWithKey("rzp_test_1DP5mmOlF5G5ag", andDelegateWithData: self)
    }
}
