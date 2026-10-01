import React from 'react';
import { AppProvider, useApp } from './context/AppContext';
import { I18nProvider } from './locales/i18n';
import { TopNavbar } from './components/common/TopNavbar';
import { DemoTourBar } from './components/common/DemoTourBar';
import { ReceiptModal } from './components/common/ReceiptModal';
import { CopilotModal } from './components/common/CopilotModal';
import { LandingPage } from './components/landing/LandingPage';
import { FarmerPortal } from './components/farmer/FarmerPortal';
import { OperatorPortal } from './components/operator/OperatorPortal';
import { HubManagerPortal } from './components/hub/HubManagerPortal';
import { BuyerPortal } from './components/buyer/BuyerPortal';
import { ImpactPortal } from './components/impact/ImpactPortal';
import { AdminPortal } from './components/admin/AdminPortal';

const AppContent: React.FC = () => {
  const { currentRole, showReceiptModal, setShowReceiptModal } = useApp();

  return (
    <div className="min-h-screen bg-[#FAF9F5] text-[#18221E] flex flex-col font-sans selection:bg-[#52B788] selection:text-white">
      {/* Top Navbar with Role and Language Switchers */}
      <TopNavbar />

      {/* Main Dynamic View Area */}
      <main className="flex-1">
        {currentRole === 'landing' && <LandingPage />}
        {currentRole === 'farmer' && <FarmerPortal />}
        {currentRole === 'operator' && <OperatorPortal />}
        {currentRole === 'hub' && <HubManagerPortal />}
        {currentRole === 'buyer' && <BuyerPortal />}
        {currentRole === 'admin' && <AdminPortal />}
      </main>

      {/* Persistent Floating 3-Minute Guided Demo Stepper */}
      <DemoTourBar />

      {/* Global Modals */}
      <ReceiptModal onClose={() => setShowReceiptModal(false)} />
      <CopilotModal />
    </div>
  );
};

export default function App() {
  return (
    <I18nProvider>
      <AppProvider>
        <AppContent />
      </AppProvider>
    </I18nProvider>
  );
}
