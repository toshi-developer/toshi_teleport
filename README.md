# 🚓 Toshi Dev - Advanced Teleport System

[English]
A highly optimized, multi-framework teleport script designed for **QBCore, QBOX, and ESX**.
It supports modern features like **ox_target**, **ox_lib**, item requirements, and Discord logging.

[日本語]
**QBCore, QBOX, ESX** に完全対応した、高機能テレポートスクリプトです。
**ox_target** や **ox_lib** などのモダンな機能、アイテム所持チェック、Discordログ出力に対応しています。

---

## ✨ Features / 特徴

- **Multi-Framework:** Supports QBCore, QBOX, ESX, and Standalone.
- **Interaction Modes:** Choose between **Target System** (eye icon) or **Classic Marker** (Press E).
- **Vehicle Support:** Configurable option to allow teleporting while inside a vehicle (Driver only).
- **Item Requirement:** Restrict teleportation to players holding specific items (e.g., keycards).
- **Customizable:** Notifications and Inventory checks are defined in `config.lua` as functions for easy modification.
- **Discord Logs:** Automatically sends usage logs to your Discord channel via Webhook.

- **マルチフレームワーク:** QBCore, QBOX, ESX, Standalone すべてに対応。
- **選べる操作モード:** **ターゲット（Target）** モード、または従来の **マーカー（Eキー）** モードを選択可能。
- **車両対応:** 車両に乗ったままのテレポート可否を設定可能（運転席のみ）。
- **アイテム制限:** 特定のアイテム（カードキーなど）を持っている場合のみ通行可能にする設定。
- **高いカスタマイズ性:** 通知やアイテム検知の処理が `config.lua` 内に関数化されており、自由に書き換え可能。
- **Discordログ:** 使用ログをDiscordのWebhookへ自動送信。

---

## 📦 Dependencies / 必要要件

This script works with any of the following frameworks:
このスクリプトは以下のいずれかの環境で動作します:

- **Frameworks:** `qb-core`, `qbx_core`, `es_extended`
- **Optional (Recommended):** `ox_lib`, `ox_target` (or `qb-target`)

---

## ⚙️ Installation / インストール方法

### 1. Download & Place
Download the script and place the folder into your server's `resources` directory.
スクリプトをダウンロードし、サーバーの `resources` フォルダに配置してください。

### 2. Server Config
Add the following line to your `server.cfg`:
`server.cfg` に以下の行を追加してください:

    ensure toshi_teleport

### 3. Configuration (config.lua)
Open `config.lua` and adjust the settings.
`config.lua` を開き、設定を調整してください。

#### 🔹 Framework Selection / フレームワーク選択
Set your server's framework.
使用しているフレームワークを指定してください。

    Config.Framework = 'qbox' -- 'qb', 'qbox', 'esx', or 'standalone'

#### 🔹 Interaction Mode / 操作モード設定
Choose between Target (Third-eye) or Marker (Press E).
ターゲット（第三の目）を使用するか、マーカーを使用するか選択します。

    Config.UseTarget = true         -- true = Target, false = Marker
    Config.TargetSystem = 'ox_target' -- 'ox_target' or 'qb-target'

#### 🔹 Discord Logs / ログ設定
To enable logs, paste your **Discord Webhook URL**.
ログを有効にするには、**Discord Webhook URL** を貼り付けてください。

    Config.EnableLogs = true
    Config.WebhookURL = "https://discord.com/api/webhooks/YOUR_WEBHOOK_HERE"

#### 🔹 Adding Points / 地点の追加
You can add teleport locations in `Config.TeleportPoints`.
`Config.TeleportPoints` に移動地点を追加できます。

    {
        id = 'mrpd_main',
        name = 'Los Santos PD',
        jobs = {'police', 'sheriff'},   -- Job Restriction (ジョブ制限)
        requiredItem = 'police_card',   -- Item Restriction (アイテム制限: Optional)
        coords = vector3(463.15, -1006.14, 22.08),
        targetName = 'Garage',
        targetCoords = vector3(463.15, -1006.14, 22.08),
        markerColor = {r = 0, g = 255, b = 0},
    },

---

## 🔧 Advanced Customization / 高度な設定

In `config.lua`, you can modify `Config.Functions` to adapt to your specific inventory or notification scripts (e.g., changing from ox_lib to native notifications).
`config.lua` 内の `Config.Functions` を編集することで、通知システムやインベントリシステムを環境に合わせて自由に変更できます。

    Config.Functions = {
        Notify = function(msg, type) ... end,
        HasItem = function(item, amount) ... end,
    }

---

## 🛠 Support / サポート

If you have any questions, please contact **Toshi Dev**.
ご質問等は、**Toshi Dev (とし)** までご連絡ください。

---

## 📄 License / ライセンス

Distributed under the MIT License. See `LICENSE` for more information.
本ソフトウェアは MIT ライセンスのもとで公開されています。詳細は `LICENSE` ファイルをご確認ください。