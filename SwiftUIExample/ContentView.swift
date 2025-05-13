//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by Vivek Rajesh Shindhe on 13/05/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var responseViewModel = ResponseViewModel()
    @StateObject private var razorpayHelper = RazorpayHelper()
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                razorpayHelper.handlePayWithRazorpay(responseViewModel)
            }) {
                Text("Pay With Razorpay")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            if responseViewModel.responseStruct.response != "No data" {
                PaymentResponseView(responseStruct: responseViewModel.responseStruct)
                    .animation(.easeInOut, value: responseViewModel.responseStruct)
                    .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .onAppear {
            razorpayHelper.onViewAppeared()
        }
    }
}

struct PaymentResponseView: View {
    let responseStruct: ResponseStruct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if responseStruct.isSuccess {
                Text("Payment Successful")
                    .font(.headline)
                    .foregroundColor(.green)
                
                Text("Payment ID: \(responseStruct.paymentId)")
                    .font(.subheadline)
            } else {
                Text("Payment Failed")
                    .font(.headline)
                    .foregroundColor(.red)
                
                Text("Error Code: \(responseStruct.errorCode)")
                    .font(.subheadline)
                
                Text("Description: \(responseStruct.errorDescription)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
