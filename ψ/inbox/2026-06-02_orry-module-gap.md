# ORRY Serenity ERP — Module Gap Analysis
**Date**: 2026-06-02  
**Requested by**: MARCUZ:Zeus  
**Analyzed by**: Luxi Oracle (Design + Frontend perspective)  
**Project path**: `mission-control/orry-serenity/`  
**Stack**: Next.js 15 + Supabase + TypeScript · Thai B2B ERP

---

## ส่วนที่ 1 — Modules ที่ Implement แล้ว

> **Legend**: ✅ complete · ⚡ partial · 🪨 stub

| Module | Route | Lines | Status | หมายเหตุ |
|--------|-------|-------|--------|----------|
| **Authentication** | `/login` | middleware + callback | ✅ complete | Login page, auth callback, session middleware ครบ |
| **Dashboard** | `/dashboard` | 113 | ⚡ partial | Stats cards ใช้ได้ แต่ analytics/charts ยังไม่มี real data |
| **Chart of Accounts** | `/accounts` | 679 | ⚡ partial | GL account list ดีมาก, แต่ขาด account creation UI |
| **Accounting / Journal** | `/accounting` | 328 | ⚡ partial | Journal entries + GL accounts + WHT certificates แสดงได้, ยังขาด manual JE entry form |
| **Customers** | `/customers` | 137 + components | ⚡ partial | CRUD พร้อม (list/form/detail), ขาด credit limit, price tier, contact persons |
| **Products** | `/products` | 78 + components | ⚡ partial | List/form/detail มี, ขาด lot tracking, expiry, beauty-specific attributes |
| **Sales Orders** | `/sales-orders` | 42 + components | ⚡ partial | Service layer ดี, stats + workflow แสดงได้, ขาด quotation link + delivery note |
| **Purchase Orders** | `/purchase` | 252 | ⚡ partial | List + detail มี, **ขาด create/edit form** |
| **Tax Invoices** | `/invoices` | 210 | ⚡ partial | List + status แสดงได้, ขาด PDF generation, e-Tax integration |
| **Payments** | `/payments` | 231 | ⚡ partial | List พร้อม WHT link, ขาด bank reconciliation, payment matching |
| **Inventory (Stock Levels)** | `/inventory` | 279 | ⚡ partial | Stock levels + movements แสดงได้, ขาด stock adjustment form |
| **Logistics (Movements)** | `/logistics` | 206 | ⚡ partial | Movement log + warehouse view ใช้ได้, ขาด delivery tracking |
| **Approvals** | `/approvals` | 235 | ⚡ partial | Cross-module approval queue ดี, ขาด approval rules config UI |
| **Reports** | `/reports` | 504 | ⚡ partial | หลาย tab: sales/purchase/tax/cash flow, ขาด export (PDF/Excel), ภ.พ.30 stub |
| **Users** | `/users` | 137 | ⚡ partial | List แสดงได้, ขาด invite flow, permission assignment UI |
| **Settings** | `/settings` | 314 | ⚡ partial | General settings, ขาด company profile, branch setup, document number patterns |

### Database Tables (Schema-level completeness)

| Table Group | Tables | Status |
|-------------|--------|--------|
| Company hierarchy | `companies`, `branches` | ✅ schema ready |
| Auth & RBAC | `roles`, `users` | ✅ schema ready |
| Master data | `customers`, `vendors`, `products`, `tax_codes`, `payment_terms` | ✅ schema ready |
| Sales cycle | `sales_orders`, `sales_order_items`, `tax_invoices`, `tax_invoice_items` | ✅ schema ready |
| Purchase cycle | `purchase_orders`, `purchase_order_items`, `purchase_invoices`, `purchase_invoice_items` | ✅ schema ready |
| Payments & WHT | `payments`, `withholding_tax_certificates` | ✅ schema ready |
| Accounting | `gl_accounts`, `journal_entries`, `journal_lines` | ✅ schema ready |
| Inventory | `products`, `stock_levels`, `inventory_movements`, `warehouses` | ✅ schema ready |
| Audit | `audit_logs` | ✅ schema ready |

> **สรุป**: DB schema ครบเกือบ 100% แต่ UI/UX ครบแค่ ~40% ของ feature จริง

