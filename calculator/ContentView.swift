import SwiftUI

struct CalculatorView: View {
    @ObservedObject private var viewModel = CalculatorViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            Text(viewModel.displayText)
                .font(.largeTitle)
            
            CalculatorButtonGrid(buttons: viewModel.buttons, buttonTapped: viewModel.buttonTapped)
        }
        .padding()
    }
}

struct CalculatorButtonGrid: View {
    let buttons: [[CalculatorButtonModel]]
    let buttonTapped: (CalculatorButtonModel) -> Void
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        CalculatorButton(button: button, buttonTapped: buttonTapped)
                    }
                }
            }
        }
    }
}

struct CalculatorButton: View {
    let button: CalculatorButtonModel
    let buttonTapped: (CalculatorButtonModel) -> Void
    
    var body: some View {
        Button(action: {
            buttonTapped(button)
        }) {
            Text(button.title)
                .font(.title)
                .frame(width: 80, height: 80)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(40)
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            CalculatorView()
                .navigationBarTitle("Việt Tiến")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


///ViewModel
class CalculatorViewModel: ObservableObject {
    @Published var displayText = ""
    
    let buttons: [[CalculatorButtonModel]] = [
        [.clear, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equals]
    ]
    
    private var currentValue = 0.0
    private var currentOperator: CalculatorButtonModel?
    private var isTypingNumber = false
    
    func buttonTapped(_ button: CalculatorButtonModel) {
        switch button {
        case .clear:
            clear()
        case .plusMinus:
            changeSign()
        case .percent:
            calculatePercentage()
        case .divide, .multiply, .subtract, .add:
            selectOperator(button)
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            appendDigit(button)
        case .decimal:
            addDecimalPoint()
        case .equals:
            performCalculation()
        }
    }
    
    private func clear() {
        displayText = ""
        currentValue = 0.0
        currentOperator = nil
        isTypingNumber = false
    }
    
    private func changeSign() {
        guard var number = Double(displayText) else {
            return
        }
        
        number *= -1
        displayText = formattedString(for: number)
    }
    
    private func calculatePercentage() {
        guard var number = Double(displayText) else {
            return
        }
        
        number /= 100
        displayText = formattedString(for: number)
    }
    
    private func selectOperator(_ operator: CalculatorButtonModel) {
        if isTypingNumber {
            performCalculation()
        }
        
        currentOperator = `operator`
        currentValue = Double(displayText) ?? 0.0
        isTypingNumber = false
    }
    
    private func appendDigit(_ digit: CalculatorButtonModel) {
        if !isTypingNumber {
            displayText = ""
        }
        
        displayText += digit.title
        isTypingNumber = true
    }
    
    private func addDecimalPoint() {
        if !isTypingNumber {
            displayText = "0."
            isTypingNumber = true
        } else if !displayText.contains(".") {
            displayText += "."
        }
    }
    
    private func performCalculation() {
        guard let `operator` = currentOperator, let number = Double(displayText) else {
            return
        }
        
        switch `operator` {
        case .divide:
            currentValue /= number
        case .multiply:
            currentValue *= number
        case .subtract:
            currentValue -= number
        case .add:
            currentValue += number
        default:
            break
        }
        
        displayText = formattedString(for: currentValue)
        currentOperator = nil
        isTypingNumber = false
    }
    
    private func formattedString(for number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 6
        
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

enum CalculatorButtonModel: Hashable {
    case clear
    case plusMinus
    case percent
    case divide
    case multiply
    case subtract
    case add
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case decimal
    case equals
    
    var title: String {
        switch self {
        case .clear: return "AC"
        case .plusMinus: return "+/-"
        case .percent: return "%"
        case .divide: return "÷"
        case .multiply: return "×"
        case .subtract: return "-"
        case .add: return "+"
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eight: return "8"
        case .nine: return "9"
        case .decimal: return "."
        case .equals: return "="
        }
    }
} 


