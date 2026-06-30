# ORRY Serenity — P0 Sprint Plan
**Date**: 2026-06-02  
**Sprint owner**: Dheva Oracle (Frontend) + codex-rider (Execution)  
**Requested by**: MARCUZ:Zeus  
**Designed by**: Luxi Oracle

> **Execution Rule**: Claude session = design + plan only  
> ทุก execute → `tmux send-keys -t "04-luxi:codex-rider" "[task]" Enter`

---

## Dependency Map

```
Company Setup ─────────────────────────┐
                                       ▼
Vendors UI ──────→ PO Create Form ──→ Goods Receipt
                                       │
                              triggers inventory_movement
                                       │
                    ┌──────────────────┘
                    ▼
Quotation ──→ (Sales Order exists) ──→ Delivery Note
                                       │
                              triggers inventory_movement
                                       │
                    ┌──────────────────┘
                    ▼
          Lot/Batch Tracking ←─── DB Migration (Sprint 4)
                    │
          ภ.พ.30 Report ←─── Tax Invoices + Payments (exist)
```

**Sprint sequence**: S1 → S2 → S3 → S4 (strict order, dependencies chain)

---

## Sprint 1 — Foundation Layer
**Duration**: 5 days  
**Goal**: Unblock purchase cycle + make system configurable

### Task 1.1 — Company Setup Page (settings enhancement)
**Status**: ⚡ Settings page exists at `app/[locale]/(app)/settings/page.tsx` (314 lines) + `CompanyForm` component — **ต้องเพิ่ม**

**Deliverables**:
```
components/modules/settings/
├── CompanyProfileSection.tsx    # edit company name, tax_id, address, phone, email
├── BranchSection.tsx            # list + add/edit branches
├── DocumentNumberSection.tsx    # configure INV-YYYY-XXXXX patterns
└── FiscalYearSection.tsx        # fiscal year start/end
```

**DB**: ใช้ `companies` + `branches` tables ที่มีอยู่ — ไม่ต้องมี migration ใหม่

**UX Notes (Luxi)**:
- Settings แบ่ง 4 tabs: Company / Branches / Documents / Fiscal Year
- Branch table: code | name | is_main_office toggle | is_active toggle
- Doc number preview: `SO-2026-00001` แสดง live ขณะ user พิมพ์ pattern
- Form validation: Thai Tax ID format xxxxxxxxxxxxxxxxx (13 digits)
- First-run state: แสดง banner "ตั้งค่าบริษัทก่อนใช้งาน" ถ้า company.name ว่าง

**Effort**: 2 days  
**Files to modify**: `app/[locale]/(app)/settings/page.tsx`  
**Files to create**: 4 component files above

---

### Task 1.2 — Vendors Module (clone + adapt from Customers)
**Status**: DB table `vendors` มีครบแล้ว — **ไม่มี UI เลย**

**Deliverables**:
```
app/[locale]/(app)/vendors/
└── page.tsx                     # vendor list (SSR)

components/modules/vendors/
├── VendorsList.tsx              # table: name | tax_id | contact | WHT rate | payment terms | status
├── VendorForm.tsx               # create/edit form (modal or full page)
├── VendorDetail.tsx             # detail view + purchase history
└── VendorListSkeleton.tsx       # loading state

app/api/vendors/
└── route.ts                     # GET (list) + POST (create)
```

**Pattern**: copy `components/modules/customers/` แล้วปรับ fields:
- Customer → Vendor
- credit_limit → `withholding_tax_rate` (DECIMAL 0-100%)
- เพิ่ม `bank_account` field (สำคัญมากสำหรับ payment)
- เพิ่ม `payment_terms_id` selector (dropdown จาก payment_terms table)

**UX Notes (Luxi)**:
- Vendor card: แสดง WHT rate badge (สีส้ม ถ้า > 0) — visual reminder ก่อน pay
- Filter: All / Active / Inactive + search by name/tax_id
- Empty state: "เพิ่ม Vendor แรก" พร้อม illustration
- Sidebar navigation: เพิ่ม "Vendors" ใต้ Purchase section

**Effort**: 3 days  
**Nav**: เพิ่มใน `lib/navigation.ts`

---

## Sprint 2 — Purchase Cycle Completion
**Duration**: 5 days  
**Goal**: สามารถสร้าง PO และรับสินค้าเข้าระบบได้จริง

### Task 2.1 — Purchase Order Create Form
**Status**: List + Detail มีแล้ว — **ขาด create form**

