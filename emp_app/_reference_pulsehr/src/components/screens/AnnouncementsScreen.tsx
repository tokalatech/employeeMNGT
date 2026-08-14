import React, { useState } from 'react';
import { Card, BottomSheet } from '../common/UIComponents';
import { Megaphone, Calendar, Tag, Paperclip, ChevronRight, Bell } from 'lucide-react';
import { MOCK_ANNOUNCEMENTS } from '../../mockData';
import { Announcement } from '../../types';

export const AnnouncementsScreen: React.FC = () => {
  const [selectedAnnouncement, setSelectedAnnouncement] = useState<Announcement | null>(null);

  return (
    <div className="p-4 space-y-4 pb-20">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <Megaphone className="w-5 h-5 text-amber-500" /> Announcements & Notices
          </h2>
          <p className="text-xs text-slate-500">Official company updates & HR notices</p>
        </div>
      </div>

      <div className="space-y-3">
        {MOCK_ANNOUNCEMENTS.map((ann) => (
          <Card
            key={ann.id}
            onClick={() => setSelectedAnnouncement(ann)}
            className="p-4 space-y-2 border-l-4 border-l-amber-500"
          >
            <div className="flex items-center justify-between">
              <span className="text-[10px] font-bold text-amber-600 bg-amber-50 dark:bg-amber-950 px-2 py-0.5 rounded-md border border-amber-200">
                {ann.category}
              </span>
              <span className="text-[10px] text-slate-400">{ann.publishedDate}</span>
            </div>

            <h4 className="font-bold text-sm text-slate-900 dark:text-white">{ann.title}</h4>
            <p className="text-xs text-slate-500 line-clamp-2">{ann.summary}</p>

            <div className="flex justify-between items-center text-[11px] text-slate-400 pt-2 border-t border-slate-100 dark:border-slate-800">
              <span>Published by: {ann.author}</span>
              <span className="text-[#4F39F6] font-bold flex items-center">
                Read Full Notice <ChevronRight className="w-3.5 h-3.5" />
              </span>
            </div>
          </Card>
        ))}
      </div>

      <BottomSheet
        isOpen={!!selectedAnnouncement}
        onClose={() => setSelectedAnnouncement(null)}
        title={selectedAnnouncement ? selectedAnnouncement.title : ''}
      >
        {selectedAnnouncement && (
          <div className="space-y-4 text-xs">
            <div className="flex justify-between items-center p-3 rounded-xl bg-slate-50 dark:bg-slate-900 border border-slate-200 dark:border-slate-800">
              <span className="font-bold text-amber-600">{selectedAnnouncement.category} Notice</span>
              <span className="text-slate-400">{selectedAnnouncement.publishedDate}</span>
            </div>

            <div className="p-4 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 space-y-2 leading-relaxed">
              <p className="text-slate-800 dark:text-slate-200 text-sm whitespace-pre-line">
                {selectedAnnouncement.content}
              </p>
            </div>

            <div className="p-3 bg-indigo-50 dark:bg-indigo-950/40 rounded-xl border border-indigo-200 dark:border-indigo-900">
              <span className="font-bold text-[#4F39F6]">Author / Department:</span>
              <p className="text-slate-700 dark:text-slate-300">{selectedAnnouncement.author}</p>
            </div>
          </div>
        )}
      </BottomSheet>
    </div>
  );
};
