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
	@Binding var filter: LogFilter?

	var body: some View {
		ScrollView {
			if let jsonData = log.composedMessage.data(using: .utf8), let jsonString = prettyPrintJSON(jsonData) {
				JSONHighlightView(jsonString: jsonString)
			} else {
				Text(log.composedMessage)
					.padding()
					.font(.system(.body, design: .monospaced))
					.frame(maxWidth: .infinity, alignment: .leading)
			}

			Divider()
			
			VStack(alignment: .leading, spacing: 10) {
				logDetailRow(title: "Timestamp", value: log.date.formatted(), filter: .timestamp(log.date))
				logDetailRow(title: "Category", value: log.category, filter: .category(log.category))
				logDetailRow(title: "Subsystem", value: log.subsystem, filter: .subsystem(log.subsystem))
				logDetailRow(title: "Process", value: log.process, filter: .process(log.process))
				logDetailRow(title: "Thread", value: "\(log.threadIdentifier)", filter: .thread(Int(log.threadIdentifier)))
				logDetailRow(title: "Activity ID", value: "\(log.activityIdentifier)", filter: .activityID(Int(log.activityIdentifier)))
				logDetailRow(title: "Process ID", value: "\(log.processIdentifier)", filter: .processID(Int(log.processIdentifier)))
				logDetailRow(title: "Sender", value: log.sender, filter: .sender(log.sender))
			}
			.padding()
		}
		.navigationBarTitle("Log Detail", displayMode: .inline)
		.navigationBarItems(trailing: Button(action: {
			exportLog(log)
		}) {
			Image(systemName: "square.and.arrow.up")
		})
	}

	private func logDetailRow(title: String, value: String, filter: LogFilter) -> some View {
		HStack {
			VStack(alignment: .leading) {
				Text(title).bold()
				Text(value)
			}
			Spacer()
			Button(action: {
				self.filter = self.filter == filter ? nil : filter
			}) {
				if self.filter == filter {
					Text("Filter")
						.padding(4)
						.background(Color.teal)
						.foregroundColor(.white)
						.cornerRadius(4)
				} else {
					Text("Filter")
						.padding(4)
						.foregroundColor(.teal)
						.overlay(
							RoundedRectangle(cornerRadius: 4)
								.stroke(Color.teal, lineWidth: 1)
						)
				}
			}
		}
		.padding(.vertical, 4)
	}

	private func exportLog(_ log: OSLogEntryLog) {
		// Your export logic here
	}
}