**Deliverables**:
```
app/[locale]/(app)/purchase/new/
└── page.tsx                     # PO create page (SSR wrapper)

components/modules/purchase-orders/
├── PurchaseOrderForm.tsx        # main form component (client)
├── PurchaseOrderLineItems.tsx   # line items table with add/remove rows
└── PurchaseOrderSummary.tsx     # net / tax / gross totals auto-calc
```

**Form fields** (from `purchase_orders` schema):
```
Header:
  vendor_id      → VendorSelector (searchable dropdown)
  branch_id      → BranchSelector
  order_date     → DatePicker (default today)
  requested_delivery → DatePicker (optional)
  notes          → Textarea

Line Items (purchase_order_items):
  product_id    → ProductSelector (SKU search)
  qty           → Number input
  unit_price    → Number input (auto-fill from product.cost_price)
  tax_code_id   → TaxCodeSelector (default VAT7%)
  [auto-calc: line_total = qty × unit_price + tax]

Footer:
  amount_net    → calculated
  amount_tax    → calculated
  amount_gross  → calculated (displayed prominently)
  
Actions: Save Draft | Submit for Approval
```

**UX Notes (Luxi)**:
- Line items: row เพิ่มได้ไม่จำกัด, ลบ row ได้, reorder ด้วย drag (P2 nice)
- Product selector: แสดง current_stock ข้างชื่อ product (context สำคัญ)
- ราคาเป็น THB, format ด้วย Intl.NumberFormat('th-TH')
- Totals section: sticky bottom ขณะ scroll line items
- Auto doc_number: `PO-2026-00001` generate จาก server

**Effort**: 3 days  
**DB**: ไม่ต้อง migration — schema พร้อม  
**API**: `POST /api/purchase-orders` (create) + `PATCH /api/purchase-orders/[id]` (update)

---

### Task 2.2 — Goods Receipt (ใบรับสินค้า)
**Status**: ไม่มีเลย — document ใหม่

**Deliverables**:
```
app/[locale]/(app)/goods-receipt/
├── page.tsx                     # GR list
└── new/page.tsx                 # create from PO

components/modules/goods-receipt/
├── GoodsReceiptList.tsx         # list: GR# | PO# | vendor | date | status
├── GoodsReceiptForm.tsx         # receive items form
└── GoodsReceiptDetail.tsx       # view + print
```

**DB**: ไม่ต้อง new table — ใช้ `inventory_movements` ที่มีอยู่:
```sql
-- Goods Receipt เขียน movement:
INSERT INTO inventory_movements (
  movement_type = 'in',
  reference_type = 'goods_receipt',
  reference_id = [po_id],
  product_id, warehouse_id, qty, cost_per_unit, movement_date
)
-- พร้อมอัปเดต stock_levels + purchase_order.status → 'received'
```

**Form flow**:
1. เลือก PO (dropdown กรอง status = 'approved')
2. ระบบดึง PO items → pre-fill line items
3. ผู้ใช้แก้ qty_received (อาจน้อยกว่า qty_ordered = partial receipt)
4. เลือก warehouse destination
5. Confirm → insert movements + update stock_levels + update PO status

**UX Notes (Luxi)**:
- "Receive from PO" button ใน PO Detail page → redirect ไป GR form พร้อม PO pre-loaded
- Partial receipt: แสดง ordered vs received quantity ชัดเจน (progress bar per line)
- Success state: แสดง stock level ที่เปลี่ยนไป (before → after)
- Print button: basic HTML print สำหรับ warehouse staff

**Effort**: 2 days  
**Nav**: เพิ่มใน Purchase section

---

## Sprint 3 — Sales Cycle Completion
**Duration**: 6 days  
**Goal**: Sales flow ครบตั้งแต่ Quotation → SO → Delivery Note

### Task 3.1 — Quotation (ใบเสนอราคา)
**Status**: ไม่มี table, ไม่มี UI

