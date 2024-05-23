//
//  SwiftUIView.swift
//  
//
//  Created by Giovanni Palusa on 2024-05-23.
//

import SwiftUI
import OSLog

struct ShakeLogDetailView: View {
	var log: OSLogEntryLog
	@State private var showingExportSheet = false
	@State private var exportData: URL?

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 10) {
				if let jsonData = log.composedMessage.data(using: .utf8), let jsonString = prettyPrintJSON(jsonData) {
					JSONHighlightView(jsonString: jsonString)
				} else {
					Text(log.composedMessage)
						.padding()
						.font(.system(.body, design: .monospaced))
						.frame(maxWidth: .infinity, alignment: .leading)
				}

				Divider()

				VStack(alignment: .leading, spacing: 16) {
					infoText(title: "Timestamp", body: log.date.formatted())
					infoText(title: "Category", body: log.category)
					infoText(title: "Subsystem", body: log.subsystem)
					infoText(title: "Process", body: log.process)
					infoText(title: "Thread", body: String(log.threadIdentifier))
					infoText(title: "Activity ID", body: String(log.activityIdentifier))
					infoText(title: "Process ID", body: String(log.processIdentifier))
					infoText(title: "Sender", body: log.sender)
				}
				.padding()
				.font(.system(.body, design: .monospaced))
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			.padding()
		}
		.navigationBarTitle("Log Detail", displayMode: .inline)
		.navigationBarItems(trailing: Button(action: {
			exportLog(log)
		}) {
			Image(systemName: "square.and.arrow.up")
		})
		.onChange(of: showingExportSheet) { value in
			guard value == true, let exportData = exportData else { return }
			presentShakeShareSheet(fileURL: exportData)
			showingExportSheet = false
		}
	}

	private func infoText(title: String, body: String) -> Text {
		Text("\(title)\n").bold() + Text(body)
	}

	private func exportLog(_ log: OSLogEntryLog) {
		do {
			exportData = try ShakeLogExporter.exportLogs([log])
			showingExportSheet = true
		} catch {
			print("Failed to export log: \(error)")
		}
	}

	private func prettyPrintJSON(_ jsonData: Data) -> String? {
		do {
			let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
			let prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
			return String(data: prettyJsonData, encoding: .utf8)
		} catch {
			print("Failed to pretty print JSON: \(error)")
			return nil
		}
	}
}
