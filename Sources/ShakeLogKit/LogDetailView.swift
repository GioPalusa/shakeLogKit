//
//  SwiftUIView.swift
//  
//
//  Created by Giovanni Palusa on 2024-05-23.
//

import SwiftUI
import OSLog

struct LogDetailView: View {
	var log: OSLogEntryLog
	@State private var showingExportSheet = false
	@State private var exportData: URL?

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 10) {
				Text(log.composedMessage)
					.padding()
					.background(Color.black)
					.foregroundColor(Color.white)
					.font(.system(.body, design: .monospaced))
					.frame(maxWidth: .infinity, alignment: .leading)

				Divider()
					.background(Color.white)

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
				.background(Color.black)
				.foregroundColor(Color.white)
				.font(.system(.body, design: .monospaced))
				.frame(maxWidth: .infinity, alignment: .leading)
			}
			.padding()
		}
		.background(Color.black)
		.navigationBarTitle("Log Detail", displayMode: .inline)
		.navigationBarItems(trailing: Button(action: {
			exportLog(log)
		}) {
			Image(systemName: "square.and.arrow.up")
		})
		.onChange(of: showingExportSheet) { value in
			guard value == true, let exportData = exportData else { return }
			presentShareSheet(fileURL: exportData)
			showingExportSheet = false
		}
	}

	private func infoText(title: String, body: String) -> Text {
		Text("\(title)\n").bold() + Text(body)
	}

	private func exportLog(_ log: OSLogEntryLog) {
		let fileName = "log.log"
		let logText = log.composedMessage
		let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
		do {
			try logText.write(to: url, atomically: true, encoding: .utf8)
			exportData = url
			showingExportSheet = true
		} catch {
			print("Failed to write log file: \(error)")
		}
	}
}

#Preview {
	LogDetailView(log: OSLogEntryLog())
}
