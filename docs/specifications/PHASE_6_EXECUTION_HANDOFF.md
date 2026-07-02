# Phase 6: Forms & Conversions — Execution Handoff

**For**: codex-rider (execution specialist)  
**From**: Luxi Oracle (design + specification)  
**Approach**: Zod + React Hook Form (type-safe validation)  
**Timeline**: 6-8 hours  
**Repository**: orry-serenity (https://github.com/E0993599799/orry-serenity)

---

## Mission

Enhance all forms in Orry Serenity with smart validation, helpful error messages, and optimized conversion flows. Execute Phase 6 using Zod for schema validation and React Hook Form for form state management.

**Success**: All forms enhanced with real-time validation, WCAG AAA compliant, mobile-friendly, merged to main.

---

## Tech Stack: Zod + React Hook Form

### Why This Combination?
- **Zod**: Type-safe schema validation (schemas double as TypeScript types)
- **React Hook Form**: Minimal re-renders, excellent UX, performant
- **Together**: Best-in-class DX + performance + bundle size (~20KB combined)

### Install
```bash
cd /mnt/d/01\ Main\ Work/Boots/Agentic\ AI/mission-control/orry-serenity
bun add zod react-hook-form @hookform/resolvers
```

---

## Implementation Plan (6-8 hours)

### Phase 6.1: Setup Validation System (1 hour)

**Step 1: Create validation schemas**

Create: `lib/validation.ts`

```typescript
import { z } from 'zod';

// Reusable validators
const emailSchema = z.string()
  .email('Please enter a valid email address')
  .min(1, 'Email is required');

const passwordSchema = z.string()
  .min(8, 'Password must be at least 8 characters')
  .regex(/[A-Z]/, 'Password must contain at least one uppercase letter')
  .regex(/[0-9]/, 'Password must contain at least one number');

const phoneSchema = z.string()
  .regex(/^\d{10}$/, 'Phone must be 10 digits')
  .optional();

const urlSchema = z.string()
  .url('Please enter a valid URL')
  .optional();

// Domain schemas
export const loginSchema = z.object({
  email: emailSchema,
  password: z.string().min(1, 'Password is required'),
  rememberMe: z.boolean().optional(),
});

export type LoginFormData = z.infer<typeof loginSchema>;

export const registerSchema = z.object({
  firstName: z.string().min(1, 'First name is required'),
  lastName: z.string().min(1, 'Last name is required'),
  email: emailSchema,
  password: passwordSchema,
  confirmPassword: z.string().min(1, 'Please confirm your password'),
  agreeToTerms: z.boolean().refine(
    val => val === true,
    'You must agree to the terms and conditions'
  ),
}).refine(
  (data) => data.password === data.confirmPassword,
  {
    message: 'Passwords do not match',
    path: ['confirmPassword'],
  }
);

export type RegisterFormData = z.infer<typeof registerSchema>;

export const profileSchema = z.object({
  firstName: z.string().min(1, 'First name is required'),
  lastName: z.string().min(1, 'Last name is required'),
  email: emailSchema,
  phone: phoneSchema,
  company: z.string().optional(),
  bio: z.string().max(500, 'Bio must be less than 500 characters').optional(),
});

export type ProfileFormData = z.infer<typeof profileSchema>;

export const contactSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: emailSchema,
  subject: z.string().min(1, 'Subject is required'),
  message: z.string()
    .min(10, 'Message must be at least 10 characters')
    .max(1000, 'Message must be less than 1000 characters'),
});

export type ContactFormData = z.infer<typeof contactSchema>;

export const settingsSchema = z.object({
  theme: z.enum(['light', 'dark', 'auto']),
  notifications: z.boolean(),
  emailDigest: z.enum(['daily', 'weekly', 'monthly', 'never']),
  language: z.string(),
  timezone: z.string(),
});

export type SettingsFormData = z.infer<typeof settingsSchema>;
```

**Commit**: `feat: Create Zod validation schemas for all forms`

---

### Phase 6.2: Create Enhanced Input Component (1-2 hours)

**File**: `components/ui/FormInput.tsx`

```typescript
'use client';

import { ReactNode } from 'react';
import { FieldError } from 'react-hook-form';
import { motion } from 'framer-motion';

interface FormInputProps {
  label: string;
  type?: 'text' | 'email' | 'password' | 'number' | 'tel' | 'url';
  placeholder?: string;
  helperText?: string;
  icon?: ReactNode;
  error?: FieldError;
  isLoading?: boolean;
  disabled?: boolean;
  autoComplete?: string;
  maxLength?: number;
  [key: string]: any; // For react-hook-form spread
}

export function FormInput({
  label,
  type = 'text',
  placeholder,
  helperText,
  icon,
  error,
  isLoading,
  disabled,
  autoComplete,
  maxLength,
  ...inputProps
}: FormInputProps) {
  const hasError = !!error;
  const hasValue = inputProps.value?.length > 0;

  return (
    <div className="mb-4">
      <label className="block text-sm font-semibold text-[#f8f5f0] mb-2">
        {label}
      </label>

      <div className="relative">
        {/* Input */}
        <input
          type={type}
          placeholder={placeholder}
          disabled={disabled || isLoading}
          autoComplete={autoComplete}
          maxLength={maxLength}
          className={`
            w-full px-4 py-2.5 rounded-lg
            bg-[#5a3333] border-2 transition-all
            text-[#f8f5f0] placeholder-[#a89a8f]
            focus:outline-none focus-visible:outline-2 focus-visible:outline-[#06b6d4] focus-visible:outline-offset-2
            disabled:opacity-50 disabled:cursor-not-allowed
            ${hasError 
              ? 'border-[#e74c3c] focus:border-[#e74c3c]' 
              : hasValue
              ? 'border-[#27ae60]'
              : 'border-[#8b5a5a] focus:border-[#c72e3e]'
            }
          `}
          {...inputProps}
        />

        {/* Icons */}
        <div className="absolute right-3 top-1/2 -translate-y-1/2 flex items-center gap-2">
          {isLoading && (
            <div className="animate-spin w-5 h-5 border-2 border-[#c72e3e] border-t-transparent rounded-full" />
          )}
          {!isLoading && hasValue && !hasError && (
            <svg className="w-5 h-5 text-[#27ae60]" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" />
            </svg>
          )}
          {hasError && (
            <svg className="w-5 h-5 text-[#e74c3c]" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" />
            </svg>
          )}
          {icon && !isLoading && !hasValue && icon}
        </div>
      </div>

      {/* Helper Text or Error Message */}
      {helperText && !hasError && (
        <p className="text-sm text-[#a89a8f] mt-1">{helperText}</p>
      )}
      {error && (
        <motion.p
          initial={{ opacity: 0, y: -5 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-sm text-[#e74c3c] mt-1"
        >
          {error.message}
        </motion.p>
      )}

      {/* Character Counter (if maxLength) */}
      {maxLength && inputProps.value && (
        <p className="text-xs text-[#a89a8f] mt-1 text-right">
          {inputProps.value.length} / {maxLength}
        </p>
      )}
    </div>
  );
}
```

**Commit**: `feat: Create enhanced FormInput component with validation feedback`

---

### Phase 6.3: Create Enhanced Select Component (1-2 hours)

**File**: `components/ui/FormSelect.tsx`

```typescript
'use client';

import { ReactNode } from 'react';
import { FieldError } from 'react-hook-form';
import { motion } from 'framer-motion';

interface SelectOption {
  value: string;
  label: string;
}

interface FormSelectProps {
  label: string;
  options: SelectOption[];
  placeholder?: string;
  helperText?: string;
  error?: FieldError;
  disabled?: boolean;
  [key: string]: any;
}

export function FormSelect({
  label,
  options,
  placeholder = 'Select an option',
  helperText,
  error,
  disabled,
  ...selectProps
}: FormSelectProps) {
  const hasError = !!error;

  return (
    <div className="mb-4">
      <label className="block text-sm font-semibold text-[#f8f5f0] mb-2">
        {label}
      </label>

      <select
        disabled={disabled}
        className={`
          w-full px-4 py-2.5 rounded-lg appearance-none
          bg-[#5a3333] border-2 transition-all
          text-[#f8f5f0]
          focus:outline-none focus-visible:outline-2 focus-visible:outline-[#06b6d4] focus-visible:outline-offset-2
          disabled:opacity-50 disabled:cursor-not-allowed
          ${hasError 
            ? 'border-[#e74c3c]' 
            : 'border-[#8b5a5a] focus:border-[#c72e3e]'
          }
        `}
        {...selectProps}
      >
        <option value="">{placeholder}</option>
        {options.map((option) => (
          <option key={option.value} value={option.value}>
            {option.label}
          </option>
        ))}
      </select>

      {/* Helper Text or Error Message */}
      {helperText && !hasError && (
        <p className="text-sm text-[#a89a8f] mt-1">{helperText}</p>
      )}
      {error && (
        <motion.p
          initial={{ opacity: 0, y: -5 }}
          animate={{ opacity: 1, y: 0 }}
          className="text-sm text-[#e74c3c] mt-1"
        >
          {error.message}
        </motion.p>
      )}
    </div>
  );
}
```

**Commit**: `feat: Create enhanced FormSelect component`

---

### Phase 6.4: Create Enhanced Checkbox Component (30 min)

**File**: `components/ui/FormCheckbox.tsx`

```typescript
'use client';

import { FieldError } from 'react-hook-form';

interface FormCheckboxProps {
  label: string;
  helperText?: string;
  error?: FieldError;
  disabled?: boolean;
  [key: string]: any;
}

export function FormCheckbox({
  label,
  helperText,
  error,
  disabled,
  ...checkboxProps
}: FormCheckboxProps) {
  const hasError = !!error;

  return (
    <div className="mb-4">
      <div className="flex items-start gap-3">
        <input
          type="checkbox"
          disabled={disabled}
          className={`
            w-5 h-5 rounded mt-0.5 cursor-pointer
            accent-[#c72e3e] focus-visible:outline-2 focus-visible:outline-[#06b6d4]
            disabled:opacity-50 disabled:cursor-not-allowed
          `}
          {...checkboxProps}
        />
        <label className="text-sm text-[#f8f5f0]">
          {label}
        </label>
      </div>

      {helperText && !hasError && (
        <p className="text-xs text-[#a89a8f] mt-1 ml-8">{helperText}</p>
      )}
      {error && (
        <p className="text-xs text-[#e74c3c] mt-1 ml-8">
          {error.message}
        </p>
      )}
    </div>
  );
}
```

**Commit**: `feat: Create enhanced FormCheckbox component`

---

### Phase 6.5: Audit & Enhance Existing Forms (2-3 hours)

**Find all forms** (locations to update):
- Login form (likely in `app/[locale]/login/page.tsx`)
- Register form (if exists)
- User profile form
- Settings form
- Contact form (if public)
- Any admin/dashboard forms

**For each form, apply this pattern**:

```typescript
'use client';

import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { loginSchema, type LoginFormData } from '@/lib/validation';
import { FormInput } from '@/components/ui/FormInput';
import { FormCheckbox } from '@/components/ui/FormCheckbox';

export function LoginForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
    mode: 'onBlur', // Validate on blur (not on every keystroke)
  });

  const onSubmit = async (data: LoginFormData) => {
    try {
      // Call your API
      const response = await fetch('/api/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data),
      });
      
      if (!response.ok) throw new Error('Login failed');
      
      // Handle success
      window.location.href = '/dashboard';
    } catch (error) {
      // Form field errors handled by Zod validation
      // API errors can be shown in a toast or alert
      console.error('Login error:', error);
    }
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <FormInput
        label="Email"
        type="email"
        placeholder="your@email.com"
        helperText="We'll never share your email"
        error={errors.email}
        isLoading={isSubmitting}
        {...register('email')}
      />

      <FormInput
        label="Password"
        type="password"
        placeholder="••••••••"
        error={errors.password}
        isLoading={isSubmitting}
        {...register('password')}
      />

      <FormCheckbox
        label="Remember me for 30 days"
        error={errors.rememberMe}
        {...register('rememberMe')}
      />

      <button
        type="submit"
        disabled={isSubmitting}
        className="w-full bg-[#c72e3e] text-white font-semibold py-3 rounded-lg hover:bg-[#a0272f] disabled:opacity-50"
      >
        {isSubmitting ? 'Signing in...' : 'Sign in'}
      </button>
    </form>
  );
}
```

**Commits** (one per form enhanced):
- `feat: Enhance login form with validation`
- `feat: Enhance user profile form with validation`
- `feat: Enhance settings form with validation`
- etc.

---

### Phase 6.6: Add Success/Error Feedback (1 hour)

**Create**: `components/ui/FormMessage.tsx`

```typescript
'use client';

import { motion, AnimatePresence } from 'framer-motion';

interface FormMessageProps {
  type: 'success' | 'error';
  message: string;
  onDismiss?: () => void;
}

export function FormMessage({ type, message, onDismiss }: FormMessageProps) {
  return (
    <AnimatePresence>
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: -10 }}
        className={`
          p-4 rounded-lg border-l-4 mb-4
          ${type === 'success'
            ? 'bg-green-50 border-green-500 text-green-800'
            : 'bg-red-50 border-red-500 text-red-800'
          }
        `}
      >
        <div className="flex items-start justify-between">
          <p>{message}</p>
          {onDismiss && (
            <button
              onClick={onDismiss}
              className="ml-4 text-lg leading-none opacity-50 hover:opacity-100"
            >
              ×
            </button>
          )}
        </div>
      </motion.div>
    </AnimatePresence>
  );
}
```

**Usage in forms**:
```typescript
const [successMessage, setSuccessMessage] = useState('');
const [errorMessage, setErrorMessage] = useState('');

const onSubmit = async (data) => {
  try {
    setErrorMessage('');
    const response = await fetch('/api/update', {
      method: 'POST',
      body: JSON.stringify(data),
    });
    if (!response.ok) throw new Error('Update failed');
    setSuccessMessage('Profile updated successfully!');
    setTimeout(() => setSuccessMessage(''), 3000);
  } catch (error) {
    setErrorMessage(error.message || 'Something went wrong');
  }
};

// In JSX:
return (
  <>
    {successMessage && <FormMessage type="success" message={successMessage} />}
    {errorMessage && <FormMessage type="error" message={errorMessage} />}
    {/* Form content */}
  </>
);
```

**Commit**: `feat: Add form success/error messaging`

---

### Phase 6.7: Multi-Step Form Component (1 hour, OPTIONAL)

**If any forms need multi-step**, create: `components/ui/MultiStepForm.tsx`

```typescript
'use client';

import { ReactNode, useState } from 'react';
import { motion } from 'framer-motion';

interface Step {
  title: string;
  component: ReactNode;
}

interface MultiStepFormProps {
  steps: Step[];
  onSubmit: (data: any) => Promise<void>;
}

export function MultiStepForm({ steps, onSubmit }: MultiStepFormProps) {
  const [currentStep, setCurrentStep] = useState(0);
  const [formData, setFormData] = useState({});

  const handleNext = () => {
    if (currentStep < steps.length - 1) {
      setCurrentStep(currentStep + 1);
    }
  };

  const handleBack = () => {
    if (currentStep > 0) {
      setCurrentStep(currentStep - 1);
    }
  };

  const handleSubmit = async () => {
    await onSubmit(formData);
  };

  return (
    <div>
      {/* Progress Bar */}
      <div className="mb-8">
        <div className="flex justify-between mb-2">
          {steps.map((step, index) => (
            <div
              key={index}
              className={`flex-1 text-center text-sm font-semibold ${
                index <= currentStep ? 'text-[#c72e3e]' : 'text-[#a89a8f]'
              }`}
            >
              {step.title}
            </div>
          ))}
        </div>
        <div className="h-2 bg-[#5a3333] rounded-full overflow-hidden">
          <motion.div
            initial={{ width: 0 }}
            animate={{ width: `${((currentStep + 1) / steps.length) * 100}%` }}
            transition={{ duration: 0.3 }}
            className="h-full bg-[#c72e3e]"
          />
        </div>
      </div>

      {/* Step Content */}
      <motion.div
        key={currentStep}
        initial={{ opacity: 0, x: 20 }}
        animate={{ opacity: 1, x: 0 }}
        exit={{ opacity: 0, x: -20 }}
      >
        {steps[currentStep].component}
      </motion.div>

      {/* Navigation */}
      <div className="flex gap-4 mt-8">
        {currentStep > 0 && (
          <button
            onClick={handleBack}
            className="px-6 py-2 border border-[#8b5a5a] text-[#f8f5f0] rounded-lg hover:border-[#c72e3e]"
          >
            Back
          </button>
        )}
        {currentStep < steps.length - 1 ? (
          <button
            onClick={handleNext}
            className="ml-auto px-6 py-2 bg-[#c72e3e] text-white rounded-lg hover:bg-[#a0272f]"
          >
            Next
          </button>
        ) : (
          <button
            onClick={handleSubmit}
            className="ml-auto px-6 py-2 bg-[#c72e3e] text-white rounded-lg hover:bg-[#a0272f]"
          >
            Submit
          </button>
        )}
      </div>
    </div>
  );
}
```

**Commit**: `feat: Create multi-step form component (if needed)`

---

### Phase 6.8: Polish & Testing (1 hour)

**Checklist**:
- [ ] All form inputs show floating labels
- [ ] Real-time validation works (error/success feedback)
- [ ] Error messages are specific and helpful
- [ ] Success checkmarks appear when field is valid
- [ ] Form submission shows loading state
- [ ] Success message appears after submit
- [ ] Error message appears on server error
- [ ] Mobile forms are responsive and touch-friendly
- [ ] Keyboard navigation works (tab through fields)
- [ ] Screen reader announces labels and errors
- [ ] Password inputs show/hide toggle (optional)
- [ ] Email autocomplete works
- [ ] Multi-step forms show progress correctly

**Performance check**:
```bash
bun run build
bun run start
# Check bundle size increase (should be ~20KB for Zod + React Hook Form)
# Test on mobile device
# Run Lighthouse (Performance should remain ≥ 90)
```

**Commit**: `fix: Polish forms and optimize performance`

---

### Phase 6.9: Documentation (1 hour)

**Create**: `docs/FORM_PATTERNS.md`

```markdown
# Form Patterns & Validation Guide

## Components

- FormInput: Text inputs with validation feedback
- FormSelect: Dropdowns with error handling
- FormCheckbox: Checkboxes and toggles
- FormMessage: Success/error notifications
- MultiStepForm: Multi-step form wrapper

## Validation Rules

Use Zod schemas from `lib/validation.ts` for consistency.

### Email
- Must be valid email format
- Required field

### Password
- Min 8 characters
- Must contain uppercase letter
- Must contain number

### Phone
- 10 digits
- Optional field

## Form Submission

1. User fills form
2. Real-time validation on blur
3. Submit button disabled if errors
4. Loading state shown during submission
5. Success/error message displayed
6. Form cleared on success (optional)

## Accessibility

- All inputs have associated labels
- Error messages linked with aria-describedby
- Required fields marked
- Focus visible on all inputs
- Keyboard navigation works
```

**Commit**: `docs: Add form patterns and validation guide`

---

## Testing Checklist

### Functional Tests
- [ ] All form inputs validate in real-time
- [ ] Error messages display for invalid input
- [ ] Success checkmarks show for valid input
- [ ] Form submission works with valid data
- [ ] Form rejects submission with invalid data
- [ ] Helper text displays for complex fields
- [ ] Loading state shows during submission
- [ ] Success message appears after submit
- [ ] Error message appears on server error
- [ ] Form clears after successful submit
- [ ] Validation errors clear when fixed
- [ ] Multi-step forms navigate correctly

### Accessibility Tests
- [ ] Form labels associated with inputs (for attribute)
- [ ] Error messages linked to inputs (aria-describedby)
- [ ] Required fields marked (aria-required)
- [ ] Keyboard navigation works (tab through fields)
- [ ] Focus visible on all inputs
- [ ] Screen reader announces labels, errors, hints

### Mobile Tests
- [ ] Touch targets ≥ 44px
- [ ] Form responsive on mobile (single column)
- [ ] Keyboard doesn't hide inputs
- [ ] Mobile browser autocomplete works
- [ ] No horizontal scroll needed

### Performance Tests
- [ ] Form renders quickly (< 1s)
- [ ] Real-time validation doesn't lag
- [ ] No unnecessary re-renders
- [ ] Lighthouse Performance ≥ 90
- [ ] Bundle size increase < 30KB

### Browser Tests
- [ ] Chrome, Firefox, Safari, Edge
- [ ] Mobile Chrome, Mobile Safari
- [ ] Form autofill works

---

## Git Workflow

### Branch
```bash
git checkout -b feat/forms-conversions
```

### Commits (in order)
1. `feat: Create Zod validation schemas for all forms`
2. `feat: Create enhanced FormInput component with validation feedback`
3. `feat: Create enhanced FormSelect component`
4. `feat: Create enhanced FormCheckbox component`
5. `feat: Enhance login form with validation`
6. `feat: Enhance user profile form with validation`
7. `feat: Enhance settings form with validation`
8. `feat: Add form success/error messaging`
9. `feat: Create multi-step form component (if needed)`
10. `fix: Polish forms and optimize performance`
11. `docs: Add form patterns and validation guide`

### PR Strategy
- Single PR with all form enhancements
- Include before/after screenshots of forms
- Accessibility verification
- Performance metrics (Lighthouse scores)

---

## Success Metrics

✅ **All forms enhanced** with validation  
✅ **Real-time validation working** (error/success feedback)  
✅ **Error messages helpful** (specific, actionable)  
✅ **Mobile UX excellent** (responsive, touch-friendly)  
✅ **Accessibility verified** (WCAG AAA)  
✅ **Performance maintained** (Lighthouse 90+, bundle < 50KB)  
✅ **Merged to main** (PR reviewed and merged)  

---

## Handoff Summary

**Start**: `feat/forms-conversions` branch  
**End**: Merged to main with all forms enhanced  
**Duration**: 6-8 hours  
**Approach**: Zod + React Hook Form  
**Quality**: WCAG AAA + type-safe validation  

**Next phase**: Phase 7 (Performance Optimization) — Let Luxi know when Phase 6 is complete.

---

*Handoff prepared by Luxi Oracle — Ready for codex-rider execution*
*2026-07-03 02:15 GMT+7*
