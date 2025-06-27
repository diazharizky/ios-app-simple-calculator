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

struct RoundedButton: View {
    let title: String
    let action: () -> Void

    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(bgColor)
                .clipShape(Circle())
                .lineLimit(1)
                .minimumScaleFactor(0.5)
        }
    }
}

let bgColor = Color(red: 0.4627, green: 0.8392, blue: 1.0)

struct ContentView: View {
    @State private var inputText = ""
    @State private var input = Input()
    @State private var showingResult: String? = nil

    var body: some View {
        VStack {
            Form {
                Text(showingResult ?? inputText)
            }
            .frame(maxHeight: 110)
            HStack {
                RoundedButton("7") { addInput("7") }
                RoundedButton("8") { addInput("8") }
                RoundedButton("9") { addInput("9") }
                RoundedButton("x") { setOperator(.multiplication) }
            }
            HStack {
                RoundedButton("4") { addInput("4") }
                RoundedButton("5") { addInput("5") }
                RoundedButton("6") { addInput("6") }
                RoundedButton(":") { setOperator(.division) }
            }
            HStack {
                RoundedButton("1") { addInput("1") }
                RoundedButton("2") { addInput("2") }
                RoundedButton("3") { addInput("3") }
                RoundedButton("+") { setOperator(.addition) }
            }
            HStack {
                RoundedButton(".") {
                    let periodCount = inputText.filter { $0 == "." }.count
                    guard periodCount == 0 else { return }
                    if inputText.count >= 1 {
                        addInput(".")
                    }
                }
                RoundedButton("0") { addInput("0") }
                RoundedButton(showingResult != nil ? "AC" : "<") {
                    if inputText.count > 0 {
                        inputText.removeLast()
                        return
                    }

                    showingResult = nil
                    inputText = ""
                    input = Input()
                }
                RoundedButton("-") { setOperator(.substraction) }
            }
            Button(action: {
                if inputText == "" {
                    return
                }

                try? assignInput()
                if input.isCompleted {
                    showingResult = String(calculate())
                    input = Input()
                    inputText = ""
                }
            }) {
                Text("=")
                    .fontWeight(.bold)
                    .frame(width: 190)
                    .padding()
                    .background(bgColor)
                    .foregroundColor(.white)
                    .cornerRadius(25)
            }
        }
    }

    func addInput(_ newInput: String) {
        showingResult = nil
        inputText += newInput
    }

    func setOperator(_ op: Operator) {
        if inputText == "" {
            return
        }

        try? assignInput()
        if input.isCompleted {
            // When all inputs have been assigned
            // it calculates the result right away
            let res = calculate()
            input.operand1 = res
            showingResult = String(res)
        }
        input.opr = op
        inputText = ""
    }

    func assignInput() throws {
        guard let doubledInput = Double(inputText) else {
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