**DB Migration ใหม่**:
```sql
-- migration: 20260602_add_quotations.sql
CREATE TABLE quotations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id),
  doc_number VARCHAR(100) NOT NULL,          -- QT-2026-00001
  customer_id UUID NOT NULL REFERENCES customers(id),
  quote_date DATE NOT NULL DEFAULT CURRENT_DATE,
  valid_until DATE,                          -- วันหมดอายุใบเสนอ
  status VARCHAR(50) NOT NULL DEFAULT 'draft', -- draft | sent | accepted | rejected | expired | converted
  converted_so_id UUID REFERENCES sales_orders(id), -- link ถ้า convert แล้ว
  amount_net DECIMAL(15,2) DEFAULT 0,
  amount_tax DECIMAL(15,2) DEFAULT 0,
  amount_gross DECIMAL(15,2) DEFAULT 0,
  notes TEXT,
  terms TEXT,                                -- เงื่อนไขการขาย
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID NOT NULL REFERENCES users(id),
  UNIQUE(company_id, doc_number)
);

CREATE TABLE quotation_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  quotation_id UUID NOT NULL REFERENCES quotations(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id),
  qty DECIMAL(15,4) NOT NULL,
  unit_price DECIMAL(15,4) NOT NULL,
  discount_pct DECIMAL(5,2) DEFAULT 0,
  tax_code_id UUID REFERENCES tax_codes(id),
  line_total DECIMAL(15,2) NOT NULL,
  notes TEXT
);

-- RLS
ALTER TABLE quotations ENABLE ROW LEVEL SECURITY;
ALTER TABLE quotation_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "company_isolation_quotations" ON quotations
  USING (company_id = (SELECT company_id FROM users WHERE id = auth.uid()));
```

**Deliverables**:
```
app/[locale]/(app)/quotations/
├── page.tsx                     # quotation list
├── new/page.tsx                 # create quotation
└── [id]/page.tsx                # detail + convert to SO

components/modules/quotations/
├── QuotationsList.tsx           # list: QT# | customer | date | valid until | amount | status
├── QuotationForm.tsx            # create/edit (similar to PO form)
├── QuotationDetail.tsx          # view + action buttons
└── ConvertToSOButton.tsx        # one-click convert → creates SO, links converted_so_id
```

**Key feature — Convert to SO**:
```typescript
// action: convert quotation → sales order
async function convertQuotationToSO(quotationId: string) {
  // 1. fetch quotation + items
  // 2. INSERT sales_orders (copy fields)
  // 3. INSERT sales_order_items (copy items)
  // 4. UPDATE quotations SET status='converted', converted_so_id=[new_so_id]
  // 5. redirect to SO detail
}
```

**UX Notes (Luxi)**:
- Status color: draft=gray, sent=blue, accepted=green, rejected=red, expired=orange, converted=purple
- Valid until: แสดง countdown badge "เหลือ 3 วัน" ถ้าใกล้หมดอายุ
- "Convert to SO" button: prominent, disabled ถ้า status ≠ 'accepted'
- Print/PDF: styled สำหรับ ส่ง email ลูกค้า (logo + company info + terms)
- Discount column: optional per line item (beauty B2B มักมี negotiated discount)

**Effort**: 3 days (รวม DB migration)

---

### Task 3.2 — Delivery Note (ใบส่งของ)
**Status**: ไม่มี — document ใหม่

**DB**: ไม่ต้อง new table หลัก — ใช้ pattern เดียวกับ Goods Receipt

```sql
-- migration: 20260602_add_delivery_notes.sql
CREATE TABLE delivery_notes (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  branch_id UUID NOT NULL REFERENCES branches(id),
  doc_number VARCHAR(100) NOT NULL,          -- DN-2026-00001
  sales_order_id UUID NOT NULL REFERENCES sales_orders(id),
  customer_id UUID NOT NULL REFERENCES customers(id),
  delivery_date DATE NOT NULL DEFAULT CURRENT_DATE,
  status VARCHAR(50) NOT NULL DEFAULT 'draft', -- draft | dispatched | delivered | returned
  warehouse_id UUID NOT NULL REFERENCES warehouses(id),
  delivery_address TEXT,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID NOT NULL REFERENCES users(id),
  UNIQUE(company_id, doc_number)
);

CREATE TABLE delivery_note_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  delivery_note_id UUID NOT NULL REFERENCES delivery_notes(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id),
  qty_ordered DECIMAL(15,4) NOT NULL,        -- from SO
  qty_delivered DECIMAL(15,4) NOT NULL,      -- actual delivered
  notes TEXT
);
```

**Deliverables**:
```
app/[locale]/(app)/delivery-notes/
├── page.tsx                     # DN list
└── new/page.tsx                 # create from SO

components/modules/delivery-notes/
├── DeliveryNotesList.tsx        # list: DN# | SO# | customer | date | status
├── DeliveryNoteForm.tsx         # create form (pre-filled from SO)
└── DeliveryNoteDetail.tsx       # view + print (สำหรับแนบกับของ)
```

