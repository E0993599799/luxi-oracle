# Degito Bangkok Client Portfolio — UI/UX Teardown, Batch D

**Brands:** Sansiri Sustainability, Foremost, Max Me
**Method:** WebSearch to resolve each brand's real live URL (Degito's own case-study pages don't link out to the delivered site — confirmed by inspecting the `__NEXT_DATA__` JSON on `degitobangkok.com/work/true`, which contains only CDN asset URLs, no client-site field), then curl+grep for ground-truth tokens + one WebFetch content pass per resolved site.

---

## Sansiri Sustainability

**Resolved URL:** `https://www.sansiri.com/en/sustainability/`

Sansiri is the Thai property developer; "Sustainability" is a dedicated section of their main corporate site, not a standalone microsite.

**Tokens found (raw HTML grep):**

| Token | Value |
|---|---|
| Hex colors | `#D7D7D7` (×4), `#F2F8FD` (×2), `#9c9c9c` (×2), `#ffffff`, `#c7c8c9` — a muted, low-saturation gray/blue-white palette in the markup itself (page likely relies on background images/photography for color, not flat fills) |
| Font | `GraphikTH-regular` (a licensed geometric sans customized for Thai — "TH" suffix) |
| CSS architecture | Multiple hand-rolled stylesheets served from `resource.sansiri.com/sansiri-com-frontend/...` (`normalize.css`, `ssinter_style.css`, `template-ssinter-header/footer.css`, `sustainability.css`) — a legacy server-rendered/jQuery-era build, not a modern JS framework |
| Animation/carousel libs | **AOS** (`custom-aos/aos.css` — Animate On Scroll) and **Slick** (`slick.css`/`slick-theme.css`) — classic scroll-reveal + carousel combo, no React/Vue/Next signals found |
| Images | 17 `.webp`, 9 `.jpg`, 4 `.png`, 4 `.svg` — partial WebP adoption, still mixing in JPG (older asset pipeline than Degito's own near-100% WebP homepage) |
| JSON-LD | None found |

**IA & positioning (WebFetch):** Narrative arc: hero brand-vision statement ("For over 40 years, Sansiri's vision has been to provide everyone with a good quality of life") → three equal-weight pillar cards (Environment / Social / Governance) → UN SDG alignment → news feed → newsletter/contact. No quantitative metrics (no carbon %, no investment figures) at the overview level — leans on aspirational photography and heritage/values language rather than data visualization. Dual navigation (main corporate menu + a vertical sustainability submenu) gives the section equal footing with core business units. Footer signals a dedicated "Sustainability Development Department" — real organizational infrastructure, not just a marketing page. Audience reads as ESG-conscious investors + mass-market homebuyers simultaneously (Investor Relations menu item sits next to the sustainability content).

---

## Foremost (Thailand)

**Resolved URL:** `https://www.foremostthailand.com/en/`

Foremost is FrieslandCampina's dairy brand in Thailand (condensed/evaporated/UHT milk, ~65 years in market).

**Tokens found (raw HTML grep):**

| Token | Value |
|---|---|
| Hex colors | `#e1624b`(×5)/`#D64224`(×3) warm orange-red as the dominant brand accent, plus `#ff690e`, `#ff6900`, `#ff3d3d`, `#fcb900` — a warm, energetic multi-orange/yellow accent cluster typical of FMCG/food branding; neutrals `#919192`, `#f1f1f1`, `#ebeef0`, `#e2e2e2` |
| Fonts | `'DB HeaventRounded Med'` / `'DB-Heavent-Rounded'` (a soft, rounded Thai display font — friendly/approachable, the opposite of Degito's own sharp-cornered look) + `'PSLxOmyim Bold'` / `psl114_omyim_proregular` |
| Stack | **WordPress + Elementor**, confirmed by literal `WordPress`/`wp-content` strings and Elementor's signature `var(--e-global-typography-*-font-family)` CSS custom-property pattern |
| Images | 44 `.png`, 18 `.jpg`, 10 `.webp`, 1 `.svg` — PNG-heavy, WebP a minority; the least performance-optimized image pipeline of any site sampled across this whole research pass (Degito's own site: 419 webp vs. 4 non-webp) |
| JSON-LD | `Article`, `BreadcrumbList`, `EntryPoint`, `ImageObject`, `ListItem`, `Organization`, `Person`, `PropertyValueSpecification`, `ReadAction`, `SearchAction`, `WebPage`, `WebSite` — a full, plugin-generated (Yoast-style) SEO schema set, much richer than either Degito's own site or Sansiri's |

**IA & positioning (WebFetch):** Standard e-commerce/content-hub layout — nav (Products, Promotions, Online Store, News/Events, Child Development content), account login, EN/TH toggle. Hero and promo cards lean on child-nutrition education copy ("Your child can grow taller in just 90 days," expert partnerships, membership points) rather than product-gallery merchandising. Footer mirrors full site nav plus subsidiary brand links (Falcon, Debic) and parent-company (FrieslandCampina) association. Audience: parents buying premium child-nutrition dairy, positioned as a science-backed health brand rather than a commodity milk seller.

---

## Max Me — UNRESOLVED (no live website; mobile-app-only product)

**Search finding:** "Max Me" is a lifestyle super-app from **PTG Energy** (the fuel-station/retail conglomerate), tied to their "Max Card" loyalty program (18–24M+ members). It offers payments, bill pay, fuel delivery, loans, insurance, and partner-store ordering. It exists **only as a native app**:
- iOS: `apps.apple.com/th/app/max-me/id1619914039`
- Android: `play.google.com/store/apps/details?id=com.pt.prd.maxme`

**Domain trap found and avoided:** `maxme.co.th` resolves, but its content (`<title>Maxme.</title>`, `og:description: "Maxme ordering is coming soon..."`, an `og:image` hosted on a Discord CDN) is unmistakably an unrelated small/abandoned project squatting a similar name — **not** PTG's product. Marked unresolved rather than reporting on the wrong site.

**Implication for the method:** a curl/grep + WebFetch website teardown cannot reach this deliverable at all — the actual UI/UX artifact lives inside an app-store-distributed binary. Auditing it would require a phone/emulator and store-listing screenshots, which is out of scope for this pass. Recorded here as a known gap rather than silently dropped.

---

## Cross-brand note (Batch D only)

Foremost (WordPress/Elementor, PNG-heavy, rounded friendly Thai type) and Sansiri (legacy jQuery/AOS/Slick stack, muted grayscale-in-markup palette) both sit on noticeably older/heavier front-end stacks than Degito's own Next.js + near-total-WebP homepage — worth noting if either brand is ever discussed as a delivered-by-Degito reference: the agency's own site outperforms these two client builds on the exact image-optimization metric it should be selling as a service line item.
