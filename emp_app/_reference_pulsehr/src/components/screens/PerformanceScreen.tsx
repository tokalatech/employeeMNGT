import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { Card, StatusBadge, Button, BottomSheet } from '../common/UIComponents';
import {
  Award,
  Target,
  TrendingUp,
  Star,
  CheckCircle2,
  Clock,
  ChevronRight,
  MessageSquare,
} from 'lucide-react';
import { MOCK_GOALS, MOCK_PERFORMANCE_REVIEWS } from '../../mockData';
import { Goal, PerformanceReview } from '../../types';

export const PerformanceScreen: React.FC = () => {
  const [activeTab, setActiveTab] = useState<'goals' | 'reviews'>('goals');
  const [selectedGoal, setSelectedGoal] = useState<Goal | null>(null);
  const [selectedReview, setSelectedReview] = useState<PerformanceReview | null>(null);

  return (
    <div className="p-4 space-y-4 pb-20">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <Award className="w-5 h-5 text-amber-500" /> Performance & Goals
          </h2>
          <p className="text-xs text-slate-500">Track quarterly KPIs & performance reviews</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="flex bg-slate-100 dark:bg-slate-900 p-1 rounded-2xl border border-slate-200 dark:border-slate-800">
        <button
          onClick={() => setActiveTab('goals')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'goals'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          My Goals & KPIs ({MOCK_GOALS.length})
        </button>
        <button
          onClick={() => setActiveTab('reviews')}
          className={`flex-1 py-2 text-xs font-bold rounded-xl transition-all ${
            activeTab === 'reviews'
              ? 'bg-white dark:bg-[#131C2E] text-[#4F39F6] shadow-xs'
              : 'text-slate-500'
          }`}
        >
          Performance Reviews
        </button>
      </div>

      {/* GOALS TAB */}
      {activeTab === 'goals' && (
        <div className="space-y-3">
          {MOCK_GOALS.map((gl) => (
            <Card key={gl.id} onClick={() => setSelectedGoal(gl)} className="p-4 space-y-3">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <Target className="w-4 h-4 text-[#4F39F6]" />
                  <h4 className="font-bold text-sm text-slate-900 dark:text-slate-100">{gl.title}</h4>
                </div>
                <StatusBadge status={gl.status} />
              </div>

              <p className="text-xs text-slate-500 dark:text-slate-400 line-clamp-2">{gl.description}</p>

              <div>
                <div className="flex justify-between items-center text-xs font-semibold mb-1">
                  <span className="text-slate-600 dark:text-slate-300">Progress: {gl.currentValue}</span>
                  <span className="text-[#4F39F6] font-bold">{gl.progressPercent}%</span>
                </div>
                <div className="w-full bg-slate-100 dark:bg-slate-800 h-2.5 rounded-full overflow-hidden">
                  <div
                    className="h-full rounded-full transition-all bg-[#4F39F6]"
                    style={{ width: `${gl.progressPercent}%` }}
                  />
                </div>
              </div>

              <div className="flex justify-between items-center text-[11px] text-slate-400 pt-2 border-t border-slate-100 dark:border-slate-800">
                <span>Target: {gl.target}</span>
                <span>Deadline: {gl.deadline}</span>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* REVIEWS TAB */}
      {activeTab === 'reviews' && (
        <div className="space-y-3">
          {MOCK_PERFORMANCE_REVIEWS.map((rev) => (
            <Card key={rev.id} onClick={() => setSelectedReview(rev)} className="p-4 space-y-3">
              <div className="flex items-center justify-between">
                <div>
                  <h4 className="font-bold text-sm text-slate-900 dark:text-white">{rev.period}</h4>
                  <p className="text-[10px] text-slate-400">Reviewed on {rev.reviewDate}</p>
                </div>
                <div className="flex items-center gap-1 bg-amber-50 dark:bg-amber-950 px-2.5 py-1 rounded-xl border border-amber-200">
                  <Star className="w-4 h-4 text-amber-500 fill-amber-500" />
                  <span className="font-black text-amber-700 dark:text-amber-300 text-sm">{rev.overallRating} / 5.0</span>
                </div>
              </div>

              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-100 dark:border-slate-800 text-xs">
                <span className="font-bold text-slate-700 dark:text-slate-300 block mb-1">Manager Feedback:</span>
                <p className="text-slate-600 dark:text-slate-400 italic">"{rev.managerFeedback}"</p>
              </div>
            </Card>
          ))}
        </div>
      )}

      {/* GOAL DETAIL SHEET */}
      <BottomSheet
        isOpen={!!selectedGoal}
        onClose={() => setSelectedGoal(null)}
        title="Goal & KPI Details"
      >
        {selectedGoal && (
          <div className="space-y-4 text-xs">
            <div className="flex justify-between items-center p-3 rounded-2xl bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
              <div>
                <span className="text-[10px] text-slate-400 font-bold uppercase">KPI Title</span>
                <h4 className="font-bold text-sm text-slate-900 dark:text-white">{selectedGoal.title}</h4>
              </div>
              <StatusBadge status={selectedGoal.status} size="md" />
            </div>

            <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
              <span className="text-[10px] text-slate-400 font-bold uppercase block mb-1">Description</span>
              <p className="text-slate-800 dark:text-slate-200">{selectedGoal.description}</p>
            </div>

            <div className="p-3.5 bg-indigo-50 dark:bg-indigo-950/40 rounded-xl border border-indigo-200 dark:border-indigo-900 space-y-2">
              <div className="flex justify-between font-bold text-slate-800 dark:text-slate-200">
                <span>KPI Metric: {selectedGoal.kpi}</span>
                <span className="text-[#4F39F6]">{selectedGoal.progressPercent}%</span>
              </div>
              <div className="w-full bg-slate-200 dark:bg-slate-800 h-3 rounded-full overflow-hidden">
                <div
                  className="h-full bg-[#4F39F6] rounded-full"
                  style={{ width: `${selectedGoal.progressPercent}%` }}
                />
              </div>
            </div>

            {selectedGoal.managerComments && (
              <div className="p-3 bg-slate-50 dark:bg-slate-900 rounded-xl border border-slate-200 dark:border-slate-800">
                <span className="text-[10px] font-bold text-[#4F39F6] uppercase block mb-1">Manager Note</span>
                <p className="text-slate-700 dark:text-slate-300 italic">"{selectedGoal.managerComments}"</p>
              </div>
            )}
          </div>
        )}
      </BottomSheet>

      {/* REVIEW DETAIL SHEET */}
      <BottomSheet
        isOpen={!!selectedReview}
        onClose={() => setSelectedReview(null)}
        title="Performance Review Details"
      >
        {selectedReview && (
          <div className="space-y-4 text-xs">
            <div className="flex justify-between items-center p-4 rounded-2xl bg-gradient-to-r from-amber-500 to-amber-600 text-white">
              <div>
                <span className="text-[10px] uppercase font-bold text-amber-100">Overall Assessment</span>
                <h3 className="text-lg font-black">{selectedReview.period}</h3>
              </div>
              <div className="bg-white text-amber-700 px-3 py-1.5 rounded-xl font-black text-lg flex items-center gap-1">
                <Star className="w-5 h-5 fill-amber-500 text-amber-500" />
                <span>{selectedReview.overallRating}</span>
              </div>
            </div>

            <div className="p-3.5 bg-emerald-50 dark:bg-emerald-950/40 rounded-xl border border-emerald-200 dark:border-emerald-900 space-y-1.5">
              <h5 className="font-bold text-emerald-800 dark:text-emerald-300 uppercase text-[10px]">Key Strengths</h5>
              <ul className="list-disc pl-4 space-y-1 text-slate-700 dark:text-slate-300">
                {selectedReview.strengths.map((st, idx) => (
                  <li key={idx}>{st}</li>
                ))}
              </ul>
            </div>

            <div className="p-3.5 bg-indigo-50 dark:bg-indigo-950/40 rounded-xl border border-indigo-200 dark:border-indigo-900 space-y-1.5">
              <h5 className="font-bold text-[#4F39F6] uppercase text-[10px]">Growth & Focus Areas</h5>
              <ul className="list-disc pl-4 space-y-1 text-slate-700 dark:text-slate-300">
                {selectedReview.areasForImprovement.map((ar, idx) => (
                  <li key={idx}>{ar}</li>
                ))}
              </ul>
            </div>
          </div>
        )}
      </BottomSheet>
    </div>
  );
};
