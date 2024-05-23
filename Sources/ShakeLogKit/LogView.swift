//
//  LogView.swift
//  shakelog
//
//  Created by Giovanni Palusa on 2024-05-22.
//

import SwiftUI

public struct LogView: View {
	@State private var logs: [String] = []

	public init() {}

	public var body: some View {
		List(logs, id: \.self) { log in
			Text(log)
				.padding()
				.background(Color.black)
				.foregroundColor(Color.white)
				.font(.system(.body, design: .monospaced))
				.frame(maxWidth: .infinity, alignment: .leading)
		}
		.onAppear {
			LogFileManager.shared.fetchLogs { fetchedLogs in
				logs = fetchedLogs
			}
		}
	}
}

#Preview {
	LogView()
}
