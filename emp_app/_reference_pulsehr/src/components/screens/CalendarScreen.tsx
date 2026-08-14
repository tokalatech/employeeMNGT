import React, { useState } from 'react';
import { Card } from '../common/UIComponents';
import { Calendar as CalendarIcon, ChevronLeft, ChevronRight, Filter } from 'lucide-react';
import { MOCK_CALENDAR_EVENTS } from '../../mockData';

export const CalendarScreen: React.FC = () => {
  const [activeFilter, setActiveFilter] = useState('All');

  const filteredEvents = MOCK_CALENDAR_EVENTS.filter((ev) => {
    if (activeFilter === 'All') return true;
    return ev.type.toLowerCase() === activeFilter.toLowerCase();
  });

  return (
    <div className="p-4 space-y-4 pb-20">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <CalendarIcon className="w-5 h-5 text-blue-500" /> Master Calendar
          </h2>
          <p className="text-xs text-slate-500">Holidays, leaves & corporate events</p>
        </div>
      </div>

      {/* Month Navigation */}
      <Card>
        <div className="flex items-center justify-between mb-4">
          <h3 className="font-bold text-sm text-slate-900 dark:text-slate-100">August 2026</h3>
          <div className="flex gap-1">
            <button className="p-1 rounded-lg border border-slate-200 dark:border-slate-800">
              <ChevronLeft className="w-4 h-4" />
            </button>
            <button className="p-1 rounded-lg border border-slate-200 dark:border-slate-800">
              <ChevronRight className="w-4 h-4" />
            </button>
          </div>
        </div>

        <div className="grid grid-cols-7 gap-1 text-center text-[10px] font-bold text-slate-400 mb-2">
          <span>S</span><span>M</span><span>T</span><span>W</span><span>T</span><span>F</span><span>S</span>
        </div>
        <div className="grid grid-cols-7 gap-1.5 text-center text-xs">
          {Array.from({ length: 31 }).map((_, i) => {
            const day = i + 1;
            const isEventDay = [13, 25, 31].includes(day);

            return (
              <div
                key={day}
                className={`py-2 rounded-xl text-center font-bold ${
                  isEventDay
                    ? 'bg-[#4F39F6] text-white shadow-xs'
                    : 'bg-slate-50 dark:bg-slate-900 text-slate-700 dark:text-slate-300'
                }`}
              >
                {day}
              </div>
            );
          })}
        </div>
      </Card>

      {/* Filters */}
      <div className="flex gap-1.5 overflow-x-auto pb-1 scrollbar-none">
        {['All', 'Holiday', 'Leave', 'Company Event', 'Deadline'].map((f) => (
          <button
            key={f}
            onClick={() => setActiveFilter(f)}
            className={`px-3 py-1 rounded-full text-xs font-semibold border whitespace-nowrap ${
              activeFilter === f
                ? 'bg-[#4F39F6] text-white border-[#4F39F6]'
                : 'bg-white dark:bg-[#131C2E] text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-800'
            }`}
          >
            {f}
          </button>
        ))}
      </div>

      {/* Event List */}
      <div className="space-y-2">
        {filteredEvents.map((ev) => (
          <Card key={ev.id} className="p-3.5 flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div
                className="w-3 h-10 rounded-full"
                style={{ backgroundColor: ev.color }}
              />
              <div>
                <h4 className="font-bold text-xs text-slate-900 dark:text-white">{ev.title}</h4>
                <p className="text-[10px] text-slate-500">{ev.description}</p>
              </div>
            </div>
            <span className="text-xs font-bold text-slate-800 dark:text-slate-200 bg-slate-100 dark:bg-slate-800 px-2.5 py-1 rounded-lg">
              {ev.date}
            </span>
          </Card>
        ))}
      </div>
    </div>
  );
};
