# Deployment Roadmap - Smart Divination Tarot

This document provides a comprehensive roadmap for deploying the Smart Divination tarot app to production.

## Overview

This roadmap covers the 5 critical tasks required for production launch.

- See also `ANDROID_LAUNCH_CHECKLIST.md` (Play Store readiness) and `CRITICAL_BLOCKERS_PLAN.md` for daily execution details.

1. [ ] **iOS Signing Configuration** - Complete Apple Developer setup
2. [ ] **Production Credentials** - Gather and configure all API keys and secrets
3. [ ] **GitHub Actions Secrets** - Configure CI/CD pipeline secrets
4. [ ] **Vercel Deployment** - Deploy backend to production
5. [ ] **QA Manual Testing** - Comprehensive quality assurance

## Task Breakdown

### Task 1: iOS Signing Configuration WARNING: BLOCKER

**Estimated Time**: 2-4 hours (first time), 1 hour (subsequent)

**Prerequisites**:
- Apple Developer Account ($99/year)
- macOS with Xcode installed
- App Bundle ID decided

**Documentation**: [`IOS_SIGNING_GUIDE.md`](./IOS_SIGNING_GUIDE.md)

**Steps**:
1. Create App ID at developer.apple.com
2. Generate Distribution Certificate
3. Create Provisioning Profile
4. Generate App Store Connect API Key
5. Configure Xcode project
6. Test local build
7. Export and base64 encode signing files

**Deliverables**:
- [ ] `distribution-certificate.p12` (base64 encoded)
- [ ] `profile.mobileprovision` (base64 encoded)
- [ ] App Store Connect API Key (base64 encoded)
- [ ] Key ID and Issuer ID documented

**Blockers**:
- Requires Apple Developer Program enrollment (paid)
- Requires macOS for certificate management

---

### Task 2: Production Credentials WARNING: BLOCKER

**Estimated Time**: 1-2 hours

**Prerequisites**:
- Supabase account
- DeepSeek account
- (Optional) Random.org account
- (Optional) Datadog account

**Documentation**: [`PRODUCTION_CREDENTIALS_CHECKLIST.md`](./PRODUCTION_CREDENTIALS_CHECKLIST.md)

**Steps**:
1. Create Supabase production project
2. Apply database migrations
3. Generate DeepSeek API key
4. (Optional) Get Random.org API key
5. (Optional) Configure Datadog
6. Fill `.env.production` file

**Deliverables**:
- [ ] `.env.production` with all credentials
- [ ] Supabase production database with schema applied
- [ ] DeepSeek API key with sufficient quota

**Blockers**:
- DeepSeek API costs (monitor usage)
- Supabase project initialization time (~2 minutes)

---

### Task 3: GitHub Actions Secrets WARNING: BLOCKER (for CI/CD)

**Estimated Time**: 30-60 minutes

**Prerequisites**:
- Task 1 completed (iOS signing files)
- Task 2 completed (production credentials)
- Android keystore already generated
- Repository admin access

**Documentation**: [`GITHUB_ACTIONS_SETUP.md`](./GITHUB_ACTIONS_SETUP.md)

**Steps**:
1. Base64 encode Android keystore
2. Base64 encode iOS signing files
3. Link Vercel project to get org/project IDs
4. Add 20+ secrets to GitHub repository

**Deliverables**:
- [ ] All Android secrets configured
- [ ] All iOS secrets configured
- [ ] All Vercel secrets configured
- [ ] All backend secrets configured

**Secrets Count**:
- Android: 6 secrets
- iOS: 6 secrets
- Vercel: 3 secrets
- Backend: 5 secrets
- Observability: 2 secrets (optional)

**Total**: 20-22 secrets

---

### Task 4: Vercel Deployment WARNING: BLOCKER

**Estimated Time**: 30-60 minutes (first time), 5 minutes (subsequent)

**Prerequisites**:
- Task 2 completed (production credentials ready)
- Vercel account created
- Vercel CLI installed

**Documentation**: [`VERCEL_DEPLOYMENT_GUIDE.md`](./VERCEL_DEPLOYMENT_GUIDE.md)

