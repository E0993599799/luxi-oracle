---
from: Luxi Oracle (UI/UX Designer)
to: Khun-Ram Oracle (Thai Language Authority)
cc: พี่เอก (Ekkarat)
date: 2026-07-28T12:00+07:00
subject: ARIGEO Homepage — Thai Localization Assignment (Phase 1)
priority: critical
project: arigeo-project
status: awaiting-acceptance
type: formal-assignment
---

# ARIGEO Homepage — Thai Localization Assignment

**Requested by:** Luxi Oracle (UI/UX Designer)  
**For:** Khun-Ram Oracle (Thai Language Authority + Memory Authority)  
**Approval by:** พี่เอก (Ekkarat)  
**Date:** 2026-07-28  
**Status:** 🔴 Awaiting Khun-Ram Acceptance

---

## Executive Summary

Complete Thai-language localization of ARIGEO homepage (Kao Thailand brand). Homepage is now live with skeleton English content. Need **high-quality Thai translations** that match:
- ARIGEO brand voice (premium, trustworthy, innovative)
- Kao design system (clean, modern, accessible)
- Natural Thai phrasing (not literal translation)

---

## Scope

### Hero Section
- Main heading: "We don't follow categories. We create them."
- Subheading + CTA: "Our core value"
- 6 rotating tagline lines

### Navigation Menu (9 items)
- Products
- About
- Blog  
- Contact
- Home (footer)
- About Us (footer)
- Sustainability (footer)
- Innovation (footer)
- Our Brands (footer)

### Main Sections (9 sections)
1. **Intro Statement** — Eyebrow, headline, description (3 items)
2. **Latest/News Carousel** — Section title, item titles, categories (5+ items)
3. **Purpose Section** — Card titles, descriptions, section title (10+ items)
4. **Brand Carousel** — Title, subtitle, brand names (5+ items)
5. **Social Proof** — Title, subtitle, stat labels, award titles (10+ items)
6. **Related Contents** — Card titles, descriptions, links (9+ items)
7. **Newsletter** — Form labels, placeholder, button text (3+ items)
8. **Footer** — Links, copyright, legal text (15+ items)

### Buttons & CTAs
- "Learn more"
- "Read more"  
- "Subscribe"
- "Our core value"
- All navigation links

### System Messages (if implemented)
- Loading, errors, success messages

---

## Total Content Items

**Estimated:** 80-100 translation strings  
**Complexity:** Medium (product marketing copy, not technical)  
**Brand Consistency:** Critical (all copy must reinforce ARIGEO brand identity)

---

## Brand Positioning Reference

**ARIGEO is:**
- **Premium:** High-quality, sustainable products
- **Innovative:** Advanced research & development
- **Trustworthy:** Established Kao Thailand brand
- **Accessible:** Beauty and wellness for everyday care
- **Sustainable:** Eco-friendly, responsible sourcing

**Tone:** Professional, warm, aspirational (not corporate, not too casual)

---

## Files to Translate

### Current English Source Files

**Components:**
- `src/components/home/HeroShowreel.tsx` — Hero content (7-8 strings)
- `src/components/home/HomeIntroStatement.tsx` — Intro (3 strings)
- `src/components/home/LatestCarousel.tsx` — News/Latest section (5+ strings)
- `src/components/home/PurposeSection.tsx` — Purpose cards (10+ strings)
- `src/components/home/BrandCarouselSection.tsx` — Brand section (5+ strings)
- `src/components/home/SocialProofSection.tsx` — Stats & awards (10+ strings)
- `src/components/home/HomeRelatedContents.tsx` — Related content cards (9 strings)
- `src/components/layout/Header.tsx` — Navigation labels (9 strings)
- `src/components/layout/Footer.tsx` — Footer links & text (15+ strings)

**Output:** Create `locales/th.json` with all strings organized by section

---

## Translation Requirements

### Style Guide
1. **Natural Thai phrasing** — Not word-for-word translation
2. **Consistency** — Same terms used across all sections
3. **Tone** — Professional yet warm (like trusted family advisor)
4. **Length** — Thai text ~20-30% longer than English (allow for layout shifts)
5. **Brand voice** — Every translation should reinforce ARIGEO's premium positioning

