import React from 'react';
import { useApp } from '../../context/AppContext';
import { Lot } from '../../types';
import {
  X,
  Printer,
  Share2,
  CheckCircle2,
  Calendar,
  Clock,
  Warehouse,
  QrCode,
  ShieldCheck,
  Sparkles,
} from 'lucide-react';

interface ReceiptModalProps {
  lot?: Lot | null;
  onClose: () => void;
}

export const ReceiptModal: React.FC<ReceiptModalProps> = ({ lot: propLot, onClose }) => {
  const { receiptLot, showReceiptModal, setShowReceiptModal } = useApp();
  const lot = propLot || receiptLot;

  if (!showReceiptModal || !lot) return null;

  const handlePrint = () => {
    window.print();
  };

  const handleShareWhatsApp = () => {
    const text = `*FasalOS Digital Storage Receipt*\nLot ID: ${lot.id}\nFarmer: ${lot.farmerName}\nCrop: ${lot.cropName} (${lot.variety})\nWeight: ${lot.quantityKg} kg\nGrade: ${lot.grade} (Confirmed)\nStorage: ${lot.coldRoomId === 'CR-01' ? 'Cold Room A' : 'Cold Room B'}\nShelf-life: ~${Math.round(lot.commercialShelfLifeHours / 24)} days\nVerified by Kurnool Hub #04`;
    window.open(`https://wa.me/?text=${encodeURIComponent(text)}`, '_blank');
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-white rounded-3xl shadow-2xl max-w-lg w-full overflow-hidden border border-[#E6E2D8] flex flex-col max-h-[92vh]">
        {/* Modal Header */}
        <div className="bg-[#1B4332] text-white p-4 sm:p-5 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="w-8 h-8 rounded-lg bg-emerald-700/80 flex items-center justify-center text-amber-300">
              <ShieldCheck className="w-5 h-5" />
            </div>
            <div>
              <h3 className="font-bold text-base font-heading">Digital Storage & Quality Receipt</h3>
              <p className="text-xs text-emerald-200">Traceable Agricultural Inventory Lot</p>
            </div>
          </div>
          <button
            onClick={() => {
              setShowReceiptModal(false);
              onClose();
            }}
            className="p-1 rounded-lg text-emerald-200 hover:text-white hover:bg-emerald-800 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Printable Receipt Body */}
        <div id="printable-receipt" className="p-6 overflow-y-auto space-y-5 bg-[#FAF9F5]/40 text-[#18221E]">
          {/* Header Badge */}
          <div className="flex items-center justify-between border-b border-[#E6E2D8] pb-4">
            <div>
              <span className="text-[11px] font-bold uppercase tracking-wider text-[#5C6761]">
                FasalOS Collection Hub
              </span>
              <h4 className="text-lg font-black text-[#1B4332] tracking-tight">
                Nandikotkur Village Center #04
              </h4>
              <p className="text-xs text-gray-500">Kurnool District · Andhra Pradesh</p>
            </div>
            <div className="text-right">
              <span className="text-[11px] font-bold text-gray-400">LOT ID</span>
              <div className="text-sm font-mono font-bold text-[#18221E] bg-[#EAE6DD] px-2 py-0.5 rounded">
                {lot.id}
              </div>
            </div>
          </div>

          {/* Farmer & Crop Highlight Card */}
          <div className="bg-white rounded-2xl p-4 border border-[#E6E2D8] shadow-sm grid grid-cols-2 gap-4">
            <div>
              <span className="text-[11px] font-semibold text-gray-500 uppercase">Farmer</span>
              <div className="text-sm font-bold text-[#18221E]">{lot.farmerName}</div>
              <div className="text-xs text-gray-500">{lot.village} · {lot.farmerId}</div>
            </div>
            <div>
              <span className="text-[11px] font-semibold text-gray-500 uppercase">Crop & Variety</span>
              <div className="text-sm font-bold text-[#2D6A4F]">{lot.cropName}</div>
              <div className="text-xs text-gray-500">{lot.variety}</div>
            </div>
            <div>
              <span className="text-[11px] font-semibold text-gray-500 uppercase">Net Weight</span>
              <div className="text-lg font-black text-[#18221E]">{lot.quantityKg} kg</div>
              <div className="text-[10px] text-gray-400">Verified Electronic Scale</div>
            </div>
            <div>
              <span className="text-[11px] font-semibold text-gray-500 uppercase">Quality Grade</span>
              <div className="flex items-center gap-1.5 mt-0.5">
                <span className="px-2 py-0.5 rounded-md bg-[#D8F3DC] text-[#1B4332] font-black text-sm border border-emerald-300">
                  Grade {lot.grade}
                </span>
                <span className="text-[11px] text-emerald-700 font-semibold flex items-center gap-0.5">
                  <CheckCircle2 className="w-3 h-3 text-emerald-600" />
                  91% AI
                </span>
              </div>
            </div>
          </div>

          {/* Storage & Shelf Life Info */}
          <div className="grid grid-cols-2 gap-3 text-xs">
            <div className="p-3 rounded-xl bg-white border border-[#E6E2D8]">
              <span className="text-gray-400 text-[10px] font-bold uppercase flex items-center gap-1 mb-1">
                <Warehouse className="w-3 h-3 text-blue-600" />
                Storage Assigned
              </span>
              <div className="font-bold text-[#18221E]">
                {lot.coldRoomId === 'CR-01' ? 'Solar Cold Room A' : 'Solar Cold Room B'}
              </div>
              <div className="text-[11px] text-gray-500">{lot.storageSlot}</div>
              <div className="text-[10px] text-emerald-600 font-semibold mt-1">Chilled at 8.2°C · 74% Solar</div>
            </div>

            <div className="p-3 rounded-xl bg-white border border-[#E6E2D8]">
              <span className="text-gray-400 text-[10px] font-bold uppercase flex items-center gap-1 mb-1">
                <Clock className="w-3 h-3 text-amber-600" />
                Estimated Shelf-Life
              </span>
              <div className="font-bold text-[#18221E]">
                ~{Math.round(lot.commercialShelfLifeHours / 24)} Days ({lot.commercialShelfLifeHours}h)
              </div>
              <div className="text-[11px] text-gray-500">Freshness: {lot.freshnessScore}/100</div>
              <div className="text-[10px] text-amber-700 font-semibold mt-1">Commercial Window Active</div>
            </div>
          </div>

          {/* Timestamps */}
          <div className="p-3 rounded-xl bg-white border border-[#E6E2D8] flex items-center justify-between text-xs">
            <div className="flex items-center gap-1.5 text-gray-600">
              <Calendar className="w-3.5 h-3.5 text-gray-400" />
              <span>Intake Date: {new Date(lot.intakeTimestamp).toLocaleDateString('en-IN', { day: 'numeric', month: 'short', year: 'numeric' })}</span>
            </div>
            <div className="text-emerald-700 font-bold flex items-center gap-1">
              <ShieldCheck className="w-3.5 h-3.5 text-emerald-600" />
              <span>Operator Confirmed</span>
            </div>
          </div>

          {/* QR Verification & Barcode */}
          <div className="bg-white rounded-2xl p-4 border border-[#E6E2D8] flex items-center justify-between gap-4">
            <div className="flex-1">
              <span className="text-[11px] font-bold text-gray-400 uppercase">Lot Digital Passport</span>
              <h5 className="text-xs font-bold text-[#18221E] mt-0.5">
                Scan for Supply-Chain Traceability
              </h5>
              <p className="text-[11px] text-gray-500 mt-1 leading-relaxed">
                Connects field harvest timestamp, sensory grading confidence, and continuous storage temperature log.
              </p>
            </div>
            <div className="w-20 h-20 bg-gray-50 p-1.5 rounded-xl border border-gray-200 flex-shrink-0 flex items-center justify-center">
              <img
                src={`https://api.qrserver.com/v1/create-qr-code/?size=100x100&data=https://fasalos.in/lot/${lot.id}`}
                alt="Lot QR Code"
                className="w-full h-full object-contain"
              />
            </div>
          </div>
        </div>

        {/* Modal Actions */}
        <div className="p-4 bg-white border-t border-[#E6E2D8] flex items-center justify-between gap-2">
          <button
            onClick={handleShareWhatsApp}
            className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-emerald-300 bg-emerald-50 text-emerald-800 text-xs font-bold hover:bg-emerald-100 transition-colors"
          >
            <Share2 className="w-3.5 h-3.5 text-emerald-600" />
            <span>Send to WhatsApp</span>
          </button>

          <div className="flex items-center gap-2">
            <button
              onClick={handlePrint}
              className="flex items-center gap-1.5 px-3 py-2 rounded-xl border border-gray-300 bg-white text-gray-700 text-xs font-semibold hover:bg-gray-50 transition-colors"
            >
              <Printer className="w-3.5 h-3.5" />
              <span>Print</span>
            </button>
            <button
              onClick={() => {
                setShowReceiptModal(false);
                onClose();
              }}
              className="px-4 py-2 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-colors"
            >
              Done
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};