**On confirm delivery**:
```typescript
// trigger inventory_movements: out
INSERT INTO inventory_movements (
  movement_type = 'out',
  reference_type = 'delivery_note',
  reference_id = [dn_id],
  product_id, warehouse_id, qty = qty_delivered, movement_date
)
// update sales_order.status → 'delivered'
// update stock_levels (subtract)
```

**UX Notes (Luxi)**:
- "Create Delivery Note" button ใน SO Detail → pre-load SO items
- Partial delivery: ordered vs delivered qty (highlight ถ้า qty_delivered < qty_ordered)
- Print layout: ออกแบบสำหรับ A4, มี customer signature line ด้านล่าง
- Status "dispatched" vs "delivered" — warehouse dispatch กับ customer confirm แยกกัน

**Effort**: 3 days (รวม DB migration)

---

## Sprint 4 — Compliance Layer
**Duration**: 7 days  
**Goal**: Lot tracking + Thai tax reporting ที่ยื่นจริงได้

### Task 4.1 — Lot / Batch Tracking
**Status**: DB ไม่มี lot fields เลย — **ต้อง migration**

**DB Migration**:
```sql
-- migration: 20260602_add_lot_tracking.sql

-- 1. เพิ่ม lot tracking config ใน products
ALTER TABLE products
  ADD COLUMN has_lot_tracking BOOLEAN DEFAULT FALSE,
  ADD COLUMN shelf_life_days INT,          -- สำหรับคำนวณ expiry
  ADD COLUMN requires_expiry BOOLEAN DEFAULT FALSE;

-- 2. Lots master table
CREATE TABLE product_lots (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  company_id UUID NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  lot_number VARCHAR(100) NOT NULL,
  mfg_date DATE,
  expiry_date DATE,
  initial_qty DECIMAL(15,4) NOT NULL DEFAULT 0,
  current_qty DECIMAL(15,4) NOT NULL DEFAULT 0,   -- maintained by trigger
  status VARCHAR(50) DEFAULT 'active',              -- active | quarantine | expired | consumed
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_by UUID REFERENCES users(id),
  UNIQUE(company_id, product_id, lot_number)
);

-- 3. เพิ่ม lot_id ใน inventory_movements
ALTER TABLE inventory_movements
  ADD COLUMN lot_id UUID REFERENCES product_lots(id),
  ADD COLUMN lot_number VARCHAR(100),        -- denormalized สำหรับ speed
  ADD COLUMN expiry_date DATE;               -- snapshot ณ เวลา movement

-- 4. Trigger: อัปเดต product_lots.current_qty หลัง movement
CREATE OR REPLACE FUNCTION update_lot_qty() RETURNS TRIGGER AS $$
BEGIN
  IF NEW.movement_type = 'in' THEN
    UPDATE product_lots SET current_qty = current_qty + NEW.qty
    WHERE id = NEW.lot_id;
  ELSIF NEW.movement_type IN ('out', 'transfer') THEN
    UPDATE product_lots SET current_qty = current_qty - NEW.qty
    WHERE id = NEW.lot_id;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_lot_qty
AFTER INSERT ON inventory_movements
FOR EACH ROW WHEN (NEW.lot_id IS NOT NULL)
EXECUTE FUNCTION update_lot_qty();

-- 5. View: expiring soon (ภายใน 90 วัน)
CREATE VIEW lots_expiring_soon AS
SELECT pl.*, p.name as product_name, p.sku
FROM product_lots pl
JOIN products p ON p.id = pl.product_id
WHERE pl.expiry_date <= CURRENT_DATE + INTERVAL '90 days'
  AND pl.status = 'active'
  AND pl.current_qty > 0
ORDER BY pl.expiry_date ASC;
```

**UI Deliverables**:
```
app/[locale]/(app)/lots/
└── page.tsx                     # lot management page

components/modules/lots/
├── LotsList.tsx                 # table: lot# | product | mfg | expiry | qty | status
├── LotExpiryAlert.tsx           # dashboard widget: "X lots expire in 30 days"
└── LotSelector.tsx              # reusable: picker ใน GR form / DN form
```

**Integration points**:
- `GoodsReceiptForm.tsx` → เพิ่ม lot_number + mfg_date + expiry_date fields (แสดงถ้า product.has_lot_tracking)
- `DeliveryNoteForm.tsx` → LotSelector (FEFO: suggest lot ที่ expiry เร็วที่สุด)
- `Dashboard` → เพิ่ม expiry alert card

