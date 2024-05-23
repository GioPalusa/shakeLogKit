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
	@State private var filter: LogFilter?
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
				if filter == nil {
					Picker("Log Type", selection: $selectedLogType) {
						ForEach(LogType.allCases.filter { $0 != .subSystem || subsystem != nil }, id: \.self) { type in
							Text(type.displayName).tag(type)
						}
					}
					.pickerStyle(SegmentedPickerStyle())
					.padding(.horizontal, subsystem == nil ? 16 : 0)
				} else {
					HStack {
						Image(systemName: "line.3.horizontal.decrease.circle")
							.foregroundStyle(.teal)
						Text("\(filterDescription)")
							.foregroundStyle(.teal)
						Button(action: {
							filter = nil
						}, label: {
							Image(systemName: "clear")
								.font(.title3)
						})
						.foregroundStyle(.red)
						.padding(.leading, 8)
					}
					.padding(.horizontal, 16)

				}

				List(filteredLogs.reversed(), id: \.self) { log in
					NavigationLink(destination: ShakeLogDetailView(log: log, filter: $filter)) {
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

		let filteredBySearchText = filteredByType.filter {
			searchText.isEmpty || $0.composedMessage.localizedCaseInsensitiveContains(searchText)
		}

		if let filter = filter {
			return filteredBySearchText.filter { filter.matches(log: $0) }
		} else {
			return filteredBySearchText
		}
	}

	private var filterDescription: String {
		switch filter {
		case .timestamp(let date):
			return "Timestamp: \(date.formatted())"
		case .category(let category):
			return "Category: \(category)"
		case .subsystem(let subsystem):
			return "Subsystem: \(subsystem)"
		case .process(let process):
			return "Process: \(process)"
		case .thread(let thread):
			return "Thread: \(thread)"
		case .activityID(let activityID):
			return "Activity ID: \(activityID)"
		case .processID(let processID):
			return "Process ID: \(processID)"
		case .sender(let sender):
			return "Sender: \(sender)"
		case .none:
			return "None"
		}
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

enum LogFilter: Equatable {
	case timestamp(Date)
	case category(String)
	case subsystem(String)
	case process(String)
	case thread(Int)
	case activityID(Int)
	case processID(Int)
	case sender(String)

	func matches(log: OSLogEntryLog) -> Bool {
		switch self {
		case .timestamp(let date):
			return log.date == date
		case .category(let category):
			return log.category == category
		case .subsystem(let subsystem):
			return log.subsystem == subsystem
		case .process(let process):
			return log.process == process
		case .thread(let thread):
			return log.threadIdentifier == thread
		case .activityID(let activityID):
			return log.activityIdentifier == activityID
		case .processID(let processID):
			return log.processIdentifier == processID
		case .sender(let sender):
			return log.sender == sender
		}
	}
}

#Preview {
	ShakeLogView(isPresented: .constant(true))
}
