//
//  TransactionRowView.swift
//  BudgetScanner
//
//  Created by Gabriel Castro on 11/06/2026.
//

// Path: BudgetScanner/Features/Transactions/Presentation/Components/TransactionRowView.swift
import SwiftUI

struct TransactionRowView: View {
    let transaction: TransactionEntity

    var body: some View {
        HStack(spacing: 12) {
            // Icono
            ZStack {
                Circle()
                    .fill(Color.emerald.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: transaction.isScanned ? "camera.viewfinder" : "creditcard.fill")
                    .foregroundStyle(Color.emerald)
                    .font(.system(size: 18))
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(transaction.category)
                        .font(.caption)
                        .foregroundStyle(Color.textSecondary)

                    if let merchant = transaction.merchant {
                        Text("·")
                            .foregroundStyle(Color.textSecondary)
                        Text(merchant)
                            .font(.caption)
                            .foregroundStyle(Color.textSecondary)
                            .lineLimit(1)
                    }
                }

                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundStyle(Color.textSecondary)
            }

            Spacer()

            // Importe
            Text("-\(transaction.amount.formatted(.number.precision(.fractionLength(2)))) \(transaction.currency)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.errorColor)
        }
        .padding(.vertical, 4)
    }
}
