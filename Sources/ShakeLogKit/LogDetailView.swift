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
			Text(log.composedMessage)
				.padding()
				.background(Color.black)
				.foregroundColor(Color.white)
				.font(.system(.body, design: .monospaced))
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		.background(Color.black)
		.navigationBarTitle("Log Detail", displayMode: .inline)
		.navigationBarItems(trailing: Button(action: {
			exportLog(log)
		}) {
			Text("Export")
				.padding(4)
				.background(Color.blue)
				.foregroundColor(.white)
				.cornerRadius(8)
		})
		.onChange(of: showingExportSheet) { value in
			guard value == true, let exportData = exportData else { return }
			presentShareSheet(fileURL: exportData)
			showingExportSheet = false
		}
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
