# FasalOS — The Operating System for Post-Harvest Agriculture

> **"The intelligence layer between harvest and market."**  
> *From harvest to the right market. Store smarter. Sell with better information.*

[![License: MIT](https://img.shields.io/badge/License-MIT-emerald.svg)](https://opensource.org/licenses/MIT)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-blue.svg)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-19-61dafb.svg)](https://react.dev/)
[![Vite](https://img.shields.io/badge/Vite-8.x-646cff.svg)](https://vitejs.dev/)
[![TailwindCSS](https://img.shields.io/badge/TailwindCSS-v4-38bdf8.svg)](https://tailwindcss.com/)

---

## 🌾 Overview

Farmers are often forced to sell fresh produce immediately at distress prices due to lack of cold storage, quality grading, aggregation, market intelligence, and direct buyer access.

**FasalOS** transforms smallholder harvests into intelligent, traceable, market-ready inventory. It connects:

$$\textbf{Farmer} \longrightarrow \textbf{Collection} \longrightarrow \textbf{Quality} \longrightarrow \textbf{Storage} \longrightarrow \textbf{AI Intelligence} \longrightarrow \textbf{Aggregation} \longrightarrow \textbf{Market} \longrightarrow \textbf{Buyer} \longrightarrow \textbf{Logistics} \longrightarrow \textbf{Settlement}$$

---

## ✨ Key Features & Capabilities

### 1. 👨‍🌾 Farmer-First Mobile Experience
- **Human-centered interface** tailored for first-time smartphone users and low digital literacy.
- **Large touch targets** with primary action: **"I have produce to sell"**.
- Real-time produce freshness tracker (e.g., 92/100) and estimated commercial window.
- Transparent net earnings: **₹42,875** with itemized breakdown (Gross − Storage fee − Transport).
- Digital lot receipt with dynamic QR code.
- 1-tap WhatsApp and direct Operator call assistance.

### 2. 🏪 Village Collection Center Operator Portal
- **10-Step Guided Intake Workflow**:
  1. Select Farmer (searchable list)
  2. Select Crop (Tomato, Mango, Banana, Onion, Leafy Greens)
  3. Electronic Scale Weight Entry (verified 250 kg)
  4. Harvest Timestamp logging
  5. Optical Camera Sample Capture
  6. **Computer Vision AI Quality Assessment**: Color (94%), Size Uniformity (95%), Defect Rate (3.2%), Bruising (1.8%) $\rightarrow$ **Grade A (91% confidence)**.
  7. **Operator Confirmation & Override**: Human operator holds final authority.
  8. **Digital Lot Generation**: `LOT-FOS-20481` with cryptographic traceability.
  9. **Storage Bay Allocation**: Solar Cold Room A (Bay A-04).
  10. **Digital Receipt Issuance**: Printable receipt with QR code and WhatsApp share.
- **Offline-First Mode**: Local device drafts with background sync queue for intermittent rural connectivity.

### 3. ❄️ Solar Micro-Cold Room & Hub Telemetry
- **Continuous Chamber Telemetry**: 8.2°C temperature, 78% humidity, 68% occupancy.
- **Thermal Reserve Hold**: Real-time calculation showing **6 hours 20 minutes** of autonomous cooling without grid power.
- **Solar Clean Energy**: 74% solar contribution today (62 kWh solar / 84 kWh total).
- **Dynamic Shelf-Life Risk Watchlist**: Identifies batches nearing the end of their commercial window (e.g. 420 kg at 32h remaining) with instant routing to buyers.
- **Processing Routing**: Best Destination Engine directing Grade A to fresh retail, Grade B to wholesale, Grade C to puree/pulp, and Grade D to bio-gas/compost.

### 4. 🛒 B2B Marketplace & Village Smallholder Aggregation
- **Verified B2B Procurement**: Grade-verified produce discovery for retail supermarket chains and institutional buyers.
- **Smallholder Aggregation Engine**: Combines fragmented individual farmer crates (Lakshmi 250kg + Ramesh 1,200kg + Venkat 600kg...) into a unified 10,000 kg commercial shipment.
- **Transparent Unit Economics**: Payouts, freight, and hub margins calculated live.

### 5. 🤖 FasalOS Copilot
- *"Understand your inventory. Explore your options."*
- Multi-market net realization comparison table comparing Local Mandi vs Regional City vs Metro B2B Direct (+28.5% net uplift).
- Clear model confidence, explicit operational assumptions, and timestamped calculations.

### 6. 🌐 Multilingual System
Full native script support across 5 languages:
- **English** (`en`)
- **తెలుగు — Telugu** (`te`)
- **हिंदी — Hindi** (`hi`)
- **தமிழ் — Tamil** (`ta`)
- **ಕನ್ನಡ — Kannada** (`kn`)

---

## 🚀 Quick Start

### Prerequisites
- Node.js v18+ (tested on v24.x)
- npm or pnpm

### Installation

```bash
# Clone the repository
git clone https://github.com/SHAIKFAYAZHUSSAIN/FasalOS.git
cd FasalOS

# Install dependencies
npm install

# Start development server
npm run dev
```

Visit `http://localhost:5173` to explore the application!

### Production Build

```bash
npm run build
npm run preview
```

---

## ☁️ Deployment

- **Vercel**: Deploy with zero configuration via `npx vercel` or import from GitHub. (Pre-configured `vercel.json` included).
- **Netlify**: Deploy using `npx netlify deploy --prod --dir=dist` or drag-and-drop the `dist` folder onto [app.netlify.com/drop](https://app.netlify.com/drop).
- **Cloudflare Pages**: Connect Git repo or deploy via `npx wrangler pages deploy dist`.

---

## 📄 License

This project is licensed under the MIT License.
