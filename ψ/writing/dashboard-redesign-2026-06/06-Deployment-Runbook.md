---
title: Dashboard Deployment Runbook
author: Khun-Ram Oracle (Skeleton) — DevOps to complete
date: 2026-06-28
status: SKELETON — Fill in deployment procedures
---

# Deployment Runbook — tham-oracle Dashboard

> Step-by-step procedures for deploying dashboard to staging and production.

---

## Pre-Deployment Checklist

- [ ] QA checklist complete and signed off
- [ ] All tests passing locally
- [ ] No uncommitted changes in working directory
- [ ] Current branch is clean and up-to-date with main
- [ ] Environment variables configured for target environment
- [ ] Database migrations (if any) tested
- [ ] FILL: Any other pre-deployment steps?

---

## Deployment to Staging

### Step 1: Build

```bash
npm run build
```

**Expected**: No errors, `dist/` or `.next/` directory created

**Troubleshoot**:
- FILL: Common build errors?
- FILL: How to fix TypeScript errors?

---

### Step 2: Verify Build Artifacts

```bash
ls -la dist/  # or .next/ for Next.js
```

**Expected**: Static files or build output present

---

### Step 3: Deploy to Staging

```bash
# FILL: Staging deployment command
# Examples:
# npm run deploy:staging
# vercel deploy --prod --name staging
# aws s3 sync dist/ s3://staging-bucket
```

**Expected**: Deployment succeeds, URL provided

**Verify**:
- [ ] Staging URL accessible
- [ ] No 5xx errors in staging logs

---

### Step 4: Smoke Test Staging

```bash
# Visit staging URL
# FILL: Manual checks
# - Does dashboard load in < 3 seconds?
# - Can you see all cards?
# - Does polling work (watch Network tab)?
# - Are there any console errors?
```

**Expected**: Dashboard fully functional on staging

---

### Step 5: Run Automated Tests on Staging

```bash
# FILL: Smoke test / E2E test command
npm run test:smoke:staging
```

**Expected**: All tests pass

---

### Step 6: Staging Sign-Off

- [ ] DevOps verifies staging deployment
- [ ] QA confirms staging is working
- [ ] Ready to promote to production

**Signed by**: ____________________

**Date**: ____________________

---

## Deployment to Production

### Step 1: Final Pre-Flight Check

- [ ] Staging is healthy (no errors, good performance)
- [ ] All team members notified of planned deployment
- [ ] Maintenance window scheduled (if needed)
- [ ] FILL: Any other checks?

---

### Step 2: Deploy to Production

```bash
# FILL: Production deployment command
# Examples:
# npm run deploy:production
# vercel deploy --prod
# aws s3 sync dist/ s3://production-bucket --cloudfront-invalidation
```

**Expected**: Deployment succeeds

---

### Step 3: Verify Production Deployment

```bash
# Visit production URL
curl https://tham-oracle.pages.dev/  # or actual domain

# FILL: Check:
# - HTTP 200 response
# - Correct HTML served
# - No 5xx errors
```

**Expected**: Production site responds correctly

---

### Step 4: Smoke Test Production

```bash
# FILL: Smoke test / E2E test command
npm run test:smoke:production
```

**Expected**: All tests pass

---

### Step 5: Monitor Logs

```bash
# FILL: Check production logs for errors
# Examples:
# - CloudFlare logs
# - Application error logs
# - API gateway logs
# - Database logs
```

**Monitor for 10+ minutes**:
- [ ] No spike in error rate
- [ ] Response times normal
- [ ] No sign of memory leaks or crashes

---

### Step 6: Production Sign-Off

- [ ] Deployment successful
- [ ] Smoke tests passed
- [ ] No errors in logs
- [ ] Team notified of successful deployment

**Signed by**: ____________________

**Date**: ____________________

---

## Rollback Procedure

**If production is broken:**

### Step 1: Assess Damage

- [ ] What is broken? (specific feature, entire site, API?)
- [ ] How many users affected? (all, some, specific regions?)
- [ ] Can we fix it quick (< 30 min) or rollback? (FILL: decide threshold)