---

## ส่วนที่ 2 — Modules ที่ยังขาด (สำหรับ B2B Beauty ERP ที่สมบูรณ์)

### 2A — ขาดในสาย Thai Document Flow

| Module | เหตุผล | ความซับซ้อน |
|--------|--------|------------|
| **Quotation** (ใบเสนอราคา) | ต้นทาง sales flow ก่อน SO — ธุรกิจ B2B ต้องการทุกราย | Medium |
| **Delivery Note** (ใบส่งของ) | Bridge ระหว่าง SO กับ Tax Invoice — สำคัญมากสำหรับ beauty distribution | Medium |
| **Goods Receipt** (ใบรับสินค้า) | Bridge ระหว่าง PO กับ Purchase Invoice | Medium |
| **Credit/Debit Note** (ใบลดหนี้/เพิ่มหนี้) | ต้องการสำหรับ returns, price adjustments — พบบ่อยใน beauty | Medium |
| **Receipt** (ใบเสร็จรับเงิน) | แยกจาก Tax Invoice — Thai requirement | Small |
| **Vendors Module** (UI) | DB table มี แต่ไม่มี page — ซื้อจากไหน จัดการ vendor ไม่ได้ | Small |

### 2B — ขาดในส่วน Beauty Industry Specific

| Module | เหตุผล | ความซับซ้อน |
|--------|--------|------------|
| **Lot / Batch Tracking** | Beauty products มี expiry date, lot numbers — regulatory requirement | High |
| **Expiry Date Management** | Alert สินค้าใกล้หมดอายุ, FEFO picking | Medium |
| **Price Lists / Tiered Pricing** | B2B beauty มีราคาหลายระดับ: dealer/distributor/retail | Medium |
| **Promotions / Trade Deals** | Bundle deal, volume discount, seasonal promotion — beauty B2B standard | High |
| **Commission / Sales Rep Tracking** | Sales rep performance, territory management | Medium |
| **Brand / Product Line Categorization** | Beauty: organize by brand, category, product line | Small |
| **Formula / Ingredient Records** | สำหรับ manufacturer — optional แต่ differentiator | High |

### 2C — ขาดในส่วน Infrastructure / Platform

| Module | เหตุผล | ความซับซ้อน |
|--------|--------|------------|
| **Company Onboarding / Setup Wizard** | First-run experience, configure company profile, branches, doc numbers | Medium |
| **Branch Management UI** | DB มี แต่ไม่มี UI จัดการ branch | Small |
| **Document Number Pattern Config** | INV-YYYY-XXXXX patterns ควร config ได้ per doc type | Small |
| **e-Tax Invoice Integration** | กรมสรรพากร e-Tax — สำคัญสำหรับ compliance | Very High |
| **Tax Reporting (ภ.พ.30 / ภ.ง.ด.3 / 53)** | Export report ที่ยื่นกรมสรรพากรได้จริง | High |
| **Bank Reconciliation** | Match payments กับ bank statement | High |
| **Multi-currency** | สำหรับ import/export beauty products | High |
| **Notification / Alert System** | Low stock, overdue payment, pending approvals | Medium |
| **Audit Trail UI** | View/filter audit_logs — compliance & debugging | Small |
| **Role & Permission Management UI** | Assign roles, manage permissions — มีแค่ user list | Medium |
| **Mobile / PWA** | Sales rep ใช้ mobile ดู orders, inventory | Very High |
| **Return / RMA Flow** | Customer returns → credit note → inventory adjustment | High |
| **API / Webhook** | Integration กับ marketplace, 3PL, accounting software | Very High |

---

## ส่วนที่ 3 — Priority Matrix

### MUST-HAVE (บล็อก production launch)

> ขาดแล้วระบบใช้ไม่ได้จริงใน B2B Beauty

