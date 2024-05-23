//
//  LogView.swift
//  shakelog
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import OSLog
import SwiftUI

public struct ShakeLogView: View {
	@Environment(\.presentationMode) var presentationMode
	@Binding var isPresented: Bool
	@State private var logs: [OSLogEntryLog] = []
	@State private var searchText: String = ""
	@State private var selectedLogType: LogType = .all
	@State private var showingExportSheet = false
	@State private var exportData: URL?
	private var timeInterval: TimeInterval
	private var subsystem: String?

	/// Initializes a new instance of ShakeLogView.
	/// - Parameters:
	///   - timeInterval: The time interval to fetch logs from.
	///   - subsystem: Subsystem name to filter logs by.
	///   - isPresented: Binding to control the presentation of the view.
	public init(timeInterval: TimeInterval = -3600, subsystem: String? = nil, isPresented: Binding<Bool>) {
		self.timeInterval = timeInterval
		self.subsystem = subsystem
		self._isPresented = isPresented
	}

	public var body: some View {
		NavigationView {
			VStack {
				Picker("Log Type", selection: $selectedLogType) {
					ForEach(LogType.allCases.filter { $0 != .subSystem || subsystem != nil }, id: \.self) { type in
						Text(type.displayName).tag(type)
					}
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding(.horizontal, subsystem == nil ? 16 : 0)

				List(filteredLogs.reversed(), id: \.self) { log in
					NavigationLink(destination: ShakeLogDetailView(log: log)) {
						Text(log.composedMessage)
							.font(.system(.body, design: .monospaced))
							.frame(maxWidth: .infinity, alignment: .leading)
							.lineLimit(4)
					}
				}
				.searchable(text: $searchText)
				.navigationBarItems(leading:
					Button(action: {
						isPresented.toggle()
					}) {
						Text("Dismiss")
					}, trailing:
					Button(action: {
						exportLogs(logs)
					}) {
						Image(systemName: "square.and.arrow.up")
					})

				.onChange(of: showingExportSheet) { value in
					guard value == true, let exportData = exportData else { return }
					presentShakeShareSheet(fileURL: exportData)
					showingExportSheet = false
				}
			}
		}
		.task {
			logs = await ShakeLogFileManager.shared.fetchShakeLogs(timeInterval: timeInterval, subsystem: subsystem)
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
		case .subSystem:
			filteredByType = logs.filter { $0.subsystem == subsystem }
		}
		if !searchText.isEmpty {
			return filteredByType.filter { $0.composedMessage.localizedCaseInsensitiveContains(searchText) }
		}
		return filteredByType
	}

	private func exportLogs(_ logs: [OSLogEntryLog]) {
		do {
			exportData = try ShakeLogExporter.exportLogs(logs)
			showingExportSheet = true
		} catch {
			print("Failed to export logs: \(error)")
		}
	}
}

enum LogType: String, CaseIterable {
	case all
	case info
	case error
	case debug
	case subSystem

	var displayName: String {
		switch self {
		case .all:
			return "All"
		case .info:
			return "Info"
		case .error:
			return "Error"
		case .debug:
			return "Debug"
		case .subSystem:
			return "Subsystem"
		}
	}
}

#Preview {
	ShakeLogView(isPresented: .constant(true))
}
