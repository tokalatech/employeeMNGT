import React, { useState } from 'react';
import { Card, BottomSheet, Button } from '../common/UIComponents';
import { FolderArchive, FileText, Download, Eye, Share2, Search } from 'lucide-react';
import { MOCK_DOCUMENTS } from '../../mockData';
import { EmployeeDocument } from '../../types';

export const DocumentsScreen: React.FC = () => {
  const [activeCategory, setActiveCategory] = useState<string>('All');
  const [selectedDoc, setSelectedDoc] = useState<EmployeeDocument | null>(null);
  const [showPdfViewer, setShowPdfViewer] = useState(false);

  const filteredDocs = MOCK_DOCUMENTS.filter((doc) => {
    if (activeCategory === 'All') return true;
    return doc.category.toLowerCase() === activeCategory.toLowerCase();
  });

  return (
    <div className="p-4 space-y-4 pb-20">
      <div className="flex items-center justify-between">
        <div>
          <h2 className="text-lg font-black text-slate-900 dark:text-slate-100 flex items-center gap-2">
            <FolderArchive className="w-5 h-5 text-cyan-600" /> Document Center
          </h2>
          <p className="text-xs text-slate-500">Employment contracts, policies & tax files</p>
        </div>
      </div>

      {/* Category Pills */}
      <div className="flex gap-1.5 overflow-x-auto pb-1 scrollbar-none">
        {['All', 'My Documents', 'Company Policies', 'Payslips', 'Certificates'].map((cat) => (
          <button
            key={cat}
            onClick={() => setActiveCategory(cat)}
            className={`px-3 py-1 rounded-full text-xs font-semibold border whitespace-nowrap ${
              activeCategory === cat
                ? 'bg-[#4F39F6] text-white border-[#4F39F6]'
                : 'bg-white dark:bg-[#131C2E] text-slate-600 dark:text-slate-300 border-slate-200 dark:border-slate-800'
            }`}
          >
            {cat}
          </button>
        ))}
      </div>

      {/* File Cards */}
      <div className="space-y-2">
        {filteredDocs.map((doc) => (
          <Card
            key={doc.id}
            onClick={() => setSelectedDoc(doc)}
            className="p-3.5 flex items-center justify-between"
          >
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-2xl bg-cyan-50 dark:bg-cyan-950/60 flex items-center justify-center text-cyan-600 font-bold text-xs">
                {doc.fileType}
              </div>
              <div>
                <h4 className="font-bold text-xs text-slate-900 dark:text-white">{doc.name}</h4>
                <p className="text-[10px] text-slate-400">
                  {doc.category} • {doc.fileSize}
                </p>
              </div>
            </div>
            <span className="text-[10px] text-slate-400">{doc.dateAdded}</span>
          </Card>
        ))}
      </div>

      {/* Document Detail Sheet */}
      <BottomSheet
        isOpen={!!selectedDoc}
        onClose={() => setSelectedDoc(null)}
        title={selectedDoc ? selectedDoc.name : ''}
      >
        {selectedDoc && (
          <div className="space-y-4 text-xs">
            <div className="p-4 bg-slate-50 dark:bg-slate-900 rounded-2xl border border-slate-200 dark:border-slate-800 space-y-2 text-center">
              <FileText className="w-10 h-10 text-cyan-600 mx-auto" />
              <h4 className="font-bold text-sm text-slate-900 dark:text-white">{selectedDoc.name}</h4>
              <p className="text-slate-400 text-[10px]">
                {selectedDoc.category} • {selectedDoc.fileType} ({selectedDoc.fileSize})
              </p>
            </div>

            <div className="grid grid-cols-2 gap-2">
              <Button
                variant="outline"
                onClick={() => setShowPdfViewer(true)}
              >
                <Eye className="w-4 h-4" /> Preview File
              </Button>
              <Button
                onClick={() => alert(`Downloading ${selectedDoc.name}`)}
              >
                <Download className="w-4 h-4" /> Download
              </Button>
            </div>
          </div>
        )}
      </BottomSheet>

      {/* PDF Viewer Simulation */}
      {showPdfViewer && selectedDoc && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-md z-50 flex flex-col p-4">
          <div className="flex justify-between items-center text-white pb-3 border-b border-slate-800">
            <h3 className="font-bold text-sm">{selectedDoc.name}</h3>
            <button
              onClick={() => setShowPdfViewer(false)}
              className="p-1.5 bg-slate-800 rounded-lg text-xs"
            >
              Close
            </button>
          </div>
          <div className="flex-1 bg-white rounded-2xl my-3 p-6 text-slate-900 overflow-y-auto space-y-3 font-mono text-xs">
            <div className="p-3 bg-slate-100 rounded-xl font-bold text-center">
              OFFICIAL HR DOCUMENT — {selectedDoc.name.toUpperCase()}
            </div>
            <p>
              This official document certifies compliance with corporate guidelines and employment regulations.
            </p>
            <p className="text-slate-500 text-[10px]">
              Digital Fingerprint: SHA256-4f39f6a10b981f59e0b2984...
            </p>
          </div>
        </div>
      )}
    </div>
  );
};