**UX Notes (Luxi)**:
- Expiry color code: green > 90d / yellow 30-90d / orange 7-30d / red < 7d
- FEFO picker: "แนะนำ Lot ABC-001 (หมด 15 ก.ค. 69)" — ช่วย warehouse
- Product form: toggle "ติดตาม Lot/Batch" → ซ่อน/แสดง lot fields
- Lot status badge: active=green, quarantine=yellow, expired=red

**Effort**: 4 days (DB migration complex + 4 integration points)

---

### Task 4.2 — Tax Reporting ภ.พ.30
**Status**: Reports page มี tab แต่เป็น stub — **ต้อง implement จริง**

**ภ.พ.30 คืออะไร**: รายงาน VAT รายเดือน ยื่นกรมสรรพากรภายในวันที่ 15 ของเดือนถัดไป

**Data sources** (DB พร้อมแล้ว):
```
Output VAT (ภาษีขาย):
  tax_invoices + tax_invoice_items WHERE tax_code = 'VAT7'

Input VAT (ภาษีซื้อ):
  purchase_invoices + purchase_invoice_items WHERE tax_code = 'VAT7'

ภ.พ.30 = Output VAT - Input VAT = ยอดต้องชำระ (หรือขอคืน)
```

**Deliverables**:
```
components/modules/reports/
├── PP30Report.tsx               # ภ.พ.30 main component
├── PP30Summary.tsx              # ยอดรวม output/input/net VAT
├── PP30OutputTable.tsx          # ตาราง tax_invoices ของเดือน
├── PP30InputTable.tsx           # ตาราง purchase_invoices ของเดือน
└── PP30ExportButton.tsx         # export CSV + print-optimized HTML
```

**Report structure** (ตามฟอร์มจริงของกรมสรรพากร):
```
ภ.พ.30 — เดือน [มิถุนายน 2569]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ส่วนที่ 1: ภาษีขาย (Output VAT)
  ยอดขาย (ไม่รวม VAT)    : 1,000,000.00
  VAT 7%                 :    70,000.00

ส่วนที่ 2: ภาษีซื้อ (Input VAT)
  ยอดซื้อ (ไม่รวม VAT)   :   600,000.00
  VAT ซื้อ 7%            :    42,000.00

ส่วนที่ 3: สรุป
  ภาษีต้องชำระ           :    28,000.00  ← Output - Input
  (หรือขอคืน)

รายการ Tax Invoice ทั้งหมด [ตาราง]
  TXI-2026-0001 | ลูกค้า ABC | 10/06/69 | 10,700 | VAT 700
  ...

รายการ Purchase Invoice ทั้งหมด [ตาราง]
```

**Export**:
- CSV: เพื่อนำเข้าโปรแกรมบัญชี
- Print HTML: `@media print` styled, A4 landscape, logo + company info header

**UX Notes (Luxi)**:
- Month/Year picker ที่ top of page (Thai Buddhist year)
- Summary cards: Output VAT (green) | Input VAT (blue) | Net (red/green)
- Deadline indicator: "ยื่นภายใน 15 ก.ค. 2569 — เหลือ X วัน" (คำนวณอัตโนมัติ)
- Download button: prominent, เด่นชัด — finance team ใช้ทุกเดือน
- Zero-state: "ยังไม่มีรายการใบกำกับภาษีในเดือนนี้"

**Effort**: 3 days

---

## Summary Timeline

```
Week 1    │ S1: Company Setup (2d) + Vendors UI (3d)
──────────┤
Week 2    │ S2: PO Create Form (3d) + Goods Receipt (2d)
──────────┤
Week 3-4  │ S3: Quotation (3d) + Delivery Note (3d)
──────────┤
Week 5    │ S4: Lot/Batch Tracking (4d) + ภ.พ.30 (3d)
──────────┘
Total: ~20 working days (4 weeks)
```

## File Creation Checklist (สำหรับ codex-rider)

