# Phase 5: Animations & Polish — Execution Handoff

**For**: codex-rider (execution specialist)  
**From**: Luxi Oracle (design + specification)  
**Approach**: Hybrid (CSS + Framer Motion)  
**Timeline**: 8-10 hours  
**Repository**: orry-serenity (https://github.com/E0993599799/orry-serenity)

---

## Mission

Transform the functional Orry Serenity design into a delightful experience through smooth, accessible animations. Execute Phase 5 animations using a hybrid CSS + Framer Motion approach.

**Success**: All 7 animation categories working smoothly, WCAG AAA compliant, 60fps performance, merged to main.

---

## Approach: Hybrid (CSS + Framer Motion)

### CSS-Only (Simple, no JS overhead)
Use for hover, focus, active states where CSS transitions suffice:
- Button hover/focus states
- Card hover effects
- Form input focus
- Badge animations

**Timing**: `cubic-bezier(0.4, 0, 0.2, 1)` (standard easing)  
**Duration**: 0.2s for fast feedback, 0.3s for prominent changes

### Framer Motion (Complex orchestration)
Use for interactive flows where orchestration needed:
- Modal entrance/exit (backdrop + content staggered)
- Page transitions (exit → enter with delay)
- Loading state spinners
- Hover sequences with multiple elements

**Install**: `bun add framer-motion`  
**Key components**: `motion.div`, `AnimatePresence`, `transition`

---

## Implementation Plan (8-10 hours)

### Phase 5.1: Setup Framer Motion (1 hour)

**Step 1: Install dependency**
```bash
cd /mnt/d/01\ Main\ Work/Boots/Agentic\ AI/mission-control/orry-serenity
bun add framer-motion
```

**Step 2: Create animation utilities file**
```typescript
// lib/animations.ts
export const easing = {
  fast: [0.4, 0, 0.2, 1],
  standard: [0.4, 0, 0.2, 1],
  slow: [0.33, 0.66, 0.66, 1],
};

export const transitions = {
  fast: { duration: 0.2, ease: easing.fast },
  standard: { duration: 0.3, ease: easing.standard },
  slow: { duration: 0.6, ease: easing.slow },
};

export const buttonVariants = {
  initial: { scale: 1, y: 0 },
  hover: { scale: 1.02, y: -2 },
  tap: { scale: 0.98, y: 0 },
};

export const modalBackdropVariants = {
  initial: { opacity: 0 },
  animate: { opacity: 1, transition: transitions.fast },
  exit: { opacity: 0, transition: transitions.fast },
};

export const modalContentVariants = {
  initial: { scale: 0.95, opacity: 0 },
  animate: { 
    scale: 1, 
    opacity: 1, 
    transition: { ...transitions.standard, delay: 0.1 } 
  },
  exit: { 
    scale: 0.95, 
    opacity: 0, 
    transition: transitions.fast 
  },
};
```

**Commit**: `feat: Install Framer Motion and create animation utilities`

---

### Phase 5.2: Animate Buttons (1 hour)

**File**: `components/ui/Button.tsx`

**Changes**:
```typescript
import { motion } from 'framer-motion';
import { buttonVariants, transitions } from '@/lib/animations';

export function Button({ variant, children, ...props }: ButtonProps) {
  return (
    <motion.button
      className={`${buttonClasses[variant]}`}
      whileHover="hover"
      whileTap="tap"
      initial="initial"
      variants={buttonVariants}
      transition={transitions.fast}
      {...props}
    >
      {children}
    </motion.button>
  );
}
```

**CSS additions** (if needed for box-shadow):
```css
button:hover {
  box-shadow: 0 12px 32px rgba(199, 46, 62, 0.2);
  transition: box-shadow 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}
```

**Test**:
- Hover over buttons → smooth lift + shadow
- Click buttons → press scale feedback
- Keyboard focus → cyan outline
- `prefers-reduced-motion` enabled → no animation

**Commit**: `feat: Animate Button component (hover/tap/focus states)`

---

### Phase 5.3: Animate Cards (1 hour)

**File**: `components/ui/Card.tsx`

**CSS approach** (no Framer Motion needed for simple hover):
```css
.glass-card {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.glass-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 16px 48px rgba(199, 46, 62, 0.2);
  border-color: var(--primary-light);
}

.glass-card:focus-within {
  border-color: var(--primary);
  outline: 2px solid #06b6d4;
  outline-offset: 2px;
}
```

**Test**:
- Hover over cards → lift + shadow + border glow
- Focus card content → outline appears
- `prefers-reduced-motion` → no hover lift

**Commit**: `feat: Animate Card component (CSS hover/focus states)`

---

### Phase 5.4: Animate Modals (1 hour)

**File**: `components/ui/Modal.tsx`

**Changes**:
```typescript
import { motion, AnimatePresence } from 'framer-motion';
import { modalBackdropVariants, modalContentVariants } from '@/lib/animations';

export function Modal({ isOpen, onClose, title, children, footer }: ModalProps) {
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="fixed inset-0 z-50 bg-black/60 backdrop-blur-sm flex items-center justify-center"
          onClick={onClose}
          role="presentation"
          variants={modalBackdropVariants}
          initial="initial"
          animate="animate"
          exit="exit"
        >
          <motion.div
            className="bg-[#6a3d3d] border border-[#8b5a5a] rounded-2xl shadow-2xl max-w-md w-full mx-4"
            onClick={(e) => e.stopPropagation()}
            variants={modalContentVariants}
            initial="initial"
            animate="animate"
            exit="exit"
          >
            {/* Header */}
            <div className="flex items-center justify-between px-6 py-4 border-b border-white/10">
              <h2 className="text-lg font-semibold text-[#f8f5f0]">{title}</h2>
              <button onClick={onClose} className="...">✕</button>
            </div>
            {/* Body */}
            <div className="p-6 text-[#d0ccc6]">{children}</div>
            {/* Footer */}
            {footer && (
              <div className="px-6 py-4 border-t border-white/10 flex gap-3 justify-end">
                {footer}
              </div>
            )}
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  );
}
```

**Test**:
- Open modal → backdrop fades in, content scales in with stagger
- Close modal → reverse animation
- Click outside → smooth close
- `prefers-reduced-motion` → instant show/hide

**Commit**: `feat: Animate Modal component (backdrop + content stagger)`

---

### Phase 5.5: Animate Form Inputs (1 hour)

**Files**: `components/ui/Input.tsx`, `components/ui/Label.tsx`

**CSS approach**:
```css
label {
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
}

input:focus ~ label,
input:not(:placeholder-shown) ~ label {
  transform: translateY(-1.5rem);
  font-size: 0.75rem;
  color: var(--primary);
}

input:focus {
  border-color: var(--primary);
  box-shadow: 0 0 0 3px rgba(199, 46, 62, 0.1);
  transition: all 0.2s ease-out;
}

input:focus-visible {
  outline: 2px solid #06b6d4;
  outline-offset: 2px;
}
```

**Test**:
- Focus input → border color, shadow, label slides up
- Type in input → label stays up
- Blur input (with value) → label stays up
- Clear input → label returns to normal
- `prefers-reduced-motion` → instant state changes

**Commit**: `feat: Animate Form inputs (focus transitions + label movement)`

---

### Phase 5.6: Animate Page Transitions (1 hour)

**File**: `app/[locale]/layout.tsx`

**Changes**:
```typescript
import { motion, AnimatePresence } from 'framer-motion';
import { usePathname } from 'next/navigation';

export default function RootLayout({ children, params }: Props) {
  const pathname = usePathname();

  return (
    <html lang={params.locale}>
      <body>
        <AnimatePresence mode="wait">
          <motion.div
            key={pathname}
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            transition={{ duration: 0.3 }}
          >
            {children}
          </motion.div>
        </AnimatePresence>
      </body>
    </html>
  );
}
```

**Test**:
- Navigate between pages → fade out, fade in
- Go back → same transition
- Multiple rapid clicks → animations queue properly
- `prefers-reduced-motion` → instant navigation

**Commit**: `feat: Animate page transitions (fade in/out)`

---

### Phase 5.7: Animate Loading States (1 hour)

**Files**: 
- `components/ui/Skeleton.tsx` (shimmer)
- `components/ui/Spinner.tsx` (rotation)
- `components/ui/ProgressBar.tsx` (width)

**Skeleton shimmer** (CSS):
```css
@keyframes shimmer {
  0% {
    background-position: -1000px 0;
  }
  100% {
    background-position: 1000px 0;
  }
}

.skeleton {
  background: linear-gradient(
    90deg,
    rgba(255, 255, 255, 0.1) 0%,
    rgba(255, 255, 255, 0.2) 50%,
    rgba(255, 255, 255, 0.1) 100%
  );
  background-size: 1000px 100%;
  animation: shimmer 2s infinite;
}
```

**Spinner** (CSS):
```css
@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  animation: spin 1.5s linear infinite;
}
```

**Progress bar** (Framer Motion):
```typescript
export function ProgressBar({ progress }: { progress: number }) {
  return (
    <div className="h-1 bg-gray-200 rounded-full overflow-hidden">
      <motion.div
        className="h-full bg-primary"
        animate={{ width: `${progress}%` }}
        transition={{ duration: 0.4 }}
      />
    </div>
  );
}
```

**Test**:
- Show skeleton → shimmer animation
- Show spinner → smooth rotation
- Increment progress → smooth width increase
- `prefers-reduced-motion` → no animation

**Commit**: `feat: Add loading state animations (shimmer/spinner/progress)`

---

### Phase 5.8: Polish & Refinement (1-2 hours)

**Checklist**:
- [ ] Test all buttons on hover/focus/press
- [ ] Cards lift smoothly on hover
- [ ] Modals appear/disappear smoothly
- [ ] Form inputs show focus transitions
- [ ] Page navigation is smooth
- [ ] Loading states provide feedback
- [ ] No jank or frame drops (test on low-end device)
- [ ] Lighthouse Performance score ≥ 90

**Performance check**:
```bash
bun run build
bun run start
# Open browser DevTools → Performance tab
# Record page interactions
# Check FPS (should be 60, minimum 50)
```

**Fix jank if found**:
- Check for layout shifts (CLS should be 0)
- Verify using GPU-accelerated properties (transform, opacity only)
- Add `will-change: transform` sparingly to animated elements

**Commit**: `fix: Polish animations (performance optimizations)`

---

### Phase 5.9: Documentation (1 hour)

**Create**: `docs/ANIMATION_GUIDE.md`

```markdown
# Animation Guide

## Timing & Easing

- **Fast feedback** (0.2s): Buttons, basic interactions
- **Standard transition** (0.3s): Cards, modals, focus states
- **Slow animation** (0.6s): Page transitions, large movements

**Easing function**: `cubic-bezier(0.4, 0, 0.2, 1)` (standard)

## Components with Animations

- **Button**: Hover lift, press scale, focus glow
- **Card**: Hover lift + shadow, focus outline
- **Modal**: Backdrop fade, content scale-in (staggered 0.1s)
- **Input**: Focus border/shadow, label slide
- **Page**: Fade in/out on navigation
- **Loading**: Shimmer, spinner, progress bar

## Accessibility

All animations respect `prefers-reduced-motion`:
- When enabled: Animations disabled, state changes instant
- Test in: Browser DevTools → Rendering → Emulate CSS media feature prefers-reduced-motion

## Performance

- All animations use GPU-accelerated properties (transform, opacity)
- No layout shifts (CLS = 0)
- Target: 60fps on all devices
- Lighthouse score: 90+
```

**Commit**: `docs: Add animation guide and patterns documentation`

---

## Testing Checklist

### ✅ Functional Tests
- [ ] All buttons animate on hover (lift + shadow)
- [ ] All buttons animate on press (scale down)
- [ ] All buttons show focus ring (cyan outline)
- [ ] Cards lift on hover
- [ ] Cards show focus ring when focused
- [ ] Modals fade in/out smoothly
- [ ] Modal content scales in after backdrop
- [ ] Form inputs show focus transitions
- [ ] Labels slide up on focus/input
- [ ] Page transitions fade in/out
- [ ] Loading spinners rotate smoothly
- [ ] Progress bars animate smoothly

### ✅ Accessibility Tests
- [ ] prefers-reduced-motion enabled → animations disabled
- [ ] Keyboard navigation works (no focus loss)
- [ ] Screen reader still announces content correctly
- [ ] No seizure risk (no flashing, rapid motion)
- [ ] Color not the only indicator (hover + text changes)

### ✅ Performance Tests
- [ ] Lighthouse Performance score ≥ 90
- [ ] No CLS (Cumulative Layout Shift = 0)
- [ ] No jank (60fps on test device)
- [ ] Bundle size increase < 50KB (target ~20KB with Framer Motion)
- [ ] Dev server runs smoothly

### ✅ Browser Tests
- [ ] Chrome (latest)
- [ ] Firefox (latest)
- [ ] Safari (latest)
- [ ] Edge (latest)
- [ ] Mobile Chrome
- [ ] Mobile Safari

---

## Git Workflow

**Branch**: `feat/animations-polish`

**Commits** (in order):
1. `feat: Install Framer Motion and create animation utilities`
2. `feat: Animate Button component (hover/tap/focus states)`
3. `feat: Animate Card component (CSS hover/focus states)`
4. `feat: Animate Modal component (backdrop + content stagger)`
5. `feat: Animate Form inputs (focus transitions + label movement)`
6. `feat: Animate page transitions (fade in/out)`
7. `feat: Add loading state animations (shimmer/spinner/progress)`
8. `fix: Polish animations (performance optimizations)`
9. `docs: Add animation guide and patterns documentation`

**PR**: Single PR with all Phase 5 work
- Title: `feat: Phase 5 - Animations & Polish`
- Include: Before/after description, performance metrics, accessibility verification

---

## Success Metrics

✅ **Animations**: All 7 categories working smoothly  
✅ **Accessible**: prefers-reduced-motion respected  
✅ **Performance**: 60fps, 0 CLS, Lighthouse 90+  
✅ **Documented**: ANIMATION_GUIDE.md complete  
✅ **Tested**: All browsers, devices, accessibility verified  
✅ **Merged**: PR reviewed and merged to main  

---

## Handoff Summary

**Start**: `feat/animations-polish` branch  
**End**: Merged to main with all Phase 5 work complete  
**Duration**: 8-10 hours  
**Approach**: Hybrid (CSS + Framer Motion)  
**Quality**: WCAG AAA + 60fps performance  

**Next phase**: Phase 6 (Forms & Conversions) — Let Luxi know when Phase 5 is complete.

---

*Handoff prepared by Luxi Oracle — Ready for codex-rider execution*
*2026-07-03 02:00 GMT+7*
