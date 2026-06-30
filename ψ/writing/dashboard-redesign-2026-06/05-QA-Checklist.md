---
title: Dashboard Testing & QA Checklist
author: Khun-Ram Oracle (Skeleton) — QA team to verify before merge
date: 2026-06-28
status: SKELETON — Fill in detailed test cases
---

# Testing & QA Checklist — tham-oracle Dashboard Redesign

> Before merging to main, verify ALL of these. Sign off with date + tester name.

---

## Pre-Merge Checklist

### Build & Deployment

- [ ] `npm run build` passes without errors
- [ ] `npm run dev` starts without warnings
- [ ] No console errors on page load
- [ ] No TypeScript type errors
- [ ] All environment variables set (FILL: list required vars)

### Performance (Luxi's Golden Rule)

- [ ] Page loads in < 3 seconds (first visit, cold cache)
- [ ] Dashboard renders full content within 3 seconds
- [ ] User can identify mission status within 3 seconds of page load
- [ ] Polling interval doesn't spam backend (30s between requests)

**Test with**: 
- Fresh browser (clear cache)
- Network throttling (FILL: slow 4G? 3G?)
- FILL: Load testing tool (k6? Artillery?)

---

### Visual & Design (Luxi's Approval Required)

- [ ] All components match Luxi's design spec
- [ ] Colors correct for dark mode
- [ ] Card spacing and alignment consistent
- [ ] Typography (fonts, sizes, weights) as designed
- [ ] Icons render correctly (no broken images)
- [ ] Responsive layout works on all breakpoints:
  - [ ] Desktop (1024px+)
  - [ ] Tablet (640px-1024px)
  - [ ] Mobile (375px-640px)
- [ ] No visual regressions from previous version (if any)

**Sign-off**: Luxi Oracle __________ Date: __________

---

### Thai Language Support

- [ ] Thai text renders without broken diacritics
- [ ] Mixed Thai/English text displays correctly
- [ ] Line spacing accommodates Thai diacritics
- [ ] Font Noto Sans Thai is loaded (FILL: verify in dev tools)
- [ ] Test strings:
  - [ ] "Active Oracles: ออร์เรเคิล ออนไลน์"
  - [ ] "Phase 13 — เฟส 13"
  - [ ] "Priority: P1 (เร่งด่วน)"
  - [ ] FILL: Add more test strings

---

### Dark Mode

- [ ] All text is readable (WCAG AA contrast >= 4.5:1)
- [ ] Background colors consistent with dark theme
- [ ] Card borders visible against background
- [ ] Icons visible and not washed out
- [ ] No pure white text on pure black (too harsh)
- [ ] Badge colors distinct and readable
- [ ] Links have sufficient contrast

**Tool**: Use https://webaim.org/resources/contrastchecker/ to verify

---

### Accessibility (WCAG AA)

- [ ] Keyboard navigation works (Tab through all elements)
- [ ] Focus indicators visible on all interactive elements
- [ ] All icon-only buttons have aria-labels
- [ ] Form fields have proper labels (if any)
- [ ] Color is not the only way to convey information
- [ ] Motion/animations don't trigger seizures (FILL: verify)

**Test with**: 
- Keyboard only (no mouse)
- Screen reader (NVDA, JAWS, or macOS VoiceOver)

---

### API Integration

- [ ] Fleet Status endpoint responds correctly
- [ ] Phase Progress endpoint responds correctly
- [ ] Active Missions endpoint responds correctly
- [ ] Memory Health endpoint responds correctly
- [ ] Git State endpoint responds correctly
- [ ] Circuit Breaker endpoint responds correctly (if implemented)
- [ ] FILL: Add any additional endpoints

**Verify each endpoint**:
- [ ] Successful response (200) with correct data
- [ ] Error response (500) handled gracefully
- [ ] Network timeout handled gracefully
- [ ] Partial failures (one endpoint down, others up) handled

---

### Polling & Real-Time Updates

