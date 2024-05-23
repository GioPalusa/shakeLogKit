//
//  JSONMarkup.swift
//
//
//  Created by Giovanni Palusa on 2024-05-23.
//

import SwiftUI

/// Function to pretty print JSON data
func prettyPrintJSON(_ data: Data) -> String? {
	if let jsonObject = try? JSONSerialization.jsonObject(with: data),
	   let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
	   let prettyString = String(data: prettyData, encoding: .utf8) {
		return prettyString
	}
	return nil
}

/// View to display highlighted JSON
struct JSONHighlightView: View {
	let jsonString: String

	var body: some View {
		VStack(alignment: .leading) {
			ForEach(prettyPrintedLines(), id: \.self) { line in
				parseAndColorLine(line)
			}
		}
	}

	private func prettyPrintedLines() -> [String] {
		jsonString.components(separatedBy: .newlines)
	}

	private func parseAndColorLine(_ line: String) -> some View {
		let trimmedLine = line.trimmingCharacters(in: .whitespaces)
		return Group {
			switch trimmedLine {
			case let s where s.hasPrefix("{") || s.hasPrefix("}"),
				let s where s.hasPrefix("[") || s.hasPrefix("]"):
				Text(line)
					.foregroundColor(.gray)
					.font(.system(.body, design: .monospaced))
					.padding(.leading, paddingForLine(line))
			case let s where s.contains(":"):
				let parts = trimmedLine.split(separator: ":", maxSplits: 1)
				if parts.count == 2 {
					let keyPart = String(parts[0])
					let valuePart = String(parts[1])
					HStack {
						Text(keyPart + ":")
							.foregroundColor(Color("JSONKey", bundle: .module))
							.font(.system(.body, design: .monospaced))
							.padding(.leading, paddingForLine(line))
						Text(valuePart)
							.foregroundColor(colorForValue(valuePart))
							.font(.system(.body, design: .monospaced))
					}
				} else {
					Text(line)
						.foregroundColor(.primary)
						.font(.system(.body, design: .monospaced))
						.padding(.leading, paddingForLine(line))
				}
			default:
				Text(line)
					.foregroundColor(.primary)
					.font(.system(.body, design: .monospaced))
					.padding(.leading, paddingForLine(line))
			}
		}
	}

	private func colorForValue(_ value: String) -> Color {
		let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
		if trimmedValue.hasPrefix("\"") && (trimmedValue.hasSuffix("\"") || trimmedValue.hasSuffix("\",")) {
			return Color("JSONString", bundle: .module)
		} else if ["true", "false", "true,", "false,"].contains(trimmedValue) {
			return .teal
		}
		return Color("JSONValue", bundle: .module)
	}

	private func paddingForLine(_ line: String) -> CGFloat {
		CGFloat(line.prefix { $0 == " " }.count * 2)
	}
}

struct JSONHighlightPreview: View {
	var body: some View {
		if let jsonData = """
		{
			"accountNumber": 92390038621,
			"status": 1,
			"productId": "VIGLD",
			"product": "Marginalen Gold",
			"paymentMethod": 1,
			"statementDistributionChannel": 0,
			"balance": 0.0,
			"creditLimit": 5000.0,
			"reservedAmount": 0.0,
			"creditLeftToUse": 5000.0,
			"amountInArrears": 0.0,
			"hasRewardProgram": false,
			"rewardPoints": 0.0,
			"cards": [
				{
					"accountNumber": null,
					"cardId": 19730,
					"cardNumber": "4016 **** **** 7418",
					"embossingName": "GRAHN IVAR",
					"cardholderCustomerNumber": 10791553,
					"isMain": true,
					"issueDate": "2017-10-18T00:00:00"
				}
			]
		}
		""".data(using: .utf8),
		   let jsonString = prettyPrintJSON(jsonData) {
			JSONHighlightView(jsonString: jsonString)
		} else {
			Text("Invalid JSON")
				.foregroundColor(.red)
		}
	}
}

#Preview {
	JSONHighlightPreview()
}