**Steps**:
1. Install and login to Vercel CLI
2. Link project to Vercel
3. Configure environment variables
4. Verify build settings
5. Deploy to production
6. Test deployed endpoints
7. (Optional) Configure custom domain
8. (Optional) Set up Git integration

**Deliverables**:
- [ ] Backend deployed to production URL
- [ ] All environment variables configured
- [ ] Health check endpoint returning 200
- [ ] API endpoints functional

**Expected URL**: `https://backend-gv4a2ueuy-dnitzs-projects.vercel.app`

**Verification Commands**:
```bash
# Health check
curl https://backend-gv4a2ueuy-dnitzs-projects.vercel.app/api/health

# Metrics
curl https://backend-gv4a2ueuy-dnitzs-projects.vercel.app/api/metrics

# Unauthenticated draw (should return 401)
curl -X POST https://backend-gv4a2ueuy-dnitzs-projects.vercel.app/api/draw/cards
```

---

### Task 5: QA Manual Testing

**Estimated Time**: 4-8 hours (thorough testing)

**Prerequisites**:
- Task 4 completed (backend deployed)
- Test user accounts created in Supabase
- Android APK built with production backend URL
- iOS IPA built (when ready)

**Documentation**: [`QA_MANUAL_CHECKLIST.md`](./QA_MANUAL_CHECKLIST.md)

**Testing Areas**:
1. **Backend API** (14 tests)
   - Health & metrics endpoints
   - Authentication flow
   - Tarot draw endpoints
   - AI interpretation
   - Session management
   - Feature flags

2. **Android App** (27 tests)
   - Installation & first launch
   - Authentication flows
   - Tarot draw flows
   - Session history
   - Offline behavior
   - Error handling
   - Performance & stability
   - UI/UX polish

3. **iOS App** (when ready)
   - Repeat Android tests on iOS

4. **Cross-Platform** (1 test)
   - Data sync between devices

5. **Security** (3 tests)
   - SQL injection prevention
   - XSS prevention
   - Authentication bypass

**Total Tests**: 45+ test cases

**Deliverables**:
- [ ] QA checklist completed
- [ ] All blockers identified and fixed
- [ ] Test report documented
- [ ] Sign-off for production release

---

## Execution Order

### Phase 1: Foundation (Can be done in parallel)

**1A. iOS Signing** (2-4 hours)
- Follow `IOS_SIGNING_GUIDE.md`
- Complete Apple Developer setup
- Generate and export signing files

**1B. Production Credentials** (1-2 hours)
- Follow `PRODUCTION_CREDENTIALS_CHECKLIST.md`
- Create Supabase production project
- Gather all API keys
- Fill `.env.production`

### Phase 2: Infrastructure (Sequential)

**2A. GitHub Actions Secrets** (30-60 minutes)
- Follow `GITHUB_ACTIONS_SETUP.md`
- Base64 encode signing files
- Add all secrets to GitHub

**2B. Vercel Deployment** (30-60 minutes)
- Follow `VERCEL_DEPLOYMENT_GUIDE.md`
- Deploy backend to production
- Verify endpoints

### Phase 3: Quality Assurance (Sequential)

**3. QA Manual Testing** (4-8 hours)
- Follow `QA_MANUAL_CHECKLIST.md`
- Test backend APIs
- Test Android app
- Test iOS app (when ready)
- Document findings

---

## Total Time Estimate

**Optimistic**: 8-12 hours (everything works first try)
**Realistic**: 12-20 hours (some troubleshooting needed)
**Pessimistic**: 20-30 hours (multiple issues to resolve)

**Recommended Schedule**:
- **Day 1**: Tasks 1 & 2 (Foundation)
- **Day 2**: Tasks 3 & 4 (Infrastructure)
- **Day 3**: Task 5 (QA Testing)

---

## Dependencies Graph

```
Task dependency overview:
- Task 1 (iOS Signing) must complete before Task 3 (GitHub Secrets) to unblock CI/CD.
- Task 2 (Credentials) feeds Task 4 (Vercel Deploy), which then unlocks Task 5 (QA Testing).
- Android signing is already complete and supports downstream deployment steps.
```

---

## Risk Assessment

### High Risk

