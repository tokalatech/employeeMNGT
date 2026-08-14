import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, Button, BottomSheet } from '../common/UIComponents';
import {
  Settings as SettingsIcon,
  Moon,
  Sun,
  Smartphone,
  Layers,
  Code2,
  RefreshCw,
  ShieldCheck,
  CheckCircle2,
  AlertCircle,
  WifiOff,
  Database,
  Terminal,
} from 'lucide-react';
import { AppStateMode } from '../../types';

export const SettingsScreen: React.FC = () => {
  const {
    isDarkMode,
    toggleDarkMode,
    deviceFrame,
    setDeviceFrame,
    appStateMode,
    setAppStateMode,
    showFlutterSpec,
    setShowFlutterSpec,
  } = useApp();

  const [showResetSuccess, setShowResetSuccess] = useState(false);

  const handleResetData = () => {
    setShowResetSuccess(true);
    setTimeout(() => setShowResetSuccess(false), 3000);
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <SettingsIcon className="w-5 h-5 text-slate-600 dark:text-slate-400" /> App & Environment Settings
          </h2>
          <p className="text-xs text-slate-500">Theme, device frames & state mode controls</p>
        </div>
      </div>

      {/* Theme Preference */}
      <Card className="p-4 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="w-10 h-10 rounded-2xl bg-indigo-50 dark:bg-indigo-950/60 flex items-center justify-center text-[#4F39F6]">
            {isDarkMode ? <Moon className="w-5 h-5" /> : <Sun className="w-5 h-5" />}
          </div>
          <div>
            <h4 className="font-bold text-sm text-slate-900 dark:text-white">Dark Theme Mode</h4>
            <p className="text-xs text-slate-500">Switch between light and dark visual themes</p>
          </div>
        </div>
        <button
          onClick={toggleDarkMode}
          className={`w-12 h-6 rounded-full p-1 transition-colors relative ${
            isDarkMode ? 'bg-[#4F39F6]' : 'bg-slate-300'
          }`}
        >
          <div
            className={`w-4 h-4 rounded-full bg-white transition-transform ${
              isDarkMode ? 'translate-x-6' : 'translate-x-0'
            }`}
          />
        </button>
      </Card>

      {/* Device Preview Shell */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">
          Device Frame Experience
        </h3>
        <Card className="p-4 space-y-3">
          <div className="flex items-center gap-3">
            <Smartphone className="w-5 h-5 text-[#4F39F6]" />
            <div>
              <h4 className="font-bold text-sm text-slate-900 dark:text-white">Active Device Mockup</h4>
              <p className="text-xs text-slate-500">Preview app in native iOS or Android shell</p>
            </div>
          </div>

          <div className="grid grid-cols-3 gap-2 pt-2">
            {[
              { id: 'iphone16', label: 'iPhone 16 Pro' },
              { id: 'pixel9', label: 'Pixel 9 Pro' },
              { id: 'responsive', label: 'Full Screen' },
            ].map((frame) => (
              <button
                key={frame.id}
                onClick={() => setDeviceFrame(frame.id as any)}
                className={`py-2 px-3 rounded-xl text-xs font-bold border transition-all ${
                  deviceFrame === frame.id
                    ? 'bg-[#4F39F6] text-white border-[#4F39F6] shadow-xs'
                    : 'bg-slate-50 dark:bg-slate-900 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-800'
                }`}
              >
                {frame.label}
              </button>
            ))}
          </div>
        </Card>
      </div>

      {/* App State Mode (Loading, Empty, Error, Offline) */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">
          State Simulator & Edge-Case Testing
        </h3>
        <Card className="p-4 space-y-3">
          <div className="flex items-center gap-3">
            <Layers className="w-5 h-5 text-amber-500" />
            <div>
              <h4 className="font-bold text-sm text-slate-900 dark:text-white">Simulation Mode</h4>
              <p className="text-xs text-slate-500">Test app behavior under non-standard conditions</p>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-2 pt-1">
            {[
              { id: 'normal', label: 'Normal Data', icon: CheckCircle2, color: 'text-emerald-500' },
              { id: 'loading', label: 'Loading Skeleton', icon: RefreshCw, color: 'text-sky-500' },
              { id: 'empty', label: 'Empty State', icon: AlertCircle, color: 'text-amber-500' },
              { id: 'error', label: 'Error Exception', icon: AlertCircle, color: 'text-rose-500' },
              { id: 'offline', label: 'Offline / Cached', icon: WifiOff, color: 'text-indigo-500' },
            ].map((st) => {
              const Icon = st.icon;
              return (
                <button
                  key={st.id}
                  onClick={() => setAppStateMode(st.id as AppStateMode)}
                  className={`flex items-center gap-2 p-2.5 rounded-xl text-xs font-bold border text-left transition-all ${
                    appStateMode === st.id
                      ? 'bg-[#4F39F6] text-white border-[#4F39F6]'
                      : 'bg-slate-50 dark:bg-slate-900 text-slate-800 dark:text-slate-200 border-slate-200 dark:border-slate-800'
                  }`}
                >
                  <Icon className={`w-4 h-4 ${appStateMode === st.id ? 'text-white' : st.color}`} />
                  <span>{st.label}</span>
                </button>
              );
            })}
          </div>
        </Card>
      </div>

      {/* Flutter Mobile Architecture Spec */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">
          Mobile Developer Architecture
        </h3>
        <Card
          onClick={() => setShowFlutterSpec(true)}
          className="p-4 bg-gradient-to-r from-slate-900 to-[#0F172B] text-white border-0 shadow-md flex items-center justify-between cursor-pointer"
        >
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-indigo-500/20 text-indigo-300 flex items-center justify-center">
              <Code2 className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-sm text-white">Flutter Architecture Specs</h4>
              <p className="text-xs text-indigo-200">Inspect state tree, clean architecture & APIs</p>
            </div>
          </div>
          <Terminal className="w-5 h-5 text-indigo-400" />
        </Card>
      </div>

      {/* Reset Cache */}
      <div className="pt-2">
        <Button variant="outline" fullWidth onClick={handleResetData}>
          <RefreshCw className="w-4 h-4 mr-1" /> Reset Local State & Seed Mock Data
        </Button>
        {showResetSuccess && (
          <p className="text-center text-xs font-bold text-emerald-600 mt-2">
            ✓ Mock state successfully re-initialized!
          </p>
        )}
      </div>

      {/* FLUTTER ARCHITECTURE SPEC SHEET */}
      <BottomSheet
        isOpen={showFlutterSpec}
        onClose={() => setShowFlutterSpec(false)}
        title="Flutter Mobile Architecture & Blueprint Spec"
      >
        <div className="space-y-4 text-xs font-sans">
          <div className="p-3.5 bg-slate-900 text-emerald-400 rounded-2xl font-mono text-[11px] space-y-1">
            <p className="text-white font-bold">// Pulse HRMS — Flutter Architecture Map</p>
            <p>Framework: Flutter 3.24+ (Dart 3.5)</p>
            <p>State Management: BLoC / Provider Pattern</p>
            <p>Local Persistence: Hive / Drift (SQLite)</p>
            <p>Network: Dio with Offline Queue Interceptor</p>
          </div>

          <div className="p-3.5 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 space-y-2">
            <h4 className="font-bold text-xs text-[#4F39F6] uppercase">Core Widget Hierarchy</h4>
            <ul className="list-disc pl-4 space-y-1 text-slate-700 dark:text-slate-300">
              <li><strong>AppShellWidget:</strong> Implements BottomNavigationBar & Device Frame wrapper.</li>
              <li><strong>AttendanceTimerBloc:</strong> Handles live ticking timer & geofenced check-in.</li>
              <li><strong>LeaveApprovalBloc:</strong> Handles manager action queues with optimistic UI updates.</li>
              <li><strong>OfflineSyncManager:</strong> Caches local clock-in actions when offline.</li>
            </ul>
          </div>

          <div className="p-3.5 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 space-y-2">
            <h4 className="font-bold text-xs text-[#4F39F6] uppercase">REST & Firestore API Contract</h4>
            <div className="font-mono text-[10px] bg-slate-100 dark:bg-slate-800 p-2 rounded-xl text-slate-800 dark:text-slate-200 space-y-1">
              <p>POST /api/v1/attendance/clock-in</p>
              <p>POST /api/v1/attendance/clock-out</p>
              <p>GET  /api/v1/leaves/balances</p>
              <p>POST /api/v1/leaves/apply</p>
              <p>PUT  /api/v1/manager/leaves/:id/approve</p>
            </div>
          </div>
        </div>
      </BottomSheet>
    </div>
  );
};