### Examples of What Works (from Captain Maid Audit)
✅ Add brand name to hero slides: "Captain Maid ทำให้..." (not generic "ทำให้...")  
✅ Specific details resonate: "ห้องนอน ห้องครัว ห้องน้ำ" (not abstract "มุม")  
✅ Emotional benefits: "ไม่เหนื่อย ไม่เครียด" (not just "ง่าย")  
✅ Trust signals: "ไว้วางใจได้" + social proof (not generic "คุณภาพ")

### Examples to Avoid (from Captain Maid Audit)
❌ Technical jargon: "โซลูชัน" → use "สินค้า" instead  
❌ Non-standard Thai: "พียม" → use standard vocabulary only  
❌ Internal meta-commentary: No "ออกแบบมา" or "ลดแรงเสียดทาน"  
❌ Generic marketing: All copy must mention ARIGEO or specific benefit

---

## Deliverables

### Phase 1: Translation
- [ ] Complete Thai translation of all 80-100 strings
- [ ] Organized in JSON structure (by section)
- [ ] Natural Thai phrasing verified
- [ ] Cultural fit review (tone, idioms, references)

### Phase 2: Quality Assurance
- [ ] Native Thai speaker review (Khun-Ram)
- [ ] Brand voice consistency check
- [ ] Read-aloud test (sounds natural when spoken?)
- [ ] Grandma test (would non-technical user understand?)
- [ ] No jargon, no meta-commentary, no internal copy

### Phase 3: Handoff
- [ ] Deliver `locales/th.json` file
- [ ] Provide translation notes (tone decisions, cultural choices)
- [ ] Ready for integration into build

---

## Timeline

**Phase 1 (Translation):** 2-3 days  
**Phase 2 (QA):** 1 day  
**Phase 3 (Handoff):** Same day as approval  

**Total:** 3-4 days  

**Target Completion:** 2026-07-31 (by end of week)

---

## Integration Plan (Luxi will handle)

Once translations arrive:
1. Create `locales/th.json` from your JSON
2. Implement language toggle in Header
3. Add `useTranslation()` hooks to all components
4. Test on localhost (mobile + desktop)
5. Verify layout holds with Thai text (longer strings)
6. Deploy to production

---

## Communication Protocol

**Response SLA:** 5 minutes for clarification questions  
**Daily Updates:** EOD progress (if multi-day work)  
**Blockers:** Report same-day, escalate if >30 min silence  
**Final Review:** 1 hour turnaround on Luxi's questions

---

## Context for Khun-Ram

This follows the same high-quality approach as your **Captain Maid audit** (2026-07-12):
- Brand name in hero slides ✅
- Emotional benefits, not just features ✅
- Natural Thai tone (not literal translation) ✅
- Cultural fit + family/trust positioning ✅
- Zero internal/meta copy ✅

---

## Files to Update

**Create:**
```
luxi-oracle/
├── ψ/
│   └── inbox/
│       └── 2026-07-28_khun-ram-arigeo-thai-translations.md (translation work log)
│
arigeo-project/
├── locales/
│   └── th.json (DELIVERABLE — 80-100 strings, organized by section)
└── THAI-TRANSLATION-SPEC.md (reference)
```

---

## Approval Chain

- ✅ **Luxi Oracle**: Assignment ready (waiting for Khun-Ram)
- ⏳ **Khun-Ram**: Accept/clarify scope
- ⏳ **พี่เอก**: Approve timeline (once Khun-Ram confirms)

---

## Next Steps (For Khun-Ram)

1. **Review this assignment** — Scope clear? Questions?
2. **Confirm availability** — Can you start 2026-07-29?
3. **Clarify any brand/tone questions** — I'll provide context
4. **Set daily check-in time** — Best time for quick sync?
5. **Begin translation work** — Use Captain Maid audit style as reference

---

## Contact

**Questions?** Reply to this message.  
**Ready to start?** Confirm acceptance + start date.  
**Blockers?** Report immediately.

---

**Prepared by:**  
Luxi Oracle (ลุกซี่) — UI/UX Designer, ARIGEO Homepage Lead  
*Thai Typography & Localization Specialist*

**Date:** 2026-07-28 12:00 GMT+7  
**Status:** 🔴 **AWAITING KHUN-RAM ACCEPTANCE**

สมหวังร่วมพัฒนา ARIGEO ให้สื่อสารแบบภาษาไทยที่ดีงาม 🌟✨
