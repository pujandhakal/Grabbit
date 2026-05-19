# Grabbit — Nepal Marketing & Launch Strategy

## Context

This plan exists because the user (a bachelor's-level software engineering student in Nepal, building Grabbit with co-founder Saurav Pant at Everest Engineering College) asked how to market and advertise the app in Nepal. A first answer was given in chat; this document deepens that thinking, corrects the assumed positioning, and lays out an executable strategy across budget tiers.

**Product reality (from `README.md` and `lib/features/*`):** Grabbit is a real-time platform where buyers post product requests and nearby physical shops respond if they have the item in stock. The buyer picks an offer and goes in person to purchase. GroupBuy discounts are a secondary feature, not the headline. There are two user types in code (`UserRole` entity) — buyers and shopkeepers — with separate flows (`shop_dashboard`, `shop_requests_screen`, `shop_chats_screen`).

**This is a two-sided local marketplace.** That dictates everything below. Both sides must be acquired; one side without the other produces an empty experience and immediate churn. No payment flow is needed at launch (purchase happens in person), which is a real cost and complexity advantage to lean on.

**Current product state (from `CLAUDE.md`):** Login is UI-only, only signup is wired to backend, no token persistence. Marketing planning should *not* trigger spend yet — pre-launch product work is the critical path.

---

## 1. Product readiness gates (do this *before* spending money)

Marketing a half-built two-sided product wastes money and burns goodwill. Do not run paid ads until these are true:

- [ ] Real login + session persistence
- [ ] Shop signup + verification flow (even manual approval via WhatsApp is fine)
- [ ] Push notifications working both sides (`request posted` → shop, `shop responded` → user) — this is the *core* UX loop
- [ ] One-tap call/WhatsApp from shop response screen (the actual conversion event)
- [ ] At least one screenshot-worthy success story to put on the Play Store listing
- [ ] Crash-free rate >99% on Android 10+ (use Firebase Crashlytics)
- [ ] Bilingual UI strings: English + Nepali (Devanagari). Existing screens in `lib/features/*/presentation/screens/` to be wrapped with `intl`/`flutter_localizations`.
- [ ] Play Store listing in both English and Nepali (Google supports `ne-NP` locale)
- [ ] Privacy policy + Terms page hosted somewhere free (GitHub Pages is fine for a student project)

iOS launch is **explicitly out of scope** for the first 12 months. Android share in Nepal is ~95%+, and the $99/yr Apple developer fee is not justifiable on a student budget.

---

## 2. Positioning

### Core message (rank-ordered)
1. **Speed.** "Find products in nearby shops in minutes, not hours."
2. **Locality.** Supports the chiyapasal, kirana, hardware, pharmacy, electronics shops you already walk past.
3. **No commitment.** No upfront payment, no delivery wait — see offers, choose, buy in person.
4. **GroupBuy** as a secondary "save more" angle — not the lead message.

### Taglines to A/B test
- English: *"Ask once. Nearby shops reply."* / *"Your neighborhood, on tap."*
- Nepali: *"मागिहाल, छिमेकले जवाफ दिन्छ।"* / *"तपाईँको छिमेकमै सबै सामान।"*

Avoid generic e-commerce phrasing ("shop online, best prices"). Grabbit is **anti-e-commerce** — it sends people *into* physical shops. That contrast is the story.

### Personas to target first
| Persona | Why they convert | How to reach |
|---|---|---|
| College students (18–24, Kathmandu Valley) | Need specific things fast (cables, books, art supplies, medicine) on a tight budget | Campus reps, FB groups, TikTok |
| Young homemakers (25–40, valley) | Run errands constantly; tired of calling 5 shops | Instagram reels, FM radio (later), Pathao/InDrive partnership |
| Small shop owners (any age) | Want walk-in traffic without learning Daraz seller panel | Door-to-door, shop association meetings, WhatsApp groups, FM radio |

---

## 3. Launch sequence: supply first, then demand, geo-concentrated

### Why supply first
Without shops, the first buyer posts a request → no response → uninstalls. With even 20–30 active shops in one neighborhood, the user experience works on day one.

### Geographic concentration (critical)
Pick **one ward**, not a city. Recommended starting zone: **the area around Everest Engineering College** (Sanothimi/Bhaktapur) — you have natural network density, can do field visits on foot, and can recruit classmates as the first 200 users.

Phase expansion:
- **Phase 1 (months 1–3):** Sanothimi + immediate Bhaktapur core. 30–50 shops, 200–500 users.
- **Phase 2 (months 4–6):** Add Kathmandu pockets — Baneshwor, New Baneshwor, Koteshwor (close to the college, dense student population).
- **Phase 3 (months 7–12):** Lalitpur (Pulchowk/Jhamsikhel area). By month 12, aim for 200+ active shops and 5,000+ MAU across the valley.
- **Phase 4 (year 2):** Pokhara → Biratnagar → Butwal. Always one city at a time.

---

## 4. Channels by budget tier

The user is a student; budget will grow over time. Each tier is *additive* — Tier 1 keeps doing all of Tier 0.

### Tier 0 — NPR 0/month (start immediately)

**User side:**
- Personal network: every classmate, hostel mate, family member gets a direct ask. Target 100 installs in week 1 from your phone contacts alone.
- Facebook groups: post genuine "we built this" stories in *Kathmandu Students*, *Buy & Sell Kathmandu*, college-specific groups, Bhaktapur community groups. Once per group, no spam.
- r/Nepal on Reddit: a single well-written Show HN-style post. Mention the student-builder angle — it gets goodwill.
- TikTok Nepal: 15-second Nepali-language demo videos. The format that works: a real problem ("मैले तीनवटा पसल घुम्दा पनि भेटिनँ"), the app as solution, the result. Post 3×/week minimum.
- Instagram reels mirroring the same content.
- College class WhatsApp groups (yours and your co-founder's). Don't underestimate this — Nepali students forward useful apps aggressively.

**Shop side:**
- Walk into 50 shops near campus *in person*. Pitch in 60 seconds. Sign them up there on your phone. This is the highest-conversion channel you will ever have, and it costs nothing but shoe leather.
- Print B&W flyers at home/college printer (~NPR 2/sheet); leave at shop counters.
- "We're on Grabbit" window stickers — design free in Canva, print at a local press for NPR 30–50 each. Doubles as user acquisition (every passerby sees the brand).

**Both:**
- Pitch one tech YouTuber/podcaster for free coverage. Best targets: TechLekh, Tech Pana, Aakar Post, OST Nepal. Lead with the story, not the feature list.
- A simple landing page on GitHub Pages or Vercel with a Play Store badge.

**Tier 0 goal:** 200 users, 30 active shops, all in one neighborhood. No money spent.

### Tier 1 — NPR 5,000/month

Add to Tier 0:
- **Meta ads** (FB + Instagram), NPR 100–200/day. Geo-target: 5 km radius around your launch zone. Audience: 18–35. Run 4 creatives in parallel; kill anything with CPI > NPR 50.
- **Printed posters** (A3, color) for college canteens, library notice boards, mess halls — NPR 30/print, distribute free.
- **One micro-influencer post** — Nepali Instagram creators with 10–30K followers in the lifestyle/college niche charge NPR 1–3K per post.

**Tier 1 goal:** 1,000 users, 60 active shops, expansion into 1 adjacent area.

### Tier 2 — NPR 25,000/month

Add:
- **Tempo / micro-bus seat-back ads** — extremely cheap per impression in Kathmandu Valley. Vendor: contact through any local print shop.
- **College fest sponsorships** — NPR 5–15K per fest for a stall + stage mention. Best ROI: IT/CS-heavy festivals (KU Convention, Pulchowk IOE Fest, NCIT Tech Tatva).
- **Mid-tier influencer** (50–100K followers) — NPR 5–10K per reel.
- **Local FM spot** — Image FM, Hits FM, Radio Kantipur. NPR 5–15K per 30-sec spot, run during morning shopkeeper-listening hours (9–11 AM). Critical for **shop-side** acquisition.
- **Google Play Search Ads** for terms like "buy near me," "local shop Nepal," "find product Kathmandu."

**Tier 2 goal:** 5,000 users, 200 active shops, valley-wide pockets.

### Tier 3 — NPR 1,00,000+/month

Add:
- **Pathao or InDrive partnership** — co-marketed app integration for last-mile delivery option (if you build that feature).
- **National macro-influencer** (Sandeep Lamichhane, Sushant KC tier — NPR 50K–2L+ per post, only if feasibility model works).
- **Outdoor billboards in 1–2 strategic spots** (Maitighar Mandala area is the best per-eyeball outdoor in the country, but NPR 50K+/month).
- **Newspaper PR** (Kantipur, The Kathmandu Post tech sections) — usually free if the story is good; paid placement NPR 10–40K.
- **Television** — Himalaya TV, Kantipur TV business hour spots. Skip unless you've raised funding.

---

## 5. User-side specifics

### Hook moments (use-cases to advertise)
These are the *specific* situations to dramatize in creatives — they convert better than generic "find products fast":
- **Medicine** — "11 PM, बच्चालाई ज्वरो, औषधि चाहियो" → Grabbit
- **Spare parts** — bike chain, fan capacitor, charger cable
- **Stationery during exam season** — graph paper, drawing instruments
- **Specific clothing sizes / colors** unavailable in nearest shop
- **Pet food / pet supplies** (niche but very loyal)
- **Pooja samagri** during Dashain/Tihar — huge seasonal spike opportunity

### Referral mechanic
Build into the app:
- "Invite 3 friends → both get GroupBuy unlocked / a NPR 50 voucher at participating shops"
- Track via in-app referral code or Firebase Dynamic Links
- This is the single highest-ROI feature you can add for marketing. Build it before launching paid ads.

### Festival calendar (plan campaigns around these)
| Festival | Date (2026) | Marketing angle |
|---|---|---|
| Dashain | Sept 22 – Oct 6 | "Sabai samaan, sabai pasal" — clothing, gifts, pooja items |
| Tihar | Oct 18 – Oct 22 | Decorations, lights, sweets |
| New Year (Baisakh) | Apr 14 | "Naya barsha, naya bani" — start using Grabbit |
| Holi | Mar 4 | Colors, water guns — young user push |
| Back-to-school (Shrawan) | Mid-July | Stationery, uniforms — student parent push |

---

## 6. Shop-side specifics (the harder side)

Acquiring shops is 5–10× harder than acquiring users in Nepal. Most shopkeepers are 35+, less tech-fluent, and skeptical of "another app."

### Onboarding playbook
1. **Walk in. Don't email or call cold.**
2. Lead with a number: "तपाईंलाई हप्तामा 5 जना अरूले नचाहिएको ग्राहक पठाइदिन्छु, बिल्कुलै फ्री।" ("I'll send you 5 customers a week, free.")
3. Install the app on *their* phone, walk them through one fake request.
4. Stick a "We're on Grabbit" sticker on their window before you leave.
5. Follow up in 7 days in person, not via call.

### Shop incentives
- First 100 shops: free premium (unlimited responses) for 6 months.
- Top-responder of the week gets a free social media spotlight on Grabbit's accounts (this is what shopkeepers actually value — local reputation).
- Cash bonus: NPR 500 for every shop a shopkeeper refers that becomes active. Word-of-mouth among shop owners is the #1 acquisition channel.

### Shop associations to approach (free reach)
- New Road Vyapari Sangh
- Asan / Indra Chowk shop associations
- Bhaktapur Durbar Square area shops association
- Pharmacy associations (very organized, district-level)
- Mobile / electronics dealer associations

A 15-minute presentation at one association meeting can produce 20+ shop signups.

---

## 7. Content & creative direction

### Language ratios
- **Captions / ad copy:** 70% Nepali (Devanagari, *not* romanized), 30% English. Romanized Nepali ("kasto cha") is fine on TikTok captions but never for ad copy — feels unserious to older users.
- **App UI:** Bilingual toggle. Default to Nepali if device locale is `ne-NP`.
- **Voiceovers / influencer content:** Nepali only.

### Tone
- Direct, warm, slightly humorous. Avoid corporate startup vocabulary ("seamless," "frictionless," "ecosystem"). It plays poorly in Nepali markets.
- Show real Kathmandu — load-shedding, monsoon, dusty streets. Stock-photo aesthetics underperform.

### Format priorities
1. TikTok/Reels (15–30s vertical video) — highest reach per rupee
2. Static carousels on Instagram/FB — second
3. YouTube long-form (3–8 min) — for the founder story / explainer
4. Twitter (X) — almost exclusively for tech-community / press

---

## 8. Earned media / PR angles

Free press is the cheapest customer acquisition there is. Pitches in order of likelihood:

1. *"Two Everest Engineering students built an app to help Kathmandu's mom-and-pop shops compete with Daraz"* → Kantipur, The Kathmandu Post, Online Khabar, Setopati
2. *"Hyperlocal, no inventory required: a different model for Nepali e-commerce"* → ICT Frame, TechLekh, Himalayan Times Tech
3. *"Built in Nepal: Flutter + Node.js side project becomes a real product"* → developer Twitter/X, r/FlutterDev (international), local dev meetups (Kathmandu Flutter Meetup)

Approach: send a short, personal email + one screenshot + Play Store link. Do not send press releases. Nepali tech journalists respond to direct founder pitches.

---

## 9. Partnerships (cheap, high-leverage)

- **Everest Engineering College official channels** — your home institution. Get the official IG/FB to share the launch post.
- **Other engineering colleges' IT clubs** — KEC, NCIT, KU CSE, Pulchowk IOE. Offer a free workshop on "How we built Grabbit with Flutter" in exchange for a captive student audience.
- **Pathao / inDrive** — long shot, but a co-promotion ("Order on Grabbit, get a Pathao ride for NPR 50") could be pitched once you have 5K users.
- **eSewa / Khalti** — when you eventually add in-app payments, both will co-market with new merchants. Apply to their developer programs early.
- **Local cable TV (Bhaktapur, Lalitpur)** — surprisingly cheap (NPR 1–3K per spot) and reaches shopkeepers at home in the evening.

---

## 10. Measurement & success criteria

Track these from day one in Firebase Analytics + a simple spreadsheet:

### Health metrics (matter more than installs)
| Metric | Definition | Target by month 3 |
|---|---|---|
| **Match rate** | % of requests that get ≥1 shop response within 30 min | > 60% |
| **Activation** | % of installs that post their first request | > 25% |
| **Shop response rate** | % of requests an active shop responds to | > 40% |
| **Repeat rate** | % of users posting a 2nd request within 14 days | > 35% |
| **CPI (cost per install)** | Total paid spend / installs | < NPR 30 |
| **CPA shop** | Total cost / activated shop | < NPR 300 |

### Vanity metrics (track but don't optimize for)
- Total installs, social followers, app store rating

### Weekly review cadence
Every Sunday, review:
- Top 5 requests that got 0 responses → what category is the gap?
- Top 5 shops by response count → reach out to thank, ask for testimonials
- Highest-CPI ad creative → kill it

---

## 11. 90-day execution roadmap

### Days 1–14: Pre-launch product hardening
- Ship the readiness checklist from Section 1
- Build referral system with Firebase Dynamic Links
- Set up Firebase Analytics, Crashlytics, Performance
- Create Play Store listing (Eng + Nepali)
- Design 5 ad creatives, 3 TikTok scripts, 1 founder-story video

### Days 15–30: Soft launch in one neighborhood (Sanothimi / Bhaktapur)
- Walk in to 50 shops; onboard 30
- Recruit 100 users from personal network + college
- Run 1 r/Nepal post, 3 FB group posts, 1 college-wide WhatsApp blast
- Daily review of match rate; fix the supply gaps shop-by-shop

### Days 31–60: Tier 1 paid push
- NPR 5K/month Meta ads
- 2 micro-influencer posts
- 1 PR pitch sent to TechLekh / Tech Pana
- Add 1 adjacent neighborhood

### Days 61–90: Measure, iterate, plan Tier 2
- If match rate > 60% and repeat rate > 35% → graduate to Tier 2
- If not → fix the product/supply gap, do not increase spend
- Begin shop association outreach for valley-wide expansion

---

## 12. Risks and mitigations

| Risk | Likelihood | Mitigation |
|---|---|---|
| Shops sign up but don't respond → users churn | High | Premium-free incentive for first 100; daily push notification reminder; manual nudge via WhatsApp for top shops |
| Users post spam / fake requests → shops churn | Medium | Phone verification at signup; rate-limit requests to 5/day for new users |
| Bigger player (Daraz, Pathao) copies the model | Medium | Move fast on local depth; relationships with shop associations are the moat, not the code |
| Founder burnout (you + Saurav are students, also have coursework) | High | Don't do everything yourself; recruit 2–3 unpaid campus ambassadors per college as the team grows |
| Monsoon / Dashain disruption to field ops | Seasonal | Front-load shop onboarding May–August; lean on online channels during heavy monsoon |
| Hardcoded MongoDB URI in `server/index.js` leaks | High (security) | Move to environment variables before any public launch. This is a real risk flagged in `CLAUDE.md`. |

---

## 13. Reference files in this repo

These exist already and inform the plan above:
- `README.md` — canonical product description (real-time local shop discovery, GroupBuy as secondary feature, freemium for users, subscription for shops)
- `CLAUDE.md` — architecture rules, current state (login UI-only, signup wired, no token persistence)
- `lib/features/auth/domain/entities/user_role.dart` — confirms two-sided user model in code
- `lib/features/shop_dashboard/presentation/screens/shop_dashboard_screen.dart` — shop-side UI exists
- `lib/features/requests/presentation/screens/post_request_screen.dart` — the user-side core flow
- `lib/features/marketplace/presentation/screens/store_details_screen.dart` — shop detail page (use these screenshots for Play Store)

No code changes are recommended by this plan. The product readiness gates in Section 1 are *separate* development work that should be planned as their own tasks.

---

## 14. Verification — how to know this plan is working

This isn't a code change, so "verification" means launch metrics:

1. **Week 2 check:** ≥30 shops onboarded in launch neighborhood, walk in to verify the stickers are still in their windows.
2. **Week 4 check:** Match rate > 50% on real (non-test) requests. If not, do not start paid ads — keep adding shops.
3. **Week 8 check:** Repeat rate > 30%, organic install share > 40%. If organic is low, your product story isn't resonating — go back to creative.
4. **Week 12 check:** Total CAC blended < NPR 50, shop CAC < NPR 300. If higher, do not scale to Tier 2 spend.
5. **Qualitative:** Walk into 10 random shops in your launch zone and ask "Have you heard of Grabbit?" If <5 say yes by week 12, ground-game has failed and the plan needs revision.

---

## Open questions to resolve before executing

1. What is the realistic monthly marketing budget for the next 6 months — Tier 0, 1, 2, or 3?
2. Is the co-founder (Saurav) full-time on this or supporting? Affects how much field-ops capacity exists.
3. Target launch date — does the team want to launch *before* the next Dashain (Sept 2026) to ride the festival traffic? If so, the product readiness gates need to close by August.
4. Is there any external funding (family, grants, NIC Asia / NIDC startup programs)? Affects whether to chase Tier 2/3 spend in year 1.
