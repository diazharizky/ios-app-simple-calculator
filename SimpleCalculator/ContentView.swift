//
//  ContentView.swift
//  SimpleCalculator
//
//  Created by Magnifico on 24/06/25.
//

import SwiftUI

enum Operator {
    case multiplication, division, addition, substraction
}

enum InputError: Error {
    case unableToParseInput
}

struct Input {
    var operand1: Double?
    var operand2: Double?
    var opr: Operator?
    var isCompleted: Bool {
        operand1 != nil && operand2 != nil && opr != nil
    }
}

struct ContentView: View {
    @State private var textInput = ""
    @State private var input = Input()
    @State private var showingResult = ""

    var body: some View {
        VStack {
            Text(showingResult != "" ? showingResult : textInput)
            HStack {
                Button("7") { addInput(newInput: "7") }
                Button("8") { addInput(newInput: "8") }
                Button("9") { addInput(newInput: "9") }
                Button("x") { setOperator(op: .multiplication) }
            }
            HStack {
                Button("4") { addInput(newInput: "4") }
                Button("5") { addInput(newInput: "5") }
                Button("6") { addInput(newInput: "6") }
                Button(":") { setOperator(op: .division) }
            }
            HStack {
                Button("1") { addInput(newInput: "1") }
                Button("2") { addInput(newInput: "2") }
                Button("3") { addInput(newInput: "3") }
                Button("+") { setOperator(op: .addition) }
            }
            HStack {
                Button(".") {
                    if textInput.count == 1 {
                        addInput(newInput: ".")
                    }
                }
                Button("0") { addInput(newInput: "0") }
                Button("Delete") {
                    if textInput == "" {
                        return
                    }

                    if showingResult == "" {
                        textInput.removeLast()
                        return
                    }

                    showingResult = ""
                    textInput = ""
                    input = Input()
                }
                Button("-") { setOperator(op: .substraction) }
            }
            Button("=") {
                if textInput == "" {
                    return
                }

                try? assignInput()
                if input.isCompleted {
                    showingResult = String(calculate())
                    input = Input()
                    textInput = ""
                }
            }
        }
    }

    func addInput(newInput: String) {
        textInput += newInput
    }

    func setOperator(op: Operator) {
        if textInput == "" {
            return
        }

        try? assignInput()
        if input.isCompleted {
            // in case the operator has been assigned
            // we can just do calculation and proceed with
            // the next logic
            let res = calculate()
            input.operand1 = res
            showingResult = String(res)
        }
        input.opr = op
        textInput = ""
    }

    func assignInput() throws {
        guard let doubledInput = Double(textInput) else {
            throw InputError.unableToParseInput
        }
        if input.operand1 == nil {
            input.operand1 = doubledInput
        } else {
            input.operand2 = doubledInput
        }
    }

    func calculate() -> Double {
        switch input.opr {
        case .multiplication:
            return input.operand1! * input.operand2!
        case .division:
            return input.operand1! / input.operand2!
        case .addition:
            return input.operand1! + input.operand2!
        case .substraction:
            return input.operand1! - input.operand2!
        default:
            return 0
        }
    }
}

#Preview {
    ContentView()
}
