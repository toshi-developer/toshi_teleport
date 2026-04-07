# CLAUDE.md — toshi_teleport

## プロジェクト概要 / Project Overview

**toshi_teleport** は FiveM 向けの高機能テレポートリソースです。QBCore / QBOX / ESX / Standalone に対応し、ox_target・ox_lib・アイテム制限・Discord ログをサポートします。

A highly optimized FiveM teleport resource supporting QBCore, QBOX, ESX, and Standalone frameworks, with ox_target, ox_lib, item requirements, and Discord logging.

---

## ファイル構成 / File Structure

| ファイル | 役割 |
|---|---|
| `fxmanifest.lua` | FiveM リソース定義ファイル |
| `config.lua` | フレームワーク・動作設定（全てのカスタマイズはここで行う）|
| `client.lua` | クライアント側ロジック（マーカー描画・ターゲット登録・テレポート処理）|
| `server.lua` | サーバー側ロジック（Discord ログ送信）|

---

## 開発ルール / Development Rules

- **設定は `config.lua` に集約する。** クライアント・サーバーにハードコードしない。
- **フレームワーク分岐は `Config.Framework` の値で行う。** (`'qb'` / `'qbox'` / `'esx'` / `'standalone'`)
- **通知・アイテムチェックは `Config.Functions` 内の関数を通じて呼び出す。** 直接フレームワーク API を叩かない。
- コードスタイルは既存ファイルに合わせる（4 スペースインデント）。

---

## ビルド・テスト / Build & Test

FiveM リソースのためビルドステップはありません。変更後は FiveM サーバーで `ensure toshi_teleport` を実行して動作確認してください。

No build step is required. After changes, restart the resource on a FiveM server with `ensure toshi_teleport`.

---

## 依存関係 / Dependencies

- **フレームワーク（いずれか）:** `qb-core`, `qbx_core`, `es_extended`
- **オプション（推奨）:** `ox_lib`, `ox_target` または `qb-target`
