import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, Button, BottomSheet, Input } from '../common/UIComponents';
import {
  User,
  Mail,
  Phone,
  Briefcase,
  Calendar,
  Building,
  ShieldCheck,
  UserCheck,
  LogOut,
  Edit2,
  HeartHandshake,
  MapPin,
  CheckCircle2,
} from 'lucide-react';

export const ProfileScreen: React.FC = () => {
  const { user, role, setRole, logout } = useApp();

  const [showEditEmergency, setShowEditEmergency] = useState(false);
  const [emergencyName, setEmergencyName] = useState(user.emergencyContact?.name || 'Sarah Jenkins');
  const [emergencyRelation, setEmergencyRelation] = useState(user.emergencyContact?.relationship || 'Spouse');
  const [emergencyPhone, setEmergencyPhone] = useState(user.emergencyContact?.phone || '+1 (555) 987-6543');

  const handleSaveEmergency = (e: React.FormEvent) => {
    e.preventDefault();
    user.emergencyContact = {
      name: emergencyName,
      relationship: emergencyRelation,
      phone: emergencyPhone,
    };
    setShowEditEmergency(false);
  };

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Profile Card Header */}
      <Card className="bg-gradient-to-br from-[#0F172B] via-[#1E293B] to-[#111827] text-white p-5 border-0 shadow-xl space-y-4">
        <div className="flex items-center gap-4">
          <div className="relative">
            <img
              src={user.avatar}
              alt={user.name}
              className="w-16 h-16 rounded-full object-cover border-2 border-[#4F39F6] shadow-md"
            />
            <span className="absolute bottom-0 right-0 w-4 h-4 bg-emerald-500 border-2 border-[#0F172B] rounded-full" />
          </div>
          <div>
            <span className="text-[10px] font-extrabold uppercase tracking-widest text-indigo-300">
              {user.employeeId} • {user.employmentType}
            </span>
            <h2 className="text-lg font-black text-white">{user.name}</h2>
            <p className="text-xs text-indigo-200">{user.designation}</p>
          </div>
        </div>

        {/* Role Switcher Pill */}
        <div className="p-3 bg-white/10 backdrop-blur-md rounded-2xl flex items-center justify-between border border-white/10">
          <div>
            <span className="text-[10px] uppercase font-bold text-indigo-200 block">Current Active Role</span>
            <p className="text-xs font-black text-white flex items-center gap-1.5 mt-0.5">
              <ShieldCheck className="w-4 h-4 text-emerald-400" />
              {role === 'MANAGER' ? 'People Manager (Admin View)' : 'Employee (Individual Contributor)'}
            </p>
          </div>
          <button
            onClick={() => setRole(role === 'EMPLOYEE' ? 'MANAGER' : 'EMPLOYEE')}
            className="px-3 py-1.5 bg-[#4F39F6] hover:bg-[#3D28E0] text-white rounded-xl text-xs font-bold transition-all shadow-xs"
          >
            Switch to {role === 'EMPLOYEE' ? 'Manager' : 'Employee'}
          </button>
        </div>
      </Card>

      {/* Primary Work Information */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">Employment Information</h3>
        <Card className="p-4 space-y-3">
          <div className="flex items-center gap-3 text-xs">
            <Building className="w-4 h-4 text-[#4F39F6] shrink-0" />
            <div>
              <span className="text-[10px] text-slate-400 block font-semibold">Department</span>
              <span className="font-bold text-slate-900 dark:text-slate-100">{user.department}</span>
            </div>
          </div>

          <div className="flex items-center gap-3 text-xs border-t border-slate-100 dark:border-slate-800 pt-2.5">
            <Calendar className="w-4 h-4 text-[#4F39F6] shrink-0" />
            <div>
              <span className="text-[10px] text-slate-400 block font-semibold">Joining Date</span>
              <span className="font-bold text-slate-900 dark:text-slate-100">{user.joiningDate}</span>
            </div>
          </div>

          {user.managerName && (
            <div className="flex items-center gap-3 text-xs border-t border-slate-100 dark:border-slate-800 pt-2.5">
              <UserCheck className="w-4 h-4 text-[#4F39F6] shrink-0" />
              <div>
                <span className="text-[10px] text-slate-400 block font-semibold">Reporting Manager</span>
                <span className="font-bold text-slate-900 dark:text-slate-100">{user.managerName}</span>
              </div>
            </div>
          )}
        </Card>
      </div>

      {/* Personal Contact Details */}
      <div className="space-y-2">
        <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">Contact Details</h3>
        <Card className="p-4 space-y-3">
          <div className="flex items-center gap-3 text-xs">
            <Mail className="w-4 h-4 text-[#4F39F6] shrink-0" />
            <div>
              <span className="text-[10px] text-slate-400 block font-semibold">Corporate Email</span>
              <span className="font-bold text-slate-900 dark:text-slate-100">{user.email}</span>
            </div>
          </div>

          <div className="flex items-center gap-3 text-xs border-t border-slate-100 dark:border-slate-800 pt-2.5">
            <Phone className="w-4 h-4 text-[#4F39F6] shrink-0" />
            <div>
              <span className="text-[10px] text-slate-400 block font-semibold">Phone Number</span>
              <span className="font-bold text-slate-900 dark:text-slate-100">{user.phone || '+1 (555) 234-5678'}</span>
            </div>
          </div>

          <div className="flex items-center gap-3 text-xs border-t border-slate-100 dark:border-slate-800 pt-2.5">
            <MapPin className="w-4 h-4 text-[#4F39F6] shrink-0" />
            <div>
              <span className="text-[10px] text-slate-400 block font-semibold">Residential Address</span>
              <span className="font-bold text-slate-900 dark:text-slate-100">
                {user.address || '742 Evergreen Terrace, San Francisco, CA'}
              </span>
            </div>
          </div>
        </Card>
      </div>

      {/* Emergency Contact */}
      <div className="space-y-2">
        <div className="flex items-center justify-between">
          <h3 className="text-xs font-bold uppercase tracking-wider text-slate-500">Emergency Contact</h3>
          <button
            onClick={() => setShowEditEmergency(true)}
            className="text-xs font-bold text-[#4F39F6] flex items-center gap-1"
          >
            <Edit2 className="w-3.5 h-3.5" /> Edit
          </button>
        </div>
        <Card className="p-4 flex items-center justify-between bg-rose-50/50 dark:bg-rose-950/20 border-rose-200 dark:border-rose-900/50">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-2xl bg-rose-100 dark:bg-rose-900/60 flex items-center justify-center text-rose-600 font-bold">
              <HeartHandshake className="w-5 h-5" />
            </div>
            <div>
              <h4 className="font-bold text-sm text-slate-900 dark:text-white">{emergencyName}</h4>
              <p className="text-xs text-slate-500">{emergencyRelation} • {emergencyPhone}</p>
            </div>
          </div>
        </Card>
      </div>

      {/* Logout */}
      <div className="pt-2">
        <Button variant="danger" fullWidth onClick={logout} className="py-3">
          <LogOut className="w-4 h-4 mr-1" /> Sign Out Account
        </Button>
      </div>

      {/* EDIT EMERGENCY CONTACT SHEET */}
      <BottomSheet
        isOpen={showEditEmergency}
        onClose={() => setShowEditEmergency(false)}
        title="Update Emergency Contact"
      >
        <form onSubmit={handleSaveEmergency} className="space-y-4">
          <Input
            label="Contact Full Name"
            value={emergencyName}
            onChange={(e) => setEmergencyName(e.target.value)}
          />
          <Input
            label="Relationship"
            value={emergencyRelation}
            onChange={(e) => setEmergencyRelation(e.target.value)}
          />
          <Input
            label="Mobile Phone"
            value={emergencyPhone}
            onChange={(e) => setEmergencyPhone(e.target.value)}
          />
          <Button fullWidth size="lg">
            <CheckCircle2 className="w-4 h-4 mr-1" /> Save Changes
          </Button>
        </form>
      </BottomSheet>
    </div>
  );
};
