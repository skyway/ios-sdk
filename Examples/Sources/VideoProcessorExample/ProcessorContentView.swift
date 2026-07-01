//
//  ProcessorContentView.swift
//  VideoProcessorExample
//
//  Copyright © 2026 NTT DOCOMO BUSINESS, Inc. All rights reserved.
//

import SwiftUI
import SkyWayRoom
import PhotosUI
import Vision

struct ProcessorContentView: View {
    @StateObject private var vm = ProcessorViewModel()
    @State private var roomNameText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var selectedPhotoItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 0) {
            cameraPreviewSection
            Divider()
            ScrollView {
                VStack(spacing: 16) {
                    joinSection
                    if vm.isPublished {
                        blurSection
                        virtualBackgroundSection
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Processor Example")
        .onAppear {
            Task {
                do {
                    try await vm.setup()
                } catch {
                    alertMessage = "セットアップに失敗しました。\nAppId / SecretKey を確認してください。"
                    showingAlert = true
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onChange(of: selectedPhotoItem) { item in
            Task {
                guard let data = try? await item?.loadTransferable(type: Data.self),
                      let image = UIImage(data: data) else { return }
                vm.vbBackgroundImage = image
            }
        }
    }

    // MARK: - Camera preview (upper half)

    private var cameraPreviewSection: some View {
        Group {
            if let stream = vm.localVideoStream {
                RepresentableVideoView(stream: stream)
                    .aspectRatio(9 / 16, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
            } else {
                Color.black
                    .aspectRatio(9 / 16, contentMode: .fit)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Join / Leave / Publish

    private var joinSection: some View {
        GroupBox("接続") {
            VStack(spacing: 8) {
                TextField("Room 名を入力", text: $roomNameText)
                    .textFieldStyle(.roundedBorder)
                    .disabled(vm.isJoined)

                // ① 入室ボタン
                Button(action: handleJoinLeave) {
                    if vm.isBusy && !vm.isJoined {
                        ProgressView().frame(maxWidth: .infinity)
                    } else {
                        Text(vm.isJoined ? "退室" : "入室")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(vm.isJoined ? .red : .blue)
                .disabled(vm.isBusy || !vm.isSetup)

                // ② Publish ボタン（入室後のみ表示）
                if vm.isJoined {
                    Button(action: handlePublish) {
                        if vm.isBusy && !vm.isPublished {
                            ProgressView().frame(maxWidth: .infinity)
                        } else {
                            Text(vm.isPublished ? "配信中" : "映像・音声を配信")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .disabled(vm.isBusy || vm.isPublished)
                }
            }
        }
    }

    private func handleJoinLeave() {
        Task {
            do {
                if vm.isJoined {
                    try await vm.leaveRoom()
                } else {
                    guard !roomNameText.isEmpty else {
                        alertMessage = "Room 名を入力してください。"
                        showingAlert = true
                        return
                    }
                    try await vm.joinRoom(roomName: roomNameText)
                }
            } catch {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }

    private func handlePublish() {
        Task {
            do {
                try await vm.publishStreams()
            } catch {
                alertMessage = error.localizedDescription
                showingAlert = true
            }
        }
    }

    // MARK: - BlurProcessor controls

    private var blurSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Toggle("背景ぼかし（BlurProcessor）", isOn: $vm.blurEnabled)
                    .tint(.blue)

                if vm.blurEnabled {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ぼかし半径: \(Int(vm.blurRadius)) px")
                            .font(.caption)
                        Slider(value: $vm.blurRadius, in: 0...100, step: 1)
                    }

                    stepperRow(
                        label: "推論間隔 (inferenceInterval)",
                        value: $vm.blurInferenceInterval,
                        range: 1...10
                    )

                    qualityPicker(selection: $vm.blurQuality)
                }
            }
        } label: {
            Label("BlurProcessor", systemImage: "camera.filters")
        }
    }

    // MARK: - VirtualBackgroundProcessor controls

    private var virtualBackgroundSection: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Toggle("仮想背景（VirtualBackgroundProcessor）", isOn: $vm.vbEnabled)
                    .tint(.indigo)

                if vm.vbEnabled {
                    // 背景画像選択
                    HStack {
                        if let img = vm.vbBackgroundImage {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 40)
                                .clipped()
                                .cornerRadius(6)
                        } else {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(Color.secondary.opacity(0.2))
                                .frame(width: 60, height: 40)
                                .overlay(Text("未設定").font(.caption2).foregroundColor(.secondary))
                        }

                        PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                            Text("背景画像を選択")
                        }
                        .buttonStyle(.bordered)

                        if vm.vbBackgroundImage != nil {
                            Button("クリア") {
                                vm.vbBackgroundImage = nil
                                selectedPhotoItem = nil
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }
                    }

                    stepperRow(
                        label: "推論間隔 (inferenceInterval)",
                        value: $vm.vbInferenceInterval,
                        range: 1...10
                    )

                    qualityPicker(selection: $vm.vbQuality)
                }
            }
        } label: {
            Label("VirtualBackgroundProcessor", systemImage: "person.crop.rectangle.stack")
        }
    }

    // MARK: - Shared sub-views

    @ViewBuilder
    private func stepperRow(label: String, value: Binding<UInt8>, range: ClosedRange<UInt8>) -> some View {
        HStack {
            Text("\(label): \(value.wrappedValue)")
                .font(.caption)
            Spacer()
            Stepper("", value: value, in: range)
                .labelsHidden()
        }
    }

    @ViewBuilder
    private func qualityPicker(
        selection: Binding<VNGeneratePersonSegmentationRequest.QualityLevel>
    ) -> some View {
        HStack {
            Text("品質 (qualityLevel)")
                .font(.caption)
            Spacer()
            Picker("品質", selection: selection) {
                Text("Fast").tag(VNGeneratePersonSegmentationRequest.QualityLevel.fast)
                Text("Balanced").tag(VNGeneratePersonSegmentationRequest.QualityLevel.balanced)
                Text("Accurate").tag(VNGeneratePersonSegmentationRequest.QualityLevel.accurate)
            }
            .pickerStyle(.segmented)
            .fixedSize()
        }
    }
}

#Preview {
    ProcessorContentView()
}