**iOS Certificate Expiration**
- **Impact**: App cannot be built
- **Mitigation**: Set calendar reminder for 11 months from now
- **Recovery**: Regenerate certificate (1-2 hours)

**Supabase Production Database Issues**
- **Impact**: App cannot store/retrieve data
- **Mitigation**: Test migrations in staging first
- **Recovery**: Restore from backup or reapply migrations

**DeepSeek API Cost Overrun**
- **Impact**: Unexpected billing charges
- **Mitigation**: Set up billing alerts, monitor usage
- **Recovery**: Switch to alternative AI provider or disable feature

### Medium Risk

**Vercel Build Failures**
- **Impact**: Cannot deploy updates
- **Mitigation**: Test builds locally first
- **Recovery**: Debug via Vercel logs, rollback to previous deployment

**GitHub Secrets Misconfigured**
- **Impact**: CI/CD pipeline fails
- **Mitigation**: Use verification workflow
- **Recovery**: Update secrets, re-run workflow

### Low Risk

**Domain Propagation Delays**
- **Impact**: Custom domain not immediately accessible
- **Mitigation**: Use Vercel URL initially
- **Recovery**: Wait for DNS propagation (up to 24 hours)

---

## Success Criteria

### Minimum Viable Production (MVP)

- [ ] Backend deployed and healthy (200 on /api/health)
- [ ] Android APK signed and installable
- [ ] iOS IPA signed and installable
- [ ] User can sign up and sign in
- [ ] User can perform tarot draws
- [ ] AI interpretations generate successfully
- [ ] Session history persists correctly
- [ ] No critical bugs or crashes

### Ideal Launch State

- [ ] All MVP criteria met
- [ ] CI/CD pipeline fully automated
- [ ] Custom domain configured
- [ ] Monitoring and alerts set up
- [ ] All 45 QA tests passing
- [ ] Performance metrics within targets
- [ ] User documentation complete
- [ ] Privacy policy and terms published

---

## Next Steps After Deployment

1. **App Store Submissions**
   - Google Play Store submission (`docs/PLAY_STORE_SUBMISSION.md` - TODO)
   - Apple App Store submission (`docs/APP_STORE_SUBMISSION.md` - TODO)

2. **Monitoring Setup**
   - Configure Datadog dashboards
   - Set up uptime monitoring
   - Configure error tracking (Sentry)

3. **User Documentation**
   - Write user guide
   - Create FAQ
   - Set up support email

4. **Marketing Preparation**
   - Prepare app screenshots
   - Write store descriptions
   - Plan launch announcement

---

## Support & Troubleshooting

If you encounter issues during deployment:

1. **Check the specific guide** for that task (linked in each section)
2. **Review error logs**:
   - Vercel: Dashboard -> Functions -> Logs
   - GitHub Actions: Actions tab -> Workflow run
   - Supabase: Dashboard -> Logs
3. **Verify secrets are set correctly** (no typos, complete values)
4. **Test locally first** before deploying to production
5. **Consult documentation**:
   - Vercel: https://vercel.com/docs
   - Supabase: https://supabase.com/docs
   - Flutter: https://docs.flutter.dev

---

## Document Index

All deployment guides are located in `docs/`:

1. [`IOS_SIGNING_GUIDE.md`](./IOS_SIGNING_GUIDE.md) - Complete iOS signing setup
2. [`PRODUCTION_CREDENTIALS_CHECKLIST.md`](./PRODUCTION_CREDENTIALS_CHECKLIST.md) - Gather all API keys
3. [`GITHUB_ACTIONS_SETUP.md`](./GITHUB_ACTIONS_SETUP.md) - Configure CI/CD secrets
4. [`VERCEL_DEPLOYMENT_GUIDE.md`](./VERCEL_DEPLOYMENT_GUIDE.md) - Deploy backend to production
5. [`QA_MANUAL_CHECKLIST.md`](./QA_MANUAL_CHECKLIST.md) - Complete testing checklist
6. [`SECRETS.md`](./SECRETS.md) - Comprehensive secrets management
7. [`DEPLOYMENT_ROADMAP.md`](./DEPLOYMENT_ROADMAP.md) - This document

---

**Last Updated**: 2025-10-02
**Status**: Ready for execution
**Owner**: Development Team
