import SwiftUI

struct AnalyzeFailView: View {
    var onRetry: (() -> Void)? = nil
    var onClose: (() -> Void)? = nil

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 20) {
                ZStack(alignment: .topTrailing) {
                    Image("icon_fail")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                }

                Text("Analysis Failed")
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)

                Text("We apologize, but there was an issue processing your item. Please try again.")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal, 24)
            }

            Spacer()

            Button {
                onRetry?()
            } label: {
                HStack(spacing: 8) {
                    Text("Try Again")
                        .font(.system(size: 17, weight: .semibold))
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .background(Color.purple)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .overlay(alignment: .topTrailing) {
            Button {
                onClose?()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .background(.black.opacity(0.06))
                    .clipShape(Circle())
            }
            .padding(20)
        }
    }
}
