//
//  LogView.swift
//  shakelog
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import SwiftUI
import OSLog

public struct ShakeLogView: View {
	@Environment(\.presentationMode) var presentationMode
	@State private var logs: [OSLogEntryLog] = []
	@State private var searchText: String = ""
	@State private var selectedLogType: LogType = .all
	@State private var showingExportSheet = false
	@State private var exportData: URL?

	public init() {}

	public var body: some View {
		NavigationView {
			VStack {
				Picker("Log Type", selection: $selectedLogType) {
					ForEach(LogType.allCases, id: \.self) { type in
						Text(type.rawValue).tag(type)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding(.horizontal)

				List(filteredLogs.reversed(), id: \.self) { log in
					NavigationLink(destination: ShakeLogDetailView(log: log)) {
						Text(log.composedMessage)
							.background(Color.black)
							.foregroundColor(Color.white)
							.font(.system(.body, design: .monospaced))
							.frame(maxWidth: .infinity, alignment: .leading)
							.lineLimit(4)
					}
					.listRowBackground(Color.black)
				}
				.searchable(text: $searchText)
				.navigationBarItems(trailing: HStack {
					Button(action: {
						presentationMode.wrappedValue.dismiss()
					}) {
						Text("Dismiss")
					}
					Button(action: {
						exportLogs(logs)
					}) {
						Image(systemName: "square.and.arrow.up")
					}
				})
				.onChange(of: showingExportSheet) { value in
					guard value == true, let exportData = exportData else { return }
					presentShakeShareSheet(fileURL: exportData)
					showingExportSheet = false
				}
			}
		}
		.task {
			logs = await ShakeLogFileManager.shared.fetchShakeLogs()
		}
	}

	private var filteredLogs: [OSLogEntryLog] {
		let filteredByType: [OSLogEntryLog]
		switch selectedLogType {
		case .all:
			filteredByType = logs
		case .info:
			filteredByType = logs.filter { $0.level == .info }
		case .error:
			filteredByType = logs.filter { $0.level == .error }
		case .debug:
			filteredByType = logs.filter { $0.level == .debug }
		}
		if searchText.isEmpty {
			return filteredByType
		} else {
			return filteredByType.filter { $0.composedMessage.localizedCaseInsensitiveContains(searchText) }
		}
	}

	private func exportLogs(_ logs: [OSLogEntryLog]) {
		let fileName = "logs.log"
		let logText = logs.map { $0.composedMessage }.joined(separator: "\n")
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

enum LogType: String, CaseIterable {
	case all = "All"
	case info = "Info"
	case error = "Error"
	case debug = "Debug"
}

#Preview {
	ShakeLogView()
}