---

### Step 2: Notify Stakeholders

```
Message to: ธาม Oracle, team chat, etc.
Subject: DASHBOARD INCIDENT - [Issue Description]
Action: Rolling back to previous version
ETA: 30 minutes
```

---

### Step 3: Rollback to Previous Version

```bash
# FILL: Rollback command
# Examples:
# git revert [commit-hash]
# vercel rollback
# aws s3 sync s3://production-bucket-backup dist/ --s3-cloudfront-invalidation
```

**Expected**: Previous version deployed and serving traffic

---

### Step 4: Verify Rollback

```bash
# FILL: Verify:
# - Site loads correctly
# - No errors in logs
# - Performance is normal
```

---

### Step 5: Root Cause Analysis

After rollback, do NOT re-deploy immediately:

1. Identify what broke
2. Fix the issue
3. Test fix locally and on staging
4. Get approval before re-deploying

**Document**: Create incident report with root cause

---

## Monitoring & Alerting

### Key Metrics to Monitor

- **Page Load Time**: Should stay < 3 seconds
  - FILL: Alert threshold? (> 5 seconds?)
  
- **API Response Time**: Should stay < 500ms per endpoint
  - FILL: Alert threshold?
  
- **Error Rate**: Should stay < 0.5%
  - FILL: Alert threshold?
  
- **Polling Requests**: Should be 30s intervals
  - FILL: Alert if skipping polls?

### Monitoring Tools (FILL: configure)

- FILL: Application Performance Monitoring (APM): e.g. New Relic, DataDog
- FILL: Error tracking: e.g. Sentry
- FILL: Log aggregation: e.g. CloudFlare Logs, AWS CloudWatch
- FILL: Uptime monitoring: e.g. UptimeRobot

### Alerting (FILL: set up)

- Alert if page load time > 5 seconds
- Alert if any API endpoint > 1 second
- Alert if error rate > 1%
- Alert if site returns 5xx
- Alert if polling stops for > 5 minutes
- FILL: Add other alerts?

---

## Deployment Runbook Template (Fill-In)

```
DEPLOYMENT LOG
==============

Date: ____________________
Environment: Staging / Production
Commit Hash: ____________________
Deployed By: ____________________

Pre-deployment:
- Build: PASS / FAIL
- Tests: PASS / FAIL
- QA Sign-Off: YES / NO

Deployment Steps:
1. Build: [timestamp] ✓
2. Verify artifacts: [timestamp] ✓
3. Deploy: [timestamp] ✓
4. Smoke test: [timestamp] ✓
5. Automated tests: [timestamp] ✓

Post-deployment Monitoring:
- t+5 min: No errors
- t+10 min: Performance normal
- t+30 min: Stable, all metrics green

Sign-Off: ____________________
Date: ____________________
```

---

## Troubleshooting

### Build Fails

```
FILL: Common build errors and fixes
- Error: "Module not found"
  Solution: npm install, check import paths
- Error: "TypeScript compilation error"
  Solution: npx tsc --noEmit, fix type errors
```

---

### Deployment Fails

```
FILL: Common deployment errors and fixes
- Error: "Authentication failed"
  Solution: Check credentials, regenerate tokens
- Error: "Storage quota exceeded"
  Solution: Delete old files, upgrade storage
```

---

### Site Slow After Deploy

```
FILL: Debug steps
1. Check if API endpoints are responding
2. Check if polling is working (Network tab)
3. Check memory usage in DevTools
4. Check for large bundles (bundle analyzer)
5. Check CDN caching (headers)
```

---

### 5xx Errors After Deploy

```
FILL: Debug steps
1. Check server/function logs
2. Check database connectivity
3. Check API endpoint responses
4. Check for secrets/env vars missing
5. Rollback if no quick fix
```

---

**[MARCUZ:Khun-Ram]** — Deployment runbook skeleton prepared.
*DevOps: Fill in deployment procedures, monitoring tools, and rollback steps.*
