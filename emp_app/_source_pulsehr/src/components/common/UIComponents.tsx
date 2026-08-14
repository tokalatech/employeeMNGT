import React from 'react';
import { LucideIcon, X, AlertCircle, RefreshCw, WifiOff } from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';

// Card Primitive
export const Card: React.FC<{
  children: React.ReactNode;
  className?: string;
  onClick?: () => void;
  id?: string;
}> = ({ children, className = '', onClick, id }) => {
  return (
    <div
      id={id}
      onClick={onClick}
      className={`bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200/80 dark:border-slate-800 p-4 shadow-xs transition-all ${
        onClick ? 'active:scale-[0.98] cursor-pointer hover:border-indigo-300 dark:hover:border-indigo-800' : ''
      } ${className}`}
    >
      {children}
    </div>
  );
};

// Status Badge Primitive
export const StatusBadge: React.FC<{
  status: string;
  variant?: 'success' | 'warning' | 'error' | 'info' | 'neutral' | 'primary';
  size?: 'sm' | 'md';
}> = ({ status, variant, size = 'sm' }) => {
  let colorClasses = 'bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300';

  const lower = (variant || status).toLowerCase();

  if (
    lower.includes('approved') ||
    lower.includes('present') ||
    lower.includes('working') ||
    lower.includes('completed') ||
    lower.includes('paid') ||
    lower.includes('on track') ||
    lower === 'success'
  ) {
    colorClasses = 'bg-emerald-50 text-emerald-700 border border-emerald-200 dark:bg-emerald-950/50 dark:text-emerald-300 dark:border-emerald-800';
  } else if (
    lower.includes('pending') ||
    lower.includes('late') ||
    lower.includes('at risk') ||
    lower.includes('in progress') ||
    lower === 'warning'
  ) {
    colorClasses = 'bg-amber-50 text-amber-700 border border-amber-200 dark:bg-amber-950/50 dark:text-amber-300 dark:border-amber-800';
  } else if (
    lower.includes('rejected') ||
    lower.includes('absent') ||
    lower.includes('urgent') ||
    lower.includes('cancelled') ||
    lower === 'error'
  ) {
    colorClasses = 'bg-rose-50 text-rose-700 border border-rose-200 dark:bg-rose-950/50 dark:text-rose-300 dark:border-rose-800';
  } else if (
    lower.includes('leave') ||
    lower.includes('open') ||
    lower.includes('casual') ||
    lower.includes('primary')
  ) {
    colorClasses = 'bg-indigo-50 text-indigo-700 border border-indigo-200 dark:bg-indigo-950/50 dark:text-indigo-300 dark:border-indigo-800';
  } else if (lower.includes('work from home') || lower.includes('wfh')) {
    colorClasses = 'bg-sky-50 text-sky-700 border border-sky-200 dark:bg-sky-950/50 dark:text-sky-300 dark:border-sky-800';
  }

  const sizeClasses = size === 'sm' ? 'px-2.5 py-0.5 text-xs' : 'px-3 py-1 text-sm';

  return (
    <span className={`inline-flex items-center gap-1 font-medium rounded-full whitespace-nowrap ${sizeClasses} ${colorClasses}`}>
      <span className="w-1.5 h-1.5 rounded-full bg-current opacity-70"></span>
      {status}
    </span>
  );
};

// Button Primitive
export const Button: React.FC<{
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary' | 'danger' | 'outline' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  fullWidth?: boolean;
  disabled?: boolean;
  loading?: boolean;
  icon?: LucideIcon;
  id?: string;
}> = ({
  children,
  onClick,
  variant = 'primary',
  size = 'md',
  fullWidth = false,
  disabled = false,
  loading = false,
  icon: Icon,
  id,
}) => {
  let baseStyle =
    'inline-flex items-center justify-center font-medium rounded-xl transition-all active:scale-[0.98] disabled:opacity-50 disabled:pointer-events-none select-none';

  let variantStyle = 'bg-[#4F39F6] text-white hover:bg-[#4331D4] shadow-xs';
  if (variant === 'secondary') {
    variantStyle = 'bg-slate-100 text-slate-800 dark:bg-slate-800 dark:text-slate-100 hover:bg-slate-200 dark:hover:bg-slate-700';
  } else if (variant === 'danger') {
    variantStyle = 'bg-rose-600 text-white hover:bg-rose-700 shadow-xs';
  } else if (variant === 'outline') {
    variantStyle = 'border border-slate-300 dark:border-slate-700 text-slate-700 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-800';
  } else if (variant === 'ghost') {
    variantStyle = 'text-slate-600 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-800';
  }

  let sizeStyle = 'px-4 py-2 text-sm gap-2';
  if (size === 'sm') sizeStyle = 'px-3 py-1.5 text-xs gap-1.5';
  if (size === 'lg') sizeStyle = 'px-5 py-3 text-base gap-2.5';

  return (
    <button
      id={id}
      onClick={onClick}
      disabled={disabled || loading}
      className={`${baseStyle} ${variantStyle} ${sizeStyle} ${fullWidth ? 'w-full' : ''}`}
    >
      {loading ? (
        <RefreshCw className="w-4 h-4 animate-spin" />
      ) : Icon ? (
        <Icon className={size === 'sm' ? 'w-3.5 h-3.5' : 'w-4 h-4'} />
      ) : null}
      {children}
    </button>
  );
};