- [ ] Polling interval is 30 seconds (confirm in Network tab)
- [ ] Polling doesn't happen on unmounted component
- [ ] No memory leaks from repeated polling
- [ ] Data updates correctly when new values arrive
- [ ] FILL: Verify with test data that changes every poll

**Test with**: 
- Browser DevTools Network tab (watch polling)
- Browser DevTools Memory tab (watch for leaks)

---

### Error Handling

- [ ] Fleet API down → Show error message, don't crash
- [ ] Phase API down → Show error message, don't crash
- [ ] Missions API down → Show error message, don't crash
- [ ] Memory API down → Show error message, don't crash
- [ ] Git API down → Show error message, don't crash
- [ ] Partial failures handled (show data for working endpoints)
- [ ] Error messages are helpful (tell user to retry, check network, etc.)
- [ ] Retry button visible and functional
- [ ] Stale data warning shown if polling fails for > (FILL: X minutes)

**Test with**: 
- Kill backend server
- Disconnect network (DevTools → Offline mode)
- Slow network (DevTools → Slow 4G)

---

### State Management

- [ ] Component state updates when polling completes
- [ ] No state mutations (immutability check)
- [ ] No memory leaks from retained state
- [ ] Polling continues even if user navigates away (if SPA) or stops if navigated
- [ ] FILL: Verify specific state management library (if used)

---

### Browser Compatibility

- [ ] Chrome/Chromium (latest 2 versions)
- [ ] Firefox (latest 2 versions)
- [ ] Safari (latest 2 versions)
- [ ] Edge (latest 2 versions)
- [ ] Mobile Safari (iOS)
- [ ] Mobile Chrome (Android)
- [ ] FILL: Any other browsers required?

**Test with**: 
- BrowserStack or similar
- Multiple real devices (if budget allows)

---

### Mobile-Specific

- [ ] Touch targets are >= 44x44px (finger-friendly)
- [ ] No horizontal scrolling needed
- [ ] Viewport meta tag present and correct
- [ ] Orientation change (portrait → landscape) handled
- [ ] Bottom safe area respected (notches, home bar)
- [ ] Pinch-to-zoom works (not disabled)

**Test with**: 
- Chrome DevTools Device Mode
- Real mobile device

---

### Security

- [ ] No sensitive data exposed in logs
- [ ] No API keys visible in client code
- [ ] No CORS errors (check browser console)
- [ ] API endpoints require proper auth (FILL: if applicable)
- [ ] XSS prevention (sanitize user input, if any)
- [ ] FILL: Any other security concerns?

---

### Cross-Browser Data Persistence

- [ ] LocalStorage works (if used for caching)
- [ ] SessionStorage works (if used)
- [ ] Cookies (if used) work correctly
- [ ] Private browsing mode doesn't break anything
- [ ] FILL: Test specific storage mechanisms

---

### Regression Testing

- [ ] No previously working features broken
- [ ] Existing endpoints still respond same format
- [ ] FILL: Compare before/after API responses

---

### Edge Cases

- [ ] Empty data states (no oracles, no missions) render correctly
- [ ] Very large mission list (100+) renders without lag
- [ ] Very long mission title (200+ chars) displays correctly
- [ ] Special characters in data (emoji, quotes, etc.) handled
- [ ] Simultaneous updates to multiple endpoints handled
- [ ] FILL: Add more edge cases

---

### Documentation

- [ ] README updated with build/run instructions
- [ ] API changes documented (if any)
- [ ] New component props documented
- [ ] Environment variables documented
- [ ] FILL: Add any other docs

---

## Sign-Off

**Tester Name**: ____________________

**Date Tested**: ____________________

**Result**: ☐ PASS ☐ FAIL

**Notes**:
```
[List any issues found here]
```

**Reviewed By**: ____________________

**Date Approved**: ____________________

---

**[MARCUZ:Khun-Ram]** — QA checklist prepared.
*QA Team: Use this to verify dashboard before merge. Sign off when all items pass.*
