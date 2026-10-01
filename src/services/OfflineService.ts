export interface OfflineDraft {
  id: string;
  type: 'produce_intake' | 'quality_override' | 'lot_dispatch';
  data: any;
  createdAt: string;
  synced: boolean;
}

export class OfflineService {
  private static STORAGE_KEY = 'fasalos_offline_drafts';

  public static getDrafts(): OfflineDraft[] {
    try {
      const data = localStorage.getItem(this.STORAGE_KEY);
      return data ? JSON.parse(data) : [];
    } catch {
      return [];
    }
  }

  public static saveDraft(type: OfflineDraft['type'], payload: any): OfflineDraft {
    const drafts = this.getDrafts();
    const newDraft: OfflineDraft = {
      id: `DRAFT-${Date.now().toString().slice(-6)}`,
      type,
      data: payload,
      createdAt: new Date().toISOString(),
      synced: false,
    };
    drafts.unshift(newDraft);
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(drafts));
    return newDraft;
  }

  public static syncAllDrafts(): { syncedCount: number; remainingCount: number } {
    const drafts = this.getDrafts();
    const unsynced = drafts.filter((d) => !d.synced);
    
    // Mark all as synced
    const updated = drafts.map((d) => ({ ...d, synced: true }));
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(updated));

    return {
      syncedCount: unsynced.length,
      remainingCount: 0,
    };
  }

  public static clearSynced(): void {
    const drafts = this.getDrafts().filter((d) => !d.synced);
    localStorage.setItem(this.STORAGE_KEY, JSON.stringify(drafts));
  }
}