// Form Inputs
export const Input: React.FC<{
  label?: string;
  type?: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  placeholder?: string;
  error?: string;
  icon?: LucideIcon;
  id?: string;
}> = ({ label, type = 'text', value, onChange, placeholder, error, icon: Icon, id }) => {
  return (
    <div className="space-y-1.5">
      {label && <label className="block text-xs font-semibold uppercase tracking-wider text-slate-500 dark:text-slate-400">{label}</label>}
      <div className="relative">
        {Icon && (
          <div className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-400">
            <Icon className="w-4 h-4" />
          </div>
        )}
        <input
          id={id}
          type={type}
          value={value}
          onChange={onChange}
          placeholder={placeholder}
          className={`w-full bg-slate-50 dark:bg-slate-900 border rounded-xl px-3.5 py-2.5 text-sm text-slate-900 dark:text-slate-100 placeholder:text-slate-400 focus:outline-hidden focus:ring-2 focus:ring-[#4F39F6] ${
            Icon ? 'pl-10' : ''
          } ${error ? 'border-rose-500' : 'border-slate-200 dark:border-slate-800'}`}
        />
      </div>
      {error && <p className="text-xs text-rose-500">{error}</p>}
    </div>
  );
};

// Bottom Sheet / Modal Primitive
export const BottomSheet: React.FC<{
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}> = ({ isOpen, onClose, title, children }) => {
  return (
    <AnimatePresence>
      {isOpen && (
        <>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-black/60 backdrop-blur-xs z-40"
          />
          <motion.div
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', damping: 25, stiffness: 300 }}
            className="absolute bottom-0 inset-x-0 bg-white dark:bg-[#131C2E] rounded-t-3xl p-5 z-50 max-h-[85%] overflow-y-auto border-t border-slate-200 dark:border-slate-800 shadow-2xl"
          >
            <div className="w-12 h-1.5 bg-slate-200 dark:bg-slate-700 rounded-full mx-auto mb-4" />
            <div className="flex items-center justify-between pb-3 border-b border-slate-100 dark:border-slate-800 mb-4">
              <h3 className="text-lg font-bold text-slate-900 dark:text-slate-100">{title}</h3>
              <button
                onClick={onClose}
                className="p-1.5 rounded-full hover:bg-slate-100 dark:hover:bg-slate-800 text-slate-500"
              >
                <X className="w-5 h-5" />
              </button>
            </div>
            {children}
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
};

// Confirmation Dialog Primitive
export const DialogModal: React.FC<{
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  title: string;
  description: string;
  confirmText?: string;
  cancelText?: string;
  variant?: 'danger' | 'primary';
}> = ({
  isOpen,
  onClose,
  onConfirm,
  title,
  description,
  confirmText = 'Confirm',
  cancelText = 'Cancel',
  variant = 'primary',
}) => {
  return (
    <AnimatePresence>
      {isOpen && (
        <>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="absolute inset-0 bg-black/60 backdrop-blur-xs z-50"
          />
          <motion.div
            initial={{ scale: 0.9, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.9, opacity: 0 }}
            className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[90%] max-w-sm bg-white dark:bg-[#131C2E] rounded-2xl p-5 z-50 shadow-2xl border border-slate-200 dark:border-slate-800"
          >
            <h4 className="text-base font-bold text-slate-900 dark:text-slate-100 mb-2">{title}</h4>
            <p className="text-sm text-slate-600 dark:text-slate-300 mb-6">{description}</p>
            <div className="flex gap-2 justify-end">
              <Button variant="ghost" onClick={onClose}>
                {cancelText}
              </Button>
              <Button
                variant={variant === 'danger' ? 'danger' : 'primary'}
                onClick={() => {
                  onConfirm();
                  onClose();
                }}
              >
                {confirmText}
              </Button>
            </div>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
};

// Skeleton Loader
export const SkeletonCard: React.FC = () => {
  return (
    <div className="bg-white dark:bg-[#131C2E] rounded-2xl p-4 border border-slate-200 dark:border-slate-800 space-y-3 animate-pulse">
      <div className="h-4 bg-slate-200 dark:bg-slate-800 rounded-md w-1/3" />
      <div className="h-8 bg-slate-200 dark:bg-slate-800 rounded-xl w-2/3" />
      <div className="h-3 bg-slate-200 dark:bg-slate-800 rounded-md w-1/2" />
    </div>
  );
};

// Empty State Primitive
export const EmptyState: React.FC<{
  title: string;
  description: string;
  actionText?: string;
  onAction?: () => void;
  icon?: LucideIcon;
}> = ({ title, description, actionText, onAction, icon: Icon = AlertCircle }) => {
  return (
    <div className="flex flex-col items-center justify-center p-8 text-center bg-white dark:bg-[#131C2E] rounded-2xl border border-slate-200 dark:border-slate-800 my-4">
      <div className="w-12 h-12 rounded-2xl bg-indigo-50 dark:bg-indigo-950/50 flex items-center justify-center text-[#4F39F6] mb-3">
        <Icon className="w-6 h-6" />
      </div>
      <h4 className="text-base font-bold text-slate-900 dark:text-slate-100">{title}</h4>
      <p className="text-xs text-slate-500 dark:text-slate-400 max-w-xs mt-1 mb-4">{description}</p>
      {actionText && onAction && (
        <Button size="sm" onClick={onAction}>
          {actionText}
        </Button>
      )}
    </div>
  );
};

// Offline Banner Primitive
export const OfflineBanner: React.FC = () => {
  return (
    <div className="bg-amber-500 text-white px-4 py-2 text-xs font-semibold flex items-center justify-center gap-2">
      <WifiOff className="w-3.5 h-3.5" />
      <span>Offline Mode — Showing cached Flutter HRMS local storage data</span>
    </div>
  );
};
