import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import {
  Shield,
  Eye,
  EyeOff,
  Lock,
  Mail,
  User,
  Building,
  ArrowRight,
  CheckCircle2,
  UserPlus,
  Briefcase,
  KeyRound,
} from 'lucide-react';
import { Button, Input } from '../common/UIComponents';
import { UserRole } from '../../types';

export const AuthScreen: React.FC = () => {
  const { activeScreen, setActiveScreen, login, signUp, user } = useApp();

  const [authMode, setAuthMode] = useState<'login' | 'signup'>('login');

  // Login form state
  const [email, setEmail] = useState(user.email);
  const [password, setPassword] = useState('••••••••••••');
  const [showPassword, setShowPassword] = useState(false);
  const [rememberMe, setRememberMe] = useState(true);

  // Signup form state
  const [fullName, setFullName] = useState('');
  const [signupEmail, setSignupEmail] = useState('');
  const [department, setDepartment] = useState('Engineering');
  const [signupRole, setSignupRole] = useState<UserRole>('EMPLOYEE');
  const [signupPassword, setSignupPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [showSignupPassword, setShowSignupPassword] = useState(false);
  const [agreeTerms, setAgreeTerms] = useState(true);

  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState('');
  const [successMessage, setSuccessMessage] = useState('');

  if (activeScreen === 'splash') {
    return (
      <div className="min-h-full flex flex-col items-center justify-between p-6 bg-[#0F172B] text-white text-center">
        <div className="flex-1 flex flex-col items-center justify-center space-y-4">
          <div className="w-20 h-20 bg-[#4F39F6] rounded-3xl flex items-center justify-center shadow-2xl shadow-indigo-500/50 animate-bounce">
            <Shield className="w-10 h-10 text-white" />
          </div>
          <div>
            <h1 className="text-2xl font-black tracking-tight">PulseHR Mobile</h1>
            <p className="text-xs text-indigo-300 mt-1">Enterprise Employee Self-Service</p>
          </div>
        </div>

        <div className="w-full space-y-3 pb-8">
          <div className="flex justify-center items-center gap-2 text-xs text-slate-400">
            <div className="w-2 h-2 rounded-full bg-emerald-400 animate-ping"></div>
            <span>Connecting to HRMS Cloud Engine...</span>
          </div>
          <Button fullWidth onClick={() => setActiveScreen('login')}>
            Continue to Sign In <ArrowRight className="w-4 h-4 ml-1" />
          </Button>
        </div>
      </div>
    );
  }

  const handleLoginSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!email) {
      setError('Please enter your Employee Email or ID');
      return;
    }
    setError('');
    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      login();
    }, 600);
  };

  const handleSignupSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    setSuccessMessage('');

    if (!fullName.trim()) {
      setError('Please enter your full name.');
      return;
    }
    if (!signupEmail.trim() || !signupEmail.includes('@')) {
      setError('Please enter a valid work email address.');
      return;
    }
    if (!signupPassword) {
      setError('Please create a password.');
      return;
    }
    if (signupPassword.length < 6) {
      setError('Password must be at least 6 characters.');
      return;
    }
    if (signupPassword !== confirmPassword) {
      setError('Passwords do not match.');
      return;
    }
    if (!agreeTerms) {
      setError('You must agree to the Terms of Service to create an account.');
      return;
    }

    setIsLoading(true);
    setTimeout(() => {
      setIsLoading(false);
      setSuccessMessage('Account created successfully! Logging you in...');
      setTimeout(() => {
        signUp(fullName, signupEmail, signupRole, department);
      }, 500);
    }, 800);
  };

  return (
    <div className="min-h-full flex flex-col justify-between p-5 bg-slate-50 dark:bg-[#0B1120] overflow-y-auto">
      {/* Top Header */}
      <div className="pt-4 text-center space-y-2">
        <div className="w-12 h-12 bg-[#4F39F6] rounded-2xl flex items-center justify-center mx-auto shadow-lg shadow-indigo-500/30">
          <Shield className="w-7 h-7 text-white" />
        </div>
        <h2 className="text-xl font-black text-slate-900 dark:text-white">
          {authMode === 'login' ? 'Welcome Back' : 'Create Employee Account'}
        </h2>
        <p className="text-xs text-slate-500 dark:text-slate-400 max-w-xs mx-auto">
          {authMode === 'login'
            ? 'Sign in to access your attendance, leaves, payslips & team dashboard'
            : 'Register your employee profile to get instant access to PulseHR'}
        </p>
      </div>

      {/* Auth Mode Toggle Tabs */}
      <div className="flex bg-slate-200 dark:bg-slate-900 p-1 rounded-2xl border border-slate-300 dark:border-slate-800 my-3">
        <button
          type="button"
          onClick={() => {
            setAuthMode('login');
            setError('');
          }}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            authMode === 'login'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500 hover:text-slate-700'
          }`}
        >
          Sign In
        </button>
        <button
          type="button"
          onClick={() => {
            setAuthMode('signup');
            setError('');
          }}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            authMode === 'signup'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500 hover:text-slate-700'
          }`}
        >
          Sign Up
        </button>
      </div>

      {/* LOGIN FORM */}
      {authMode === 'login' && (
        <form
          onSubmit={handleLoginSubmit}
          className="space-y-3.5 bg-white dark:bg-[#131C2E] p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-md my-auto"
        >
          <Input
            label="Email or Employee ID"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            placeholder="alex.morgan@company.com"
            icon={Mail}
          />

          <div className="space-y-1.5">
            <div className="flex justify-between items-center">
              <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
                Password
              </label>
              <button
                type="button"
                className="text-xs font-semibold text-[#4F39F6] hover:underline"
                onClick={() => alert('Password reset link sent to your registered email.')}
              >
                Forgot Password?
              </button>
            </div>
            <div className="relative">
              <input
                type={showPassword ? 'text' : 'password'}
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3.5 py-2.5 text-sm text-slate-900 dark:text-slate-100 pr-10 focus:ring-2 focus:ring-[#4F39F6]"
              />
              <button
                type="button"
                onClick={() => setShowPassword(!showPassword)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
              >
                {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>
          </div>

          {error && (
            <p className="text-xs text-rose-500 bg-rose-50 dark:bg-rose-950/40 p-2.5 rounded-xl border border-rose-200 dark:border-rose-900 font-medium">
              {error}
            </p>
          )}

          <div className="flex items-center gap-2 pt-1">
            <input
              type="checkbox"
              id="remember"
              checked={rememberMe}
              onChange={(e) => setRememberMe(e.target.checked)}
              className="w-4 h-4 rounded text-[#4F39F6] focus:ring-[#4F39F6]"
            />
            <label htmlFor="remember" className="text-xs text-slate-600 dark:text-slate-300">
              Remember my biometric credentials
            </label>
          </div>

          <Button fullWidth size="lg" loading={isLoading}>
            <Lock className="w-4 h-4 mr-1" />
            Sign In
          </Button>

          <p className="text-center text-xs text-slate-500 pt-2 border-t border-slate-100 dark:border-slate-800">
            Don't have an employee account?{' '}
            <button
              type="button"
              onClick={() => {
                setAuthMode('signup');
                setError('');
              }}
              className="font-bold text-[#4F39F6] hover:underline"
            >
              Sign Up
            </button>
          </p>
        </form>
      )}

      {/* SIGN UP FORM */}
      {authMode === 'signup' && (
        <form
          onSubmit={handleSignupSubmit}
          className="space-y-3 bg-white dark:bg-[#131C2E] p-4 rounded-2xl border border-slate-200 dark:border-slate-800 shadow-md my-auto"
        >
          <Input
            label="Full Name"
            value={fullName}
            onChange={(e) => setFullName(e.target.value)}
            placeholder="e.g. Sarah Jenkins"
            icon={User}
          />

          <Input
            label="Work Email Address"
            type="email"
            value={signupEmail}
            onChange={(e) => setSignupEmail(e.target.value)}
            placeholder="sarah.jenkins@company.com"
            icon={Mail}
          />

          <div className="space-y-1">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Department
            </label>
            <div className="relative">
              <select
                value={department}
                onChange={(e) => setDepartment(e.target.value)}
                className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3.5 py-2.5 text-sm text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-[#4F39F6]"
              >
                <option value="Engineering">Engineering & Technology</option>
                <option value="Product & Design">Product & Design</option>
                <option value="Human Resources">Human Resources (HR)</option>
                <option value="Sales & Marketing">Sales & Marketing</option>
                <option value="Operations & Finance">Operations & Finance</option>
              </select>
            </div>
          </div>

          <div className="space-y-1">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Account Role
            </label>
            <div className="grid grid-cols-2 gap-2">
              <button
                type="button"
                onClick={() => setSignupRole('EMPLOYEE')}
                className={`py-2 px-3 rounded-xl text-xs font-bold border flex items-center justify-center gap-1.5 transition-all ${
                  signupRole === 'EMPLOYEE'
                    ? 'bg-[#4F39F6] text-white border-[#4F39F6]'
                    : 'bg-slate-50 dark:bg-slate-900 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-800'
                }`}
              >
                <User className="w-3.5 h-3.5" /> Employee
              </button>
              <button
                type="button"
                onClick={() => setSignupRole('MANAGER')}
                className={`py-2 px-3 rounded-xl text-xs font-bold border flex items-center justify-center gap-1.5 transition-all ${
                  signupRole === 'MANAGER'
                    ? 'bg-amber-500 text-slate-950 border-amber-500'
                    : 'bg-slate-50 dark:bg-slate-900 text-slate-700 dark:text-slate-300 border-slate-200 dark:border-slate-800'
                }`}
              >
                <Briefcase className="w-3.5 h-3.5" /> Manager
              </button>
            </div>
          </div>

          <div className="space-y-1">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Password
            </label>
            <div className="relative">
              <input
                type={showSignupPassword ? 'text' : 'password'}
                value={signupPassword}
                onChange={(e) => setSignupPassword(e.target.value)}
                placeholder="At least 6 characters"
                className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3.5 py-2 text-sm text-slate-900 dark:text-slate-100 pr-10 focus:ring-2 focus:ring-[#4F39F6]"
              />
              <button
                type="button"
                onClick={() => setShowSignupPassword(!showSignupPassword)}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600"
              >
                {showSignupPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
              </button>
            </div>
          </div>

          <div className="space-y-1">
            <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">
              Confirm Password
            </label>
            <input
              type={showSignupPassword ? 'text' : 'password'}
              value={confirmPassword}
              onChange={(e) => setConfirmPassword(e.target.value)}
              placeholder="Re-enter password"
              className="w-full bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800 rounded-xl px-3.5 py-2 text-sm text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-[#4F39F6]"
            />
          </div>

          <div className="flex items-center gap-2 pt-0.5">
            <input
              type="checkbox"
              id="terms"
              checked={agreeTerms}
              onChange={(e) => setAgreeTerms(e.target.checked)}
              className="w-4 h-4 rounded text-[#4F39F6] focus:ring-[#4F39F6]"
            />
            <label htmlFor="terms" className="text-[11px] text-slate-600 dark:text-slate-300">
              I agree to the Enterprise HR Security & Privacy Terms
            </label>
          </div>

          {error && (
            <p className="text-xs text-rose-500 bg-rose-50 dark:bg-rose-950/40 p-2.5 rounded-xl border border-rose-200 dark:border-rose-900 font-medium">
              {error}
            </p>
          )}

          {successMessage && (
            <p className="text-xs text-emerald-600 bg-emerald-50 dark:bg-emerald-950/40 p-2.5 rounded-xl border border-emerald-200 dark:border-emerald-900 font-medium">
              ✓ {successMessage}
            </p>
          )}

          <Button fullWidth size="lg" loading={isLoading}>
            <UserPlus className="w-4 h-4 mr-1" />
            Create Account & Sign In
          </Button>

          <p className="text-center text-xs text-slate-500 pt-2 border-t border-slate-100 dark:border-slate-800">
            Already registered?{' '}
            <button
              type="button"
              onClick={() => {
                setAuthMode('login');
                setError('');
              }}
              className="font-bold text-[#4F39F6] hover:underline"
            >
              Sign In
            </button>
          </p>
        </form>
      )}

      {/* Footer Info */}
      <div className="text-center text-[11px] text-slate-400 pt-2 pb-1 space-y-1">
        <p className="flex items-center justify-center gap-1">
          <CheckCircle2 className="w-3.5 h-3.5 text-emerald-500" /> Protected by SSL & Biometric Token Auth
        </p>
        <p>PulseHR v2.8.0 • Enterprise Edition</p>
      </div>
    </div>
  );
};
