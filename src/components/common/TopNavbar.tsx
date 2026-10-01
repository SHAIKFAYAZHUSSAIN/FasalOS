import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation, SUPPORTED_LANGUAGES } from '../../locales/i18n';
import { FasalLogo } from './FasalLogo';
import { Role } from '../../types';
import {
  Globe,
  Wifi,
  WifiOff,
  Sparkles,
  Bell,
  CheckCircle2,
  ChevronDown,
  Layers,
  Sprout,
  Store,
  Warehouse,
  ShoppingBag,
  ShieldCheck,
  TrendingUp,
} from 'lucide-react';

export const TopNavbar: React.FC = () => {
  const {
    currentRole,
    setCurrentRole,
    offlineMode,
    setOfflineMode,
    offlineDraftsCount,
    triggerSync,
    startDemoTour,
    demoActive,
    alerts,
    markAlertAsRead,
  } = useApp();

  const { language, setLanguage, t } = useTranslation();
  const [langMenuOpen, setLangMenuOpen] = useState(false);
  const [roleMenuOpen, setRoleMenuOpen] = useState(false);
  const [alertsOpen, setAlertsOpen] = useState(false);

  const unreadAlerts = alerts.filter((a) => !a.read);

  const roleDefinitions: { role: Role; label: string; icon: React.ReactNode; color: string }[] = [
    { role: 'landing', label: t.nav.landing, icon: <Layers className="w-4 h-4" />, color: 'text-gray-700' },
    { role: 'farmer', label: t.nav.farmer, icon: <Sprout className="w-4 h-4 text-emerald-600" />, color: 'text-emerald-700' },
    { role: 'operator', label: t.nav.operator, icon: <Store className="w-4 h-4 text-amber-600" />, color: 'text-amber-700' },
    { role: 'hub', label: t.nav.hub, icon: <Warehouse className="w-4 h-4 text-blue-600" />, color: 'text-blue-700' },
    { role: 'buyer', label: t.nav.buyer, icon: <ShoppingBag className="w-4 h-4 text-purple-600" />, color: 'text-purple-700' },
    { role: 'admin', label: t.nav.admin, icon: <ShieldCheck className="w-4 h-4 text-slate-600" />, color: 'text-slate-700' },
  ];

  return (
    <header className="sticky top-0 z-40 bg-[#FAF9F5]/95 backdrop-blur-md border-b border-[#E6E2D8] transition-colors">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between gap-2 sm:gap-4">
        {/* Brand Logo */}
        <div
          className="cursor-pointer flex-shrink-0"
          onClick={() => setCurrentRole('landing')}
          title="FasalOS Home"
        >
          <FasalLogo size="sm" showTagline={true} />
        </div>

        {/* Center: Quick Role Switcher Pills (Desktop) */}
        <div className="hidden lg:flex items-center bg-[#F2EFE9] p-1 rounded-xl border border-[#E0DCD2]">
          {roleDefinitions.map((item) => {
            const isActive = currentRole === item.role;
            return (
              <button
                key={item.role}
                onClick={() => setCurrentRole(item.role)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-all ${
                  isActive
                    ? 'bg-white text-[#1B4332] shadow-sm font-bold border border-[#D5D0C3]'
                    : 'text-[#5C6761] hover:text-[#18221E] hover:bg-white/60'
                }`}
              >
                {item.icon}
                <span>{item.label}</span>
              </button>
            );
          })}
        </div>

        {/* Right Actions */}
        <div className="flex items-center gap-1.5 sm:gap-3">
          {/* 3-Minute Demo Walkthrough Button */}
          <button
            onClick={startDemoTour}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-bold transition-all shadow-sm ${
              demoActive
                ? 'bg-[#D97706] text-white ring-2 ring-[#F59E0B]'
                : 'bg-[#1B4332] text-white hover:bg-[#2D6A4F] hover:shadow-md'
            }`}
          >
            <Sparkles className="w-3.5 h-3.5 text-amber-300 animate-spin" style={{ animationDuration: '4s' }} />
            <span className="hidden sm:inline">{t.nav.demoWalkthrough}</span>
            <span className="sm:hidden">Demo</span>
          </button>

          {/* Role selector dropdown for mobile/tablet */}
          <div className="relative lg:hidden">
            <button
              onClick={() => setRoleMenuOpen(!roleMenuOpen)}
              className="flex items-center gap-1 px-2.5 py-1.5 rounded-lg border border-[#E6E2D8] bg-white text-xs font-semibold text-[#18221E]"
            >
              <span>{roleDefinitions.find((r) => r.role === currentRole)?.label}</span>
              <ChevronDown className="w-3.5 h-3.5 text-gray-500" />
            </button>

            {roleMenuOpen && (
              <div className="absolute right-0 mt-2 w-48 bg-white rounded-xl shadow-xl border border-[#E6E2D8] py-1 z-50">
                {roleDefinitions.map((item) => (
                  <button
                    key={item.role}
                    onClick={() => {
                      setCurrentRole(item.role);
                      setRoleMenuOpen(false);
                    }}
                    className={`w-full flex items-center gap-2 px-3 py-2 text-xs text-left ${
                      currentRole === item.role ? 'bg-[#D8F3DC] text-[#1B4332] font-bold' : 'text-gray-700 hover:bg-gray-50'
                    }`}
                  >
                    {item.icon}
                    <span>{item.label}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Language Selector Dropdown */}
          <div className="relative">
            <button
              onClick={() => setLangMenuOpen(!langMenuOpen)}
              className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-xl border border-[#E6E2D8] bg-white text-xs font-medium text-[#18221E] hover:bg-[#F9F8F5] transition-colors"
              title="Select Language / భాష"
            >
              <Globe className="w-3.5 h-3.5 text-[#2D6A4F]" />
              <span className="font-semibold">{SUPPORTED_LANGUAGES.find((l) => l.code === language)?.nativeLabel}</span>
              <ChevronDown className="w-3 h-3 text-gray-400" />
            </button>

            {langMenuOpen && (
              <div className="absolute right-0 mt-2 w-44 bg-white rounded-xl shadow-xl border border-[#E6E2D8] py-1.5 z-50 animate-in fade-in zoom-in-95">
                <div className="px-3 py-1 text-[11px] font-semibold text-[#5C6761] border-b border-[#F0ECE2] uppercase tracking-wider">
                  Languages / భాషలు
                </div>
                {SUPPORTED_LANGUAGES.map((lang) => (
                  <button
                    key={lang.code}
                    onClick={() => {
                      setLanguage(lang.code);
                      setLangMenuOpen(false);
                    }}
                    className={`w-full flex items-center justify-between px-3 py-2 text-xs text-left transition-colors ${
                      language === lang.code ? 'bg-[#D8F3DC] text-[#1B4332] font-bold' : 'text-[#18221E] hover:bg-[#FAF9F5]'
                    }`}
                  >
                    <span className="flex items-center gap-2">
                      <span className="text-sm">{lang.flag}</span>
                      <span>{lang.nativeLabel}</span>
                    </span>
                    <span className="text-[10px] text-gray-400">{lang.label}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Offline Mode Toggle & Sync Pill */}
          <button
            onClick={() => {
              if (offlineMode && offlineDraftsCount > 0) {
                triggerSync();
              }
              setOfflineMode(!offlineMode);
            }}
            className={`flex items-center gap-1.5 px-2.5 py-1.5 rounded-xl text-xs font-medium border transition-colors ${
              offlineMode
                ? 'bg-amber-50 text-amber-800 border-amber-300'
                : 'bg-emerald-50 text-emerald-800 border-emerald-300'
            }`}
            title={offlineMode ? 'Simulating Rural Offline Mode' : 'Online Sync Active'}
          >
            {offlineMode ? (
              <>
                <WifiOff className="w-3.5 h-3.5 text-amber-600 animate-pulse" />
                <span className="hidden sm:inline font-bold">Offline</span>
                {offlineDraftsCount > 0 && (
                  <span className="bg-amber-500 text-white rounded-full px-1.5 py-0.2 text-[10px] font-bold">
                    {offlineDraftsCount}
                  </span>
                )}
              </>
            ) : (
              <>
                <Wifi className="w-3.5 h-3.5 text-emerald-600" />
                <span className="hidden sm:inline">Online</span>
              </>
            )}
          </button>

          {/* Alerts Bell */}
          <div className="relative">
            <button
              onClick={() => setAlertsOpen(!alertsOpen)}
              className="p-1.5 rounded-xl border border-[#E6E2D8] bg-white text-gray-700 hover:bg-[#F9F8F5] relative"
              title="Notifications"
            >
              <Bell className="w-4 h-4 text-[#18221E]" />
              {unreadAlerts.length > 0 && (
                <span className="absolute -top-1 -right-1 w-4 h-4 bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center animate-pulse">
                  {unreadAlerts.length}
                </span>
              )}
            </button>

            {alertsOpen && (
              <div className="absolute right-0 mt-2 w-80 sm:w-96 bg-white rounded-2xl shadow-2xl border border-[#E6E2D8] p-3 z-50">
                <div className="flex items-center justify-between pb-2 mb-2 border-b border-[#F0ECE2]">
                  <span className="text-xs font-bold text-[#18221E] uppercase tracking-wider">
                    Hub Notifications ({alerts.length})
                  </span>
                  <span className="text-[11px] text-[#2D6A4F] font-semibold cursor-pointer">
                    Kurnool Live Feed
                  </span>
                </div>
                <div className="space-y-2 max-h-80 overflow-y-auto pr-1">
                  {alerts.map((alert) => (
                    <div
                      key={alert.id}
                      onClick={() => markAlertAsRead(alert.id)}
                      className={`p-2.5 rounded-xl border text-xs cursor-pointer transition-all ${
                        alert.read
                          ? 'bg-[#FAF9F5] border-[#EAE6DD] text-gray-600'
                          : alert.severity === 'critical' || alert.severity === 'warning'
                          ? 'bg-amber-50/70 border-amber-200 text-amber-950 font-medium'
                          : 'bg-emerald-50/70 border-emerald-200 text-emerald-950'
                      }`}
                    >
                      <div className="flex items-center justify-between mb-1">
                        <span className="font-bold flex items-center gap-1.5">
                          {alert.title}
                        </span>
                        <span className="text-[10px] text-gray-400">{alert.timestamp}</span>
                      </div>
                      <p className="text-[11px] text-gray-700 leading-relaxed">{alert.message}</p>
                    </div>
                  ))}
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
};