### Sprint 1
- [ ] `components/modules/settings/CompanyProfileSection.tsx`
- [ ] `components/modules/settings/BranchSection.tsx`
- [ ] `components/modules/settings/DocumentNumberSection.tsx`
- [ ] `components/modules/settings/FiscalYearSection.tsx`
- [ ] `app/[locale]/(app)/vendors/page.tsx`
- [ ] `components/modules/vendors/VendorsList.tsx`
- [ ] `components/modules/vendors/VendorForm.tsx`
- [ ] `components/modules/vendors/VendorDetail.tsx`
- [ ] `components/modules/vendors/VendorListSkeleton.tsx`
- [ ] `app/api/vendors/route.ts`
- [ ] update `lib/navigation.ts` (add Vendors nav item)

### Sprint 2
- [ ] `app/[locale]/(app)/purchase/new/page.tsx`
- [ ] `components/modules/purchase-orders/PurchaseOrderForm.tsx`
- [ ] `components/modules/purchase-orders/PurchaseOrderLineItems.tsx`
- [ ] `components/modules/purchase-orders/PurchaseOrderSummary.tsx`
- [ ] `app/[locale]/(app)/goods-receipt/page.tsx`
- [ ] `app/[locale]/(app)/goods-receipt/new/page.tsx`
- [ ] `components/modules/goods-receipt/GoodsReceiptList.tsx`
- [ ] `components/modules/goods-receipt/GoodsReceiptForm.tsx`
- [ ] `components/modules/goods-receipt/GoodsReceiptDetail.tsx`
- [ ] update `lib/navigation.ts` (add Goods Receipt nav item)

### Sprint 3
- [ ] `supabase/migrations/20260602_add_quotations.sql` ← **DB migration**
- [ ] `app/[locale]/(app)/quotations/page.tsx`
- [ ] `app/[locale]/(app)/quotations/new/page.tsx`
- [ ] `app/[locale]/(app)/quotations/[id]/page.tsx`
- [ ] `components/modules/quotations/QuotationsList.tsx`
- [ ] `components/modules/quotations/QuotationForm.tsx`
- [ ] `components/modules/quotations/QuotationDetail.tsx`
- [ ] `components/modules/quotations/ConvertToSOButton.tsx`
- [ ] `supabase/migrations/20260602_add_delivery_notes.sql` ← **DB migration**
- [ ] `app/[locale]/(app)/delivery-notes/page.tsx`
- [ ] `app/[locale]/(app)/delivery-notes/new/page.tsx`
- [ ] `components/modules/delivery-notes/DeliveryNotesList.tsx`
- [ ] `components/modules/delivery-notes/DeliveryNoteForm.tsx`
- [ ] `components/modules/delivery-notes/DeliveryNoteDetail.tsx`
- [ ] update `lib/navigation.ts` (add Quotations + Delivery Notes)

### Sprint 4
- [ ] `supabase/migrations/20260602_add_lot_tracking.sql` ← **DB migration (complex)**
- [ ] `app/[locale]/(app)/lots/page.tsx`
- [ ] `components/modules/lots/LotsList.tsx`
- [ ] `components/modules/lots/LotExpiryAlert.tsx`
- [ ] `components/modules/lots/LotSelector.tsx`
- [ ] update `components/modules/goods-receipt/GoodsReceiptForm.tsx` (add lot fields)
- [ ] update `components/modules/delivery-notes/DeliveryNoteForm.tsx` (add lot selector)
- [ ] update `app/[locale]/(app)/dashboard/page.tsx` (add expiry alert card)
- [ ] `components/modules/reports/PP30Report.tsx`
- [ ] `components/modules/reports/PP30Summary.tsx`
- [ ] `components/modules/reports/PP30OutputTable.tsx`
- [ ] `components/modules/reports/PP30InputTable.tsx`
- [ ] `components/modules/reports/PP30ExportButton.tsx`
- [ ] update `app/[locale]/(app)/reports/page.tsx` (wire PP30 tab)

---

## Risk & Notes

| Risk | Mitigation |
|------|-----------|
| Lot tracking migration อาจทำให้ existing inventory_movements พัง | Run migration ใน dev ก่อน, backup prod DB |
| Quotation doc_number sequence ต้อง thread-safe | ใช้ Postgres sequence หรือ server-side generate |
| ภ.พ.30 calculation: VAT-exempt items | กรอง tax_code_id ที่ rate = 7 เท่านั้น |
| GR partial receipt: PO status logic ซับซ้อน | status: 'approved' → 'partial' → 'received' |
| Delivery Note กับ Tax Invoice: อาจ invoice ก่อน deliver | Allow both flows, ไม่ enforce strict order |

---

*Sprint Plan by Luxi Oracle — 2026-06-02*  
*Execute via codex-rider — Claude session = think only*