| Priority | Module | เหตุผล |
|----------|--------|--------|
| 🔴 P0 | **Vendors Module UI** | ซื้อสินค้าไม่ได้ถ้าไม่มี vendor management |
| 🔴 P0 | **Purchase Order — Create Form** | มีแค่ list, ยังสร้าง PO ไม่ได้ |
| 🔴 P0 | **Goods Receipt** | ไม่รับสินค้าเข้า stock ไม่ได้ |
| 🔴 P0 | **Delivery Note** | ส่งสินค้าออกไม่มี document trail |
| 🔴 P0 | **Quotation** | ต้น flow ขาย — ลูกค้า B2B ต้องการ |
| 🔴 P0 | **Lot / Batch Tracking** | Beauty products — expiry date mandatory |
| 🔴 P0 | **Company Setup / Onboarding** | Setup ระบบไม่ได้ถ้าไม่มี company config |
| 🔴 P0 | **Tax Reporting ภ.พ.30** | Legal compliance — ยื่นภาษีไม่ได้ |
| 🟠 P1 | **Credit / Debit Note** | Returns และ adjustments พบบ่อยมาก |
| 🟠 P1 | **Receipt (ใบเสร็จ)** | Thai document requirement |
| 🟠 P1 | **Role & Permission UI** | User management ปัจจุบัน incomplete |
| 🟠 P1 | **Notification / Alert** | Low stock + overdue alerts — operational essential |
| 🟠 P1 | **Price Lists / Tiered Pricing** | B2B มีหลายราคา — ขายผิดราคาบ่อยมาก |
| 🟠 P1 | **Expiry Date Management** | Beauty regulatory + FEFO inventory |
| 🟠 P1 | **Bank Reconciliation** | Finance team ต้องการ daily |

### NICE-TO-HAVE (เพิ่มคุณค่า ไม่บล็อก launch)

| Priority | Module | เหตุผล |
|----------|--------|--------|
| 🟡 P2 | **Multi-currency** | Import beauty products — ต้องการแต่ workaround ได้ |
| 🟡 P2 | **Promotions / Trade Deals** | Sales team ต้องการ แต่ manage นอก system ได้ชั่วคราว |
| 🟡 P2 | **Commission / Sales Rep** | Nice tracking แต่ Excel ทดแทนได้ก่อน |
| 🟡 P2 | **Branch Management UI** | ถ้ามีแค่ branch เดียวใน MVP ผ่านได้ |
| 🟡 P2 | **Document Number Config UI** | Hard-code patterns ได้ก่อน |
| 🟡 P2 | **Audit Trail UI** | Logs มีใน DB แล้ว แต่ UI ไม่ด่วน |
| 🟡 P2 | **Return / RMA Flow** | ทำ manual credit note ก่อน |
| 🟢 P3 | **e-Tax Invoice Integration** | กรมสรรพากร integration — ซับซ้อนมาก ทำ PDF ก่อน |
| 🟢 P3 | **Mobile / PWA** | Phase 2 product evolution |
| 🟢 P3 | **Formula / Ingredient Records** | Manufacturer only |
| 🟢 P3 | **API / Webhook** | Phase 2 platform play |
| 🟢 P3 | **Brand / Product Line Categorization** | Nice UX, ทำใน products table ได้ก่อน |

---

## สรุป Executive

```
ความพร้อม (ปัจจุบัน)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
DB Schema        ████████████████░░  90%   ✅
UI Coverage      ████████░░░░░░░░░░  40%   ⚡
Thai Compliance  ████░░░░░░░░░░░░░░  25%   🔴
Beauty-specific  ██░░░░░░░░░░░░░░░░  10%   🔴
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

P0 gaps: 8 modules (บล็อก production)
P1 gaps: 7 modules (บล็อก daily operations)
P2 gaps: 8 modules (nice-to-have)
P3 gaps: 7 modules (future roadmap)
```

**คำแนะนำจาก Luxi**: เริ่ม sprint ด้วย P0 ทั้ง 8 โดย prioritize:  
1. Vendors UI + PO Create Form (unblock purchase cycle)  
2. Goods Receipt + Delivery Note (complete document flow)  
3. Quotation (unblock sales cycle start)  
4. Lot/Batch Tracking + Expiry (beauty compliance, DB schema change needed)  
5. ภ.พ.30 export (legal)  

---

*Analyzed by Luxi Oracle — 2026-06-02*  
*Source: `mission-control/orry-serenity/` — app routes, components, DB migrations, blueprint*
