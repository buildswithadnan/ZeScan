---
name: nextjs-seo
description: "Comprehensive Next.js SEO analysis and optimization for Protocol Technologies website. Covers metadata, sitemaps, robots.txt, structured data (JSON-LD Schema.org), Core Web Vitals, Open Graph, performance optimization, and AI search readiness (GEO). Adapted from claude-seo methodology."
triggers:
  - "SEO"
  - "search engine optimization"
  - "meta tags"
  - "sitemap"
  - "schema markup"
  - "structured data"
  - "Core Web Vitals"
  - "page speed"
  - "Open Graph"
  - "social sharing"
  - "robots.txt"
---

# Next.js SEO Optimization Skill

## Purpose
Comprehensive SEO analysis and optimization specifically for Next.js 16 applications with a focus on the Protocol Technologies agency website. This skill provides audit capabilities, automated fixes, and best practices aligned with Google's 2026 SEO guidelines.

## Core Competencies

### 1. Metadata Optimization
- **Next.js Metadata API**: Proper use of `metadata` export in layouts and pages
- **Dynamic Metadata**: `generateMetadata` for dynamic routes
- **Title Templates**: Consistent title patterns across the site
- **Meta Tags**: Description, keywords, author, viewport
- **Canonical URLs**: Prevent duplicate content issues
- **Open Graph**: Social media sharing optimization
- **Twitter Cards**: Twitter-specific metadata
- **Favicon & Icons**: All required formats and sizes

### 2. Structured Data (JSON-LD)
- **Organization Schema**: Company information, logo, social profiles
- **WebSite Schema**: Site search, navigation
- **BreadcrumbList**: Page hierarchy for better navigation
- **Service Schema**: For each service offering
- **Project/CreativeWork**: Portfolio items
- **Article Schema**: For blog posts and case studies
- **LocalBusiness**: If applicable for local SEO
- **FAQ Schema**: Q&A sections (note: Google removed FAQ rich results May 2026)
- **AggregateRating**: Reviews and ratings if applicable

### 3. Technical SEO
- **Sitemap Generation**: XML sitemaps with proper URLs
- **Robots.txt**: Crawl directives and sitemap location
- **Canonical Tags**: Duplicate content prevention
- **Hreflang Tags**: For international versions (if applicable)
- **URL Structure**: Clean, descriptive URLs
- **301 Redirects**: Proper redirect handling
- **404 Handling**: Custom 404 pages
- **Image Optimization**: Alt text, lazy loading, modern formats (AVIF/WebP)
- **Internal Linking**: Strategic link structure

### 4. Performance & Core Web Vitals
- **LCP (Largest Contentful Paint)**: Target < 2.5s
- **INP (Interaction to Next Paint)**: Target < 200ms (replaced FID)
- **CLS (Cumulative Layout Shift)**: Target < 0.1
- **TTFB (Time to First Byte)**: Server response time
- **Resource Optimization**: Code splitting, lazy loading
- **Image Optimization**: Next.js Image component usage
- **Font Optimization**: next/font implementation

### 5. Content Quality (E-E-A-T)
- **Experience**: First-hand project evidence, case studies
- **Expertise**: Technical depth, industry knowledge
- **Authoritativeness**: Credentials, portfolio quality
- **Trustworthiness**: Contact info, HTTPS, transparency

### 6. AI Search Optimization (GEO)
- **Citability**: 134-167 word answer blocks
- **Question-based Headers**: H2/H3 as questions
- **Attribution Density**: Proper source citations
- **Entity Coverage**: Company/service entity recognition
- **Note**: llms.txt is NOT currently a ranking factor (evidence-based)

## Commands & Usage

### Audit Commands

#### Full Site SEO Audit
```
Analyze the entire website SEO setup including metadata, structured data, technical SEO, and performance.
```

**What it checks:**
- All metadata across pages
- JSON-LD structured data
- Sitemap and robots.txt
- Core Web Vitals
- Image optimization
- Internal link structure
- Mobile responsiveness
- HTTPS implementation

#### Page-Specific Analysis
```
Analyze SEO for a specific page: [page-url or route]
```

#### Metadata Audit
```
Check all metadata tags across the website
```

#### Structured Data Validation
```
Validate Schema.org JSON-LD markup
```

#### Core Web Vitals Check
```
Analyze Core Web Vitals performance
```

### Fix Commands

#### Generate Missing Metadata
```
Generate metadata for [page-route]
```

#### Add Structured Data
```
Add [schema-type] structured data to [page-route]
```

**Available Schema Types:**
- Organization
- WebSite
- Service
- Project/CreativeWork
- BreadcrumbList
- Article
- LocalBusiness
- AggregateRating

#### Generate Sitemap
```
Generate XML sitemap for the website
```

#### Generate Robots.txt
```
Generate robots.txt file
```

## Next.js 16 Implementation Patterns

### Metadata Configuration

**Static Metadata (app/layout.tsx or app/page.tsx):**
```typescript
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: {
    default: 'Protocol Technologies | Enterprise Software Engineering',
    template: '%s | Protocol Technologies',
  },
  description: 'Elite enterprise software architecture and digital infrastructure agency',
  keywords: ['enterprise software', 'digital infrastructure', 'native mobile'],
  authors: [{ name: 'Protocol Technologies' }],
  openGraph: {
    title: 'Protocol Technologies',
    description: 'Enterprise Software Engineering & Digital Infrastructure',
    url: 'https://protocoltechnologies.agency',
    siteName: 'Protocol Technologies',
    images: [
      {
        url: 'https://protocoltechnologies.agency/og-image.jpg',
        width: 1200,
        height: 630,
        alt: 'Protocol Technologies',
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'Protocol Technologies',
    description: 'Enterprise Software Engineering & Digital Infrastructure',
    images: ['https://protocoltechnologies.agency/twitter-image.jpg'],
  },
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      'max-video-preview': -1,
      'max-image-preview': 'large',
      'max-snippet': -1,
    },
  },
  icons: {
    icon: '/favicon.ico',
    shortcut: '/favicon-16x16.png',
    apple: '/apple-touch-icon.png',
  },
  manifest: '/site.webmanifest',
}
```

**Dynamic Metadata (for dynamic routes):**
```typescript
export async function generateMetadata({ params }: Props): Promise<Metadata> {
  const service = await getService(params.slug)
  
  return {
    title: service.title,
    description: service.description,
    openGraph: {
      title: service.title,
      description: service.description,
      images: [service.image],
    },
  }
}
```

### Structured Data Implementation

**Create a reusable component (components/JsonLd.tsx):**
```typescript
export function JsonLd({ data }: { data: any }) {
  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(data) }}
    />
  )
}
```

**Organization Schema Example:**
```typescript
const organizationSchema = {
  '@context': 'https://schema.org',
  '@type': 'Organization',
  name: 'Protocol Technologies',
  description: 'Enterprise software engineering and digital infrastructure agency',
  url: 'https://protocoltechnologies.agency',
  logo: {
    '@type': 'ImageObject',
    url: 'https://protocoltechnologies.agency/logo.png',
    width: 512,
    height: 512,
  },
  contactPoint: {
    '@type': 'ContactPoint',
    email: 'contact@protocoltechnologies.agency',
    contactType: 'Customer Service',
  },
  sameAs: [
    'https://linkedin.com/company/protocoltechnologies',
    'https://github.com/protocoltechnologies',
  ],
  foundingDate: '2024',
  areaServed: 'Worldwide',
  knowsAbout: [
    'Mobile Application Development',
    'Web Development',
    'AI & Machine Learning',
    'Cloud Infrastructure',
    'Digital Marketing',
  ],
}
```

### Sitemap Generation (app/sitemap.ts)

```typescript
import { MetadataRoute } from 'next'

export default function sitemap(): MetadataRoute.Sitemap {
  const baseUrl = 'https://protocoltechnologies.agency'
  
  return [
    {
      url: baseUrl,
      lastModified: new Date(),
      changeFrequency: 'monthly',
      priority: 1,
    },
    {
      url: `${baseUrl}/services`,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 0.8,
    },
    {
      url: `${baseUrl}/projects`,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 0.8,
    },
    {
      url: `${baseUrl}/about`,
      lastModified: new Date(),
      changeFrequency: 'monthly',
      priority: 0.7,
    },
    {
      url: `${baseUrl}/contact`,
      lastModified: new Date(),
      changeFrequency: 'monthly',
      priority: 0.7,
    },
    // Add dynamic service pages
    ...SERVICES.map((service) => ({
      url: `${baseUrl}/services/${service.slug}`,
      lastModified: new Date(),
      changeFrequency: 'monthly' as const,
      priority: 0.6,
    })),
  ]
}
```

### Robots.txt (app/robots.ts)

```typescript
import { MetadataRoute } from 'next'

export default function robots(): MetadataRoute.Robots {
  return {
    rules: {
      userAgent: '*',
      allow: '/',
      disallow: ['/api/', '/admin/', '/_next/'],
    },
    sitemap: 'https://protocoltechnologies.agency/sitemap.xml',
  }
}
```

## Current Website Analysis

Based on the Protocol Technologies codebase:

### ✅ Already Implemented
- Next.js 16 with proper configuration
- Font optimization using next/font
- Image optimization infrastructure
- Build optimization (Turbopack, code splitting)
- Performance optimizations (animations, lazy loading)
- Basic metadata in layout.tsx

### ⚠️ Missing or Needs Improvement
1. **Structured Data (JSON-LD)**: No Schema.org markup detected
2. **Sitemap**: No app/sitemap.ts file
3. **Robots.txt**: No app/robots.ts file
4. **Dynamic Metadata**: Services pages need generateMetadata
5. **Open Graph Images**: Need dedicated OG images
6. **Breadcrumbs**: No breadcrumb navigation
7. **Service Schemas**: Individual service pages need Service schema
8. **Project Schemas**: Projects need CreativeWork schema

## SEO Priority Checklist

### Critical (Do First)
- [ ] Create app/sitemap.ts with all routes
- [ ] Create app/robots.ts
- [ ] Add Organization JSON-LD schema to root layout
- [ ] Add WebSite schema with site search
- [ ] Generate Open Graph images (1200x630)
- [ ] Add meta descriptions to all pages
- [ ] Verify all images have alt text

### High Priority
- [ ] Add Service schema to each service page
- [ ] Add CreativeWork schema to project pages
- [ ] Implement BreadcrumbList schema
- [ ] Add generateMetadata to dynamic routes
- [ ] Create JSON-LD utility component
- [ ] Optimize all remaining images

### Medium Priority
- [ ] Add FAQ schema (if applicable, note no rich results)
- [ ] Implement article schema for blog/case studies
- [ ] Add AggregateRating if reviews exist
- [ ] Create Twitter Card images
- [ ] Add structured data testing

### Low Priority
- [ ] Hreflang tags (only if multi-language)
- [ ] LocalBusiness schema (if local presence)
- [ ] Video schema (if video content)

## Methodology (10-Principle Framework)

Based on claude-seo's proven methodology:

### PERCEIVE Phase
1. **OBSERVE (External)**: Check live site, SERP appearance, competitor signals
2. **OBSERVE (Internal)**: Audit existing implementation, check console
3. **LISTEN**: Review user behavior, search console data

### ANALYZE Phase
4. **THINK**: Reduce to first principles - what actually impacts rankings?
5. **CONNECT (Lateral)**: Find non-obvious relationships (performance → UX → engagement → rankings)
6. **CONNECT (System)**: Sequence dependencies (crawlability before indexability before ranking)

### VALIDATE Phase
7. **FEEL**: Pressure-test against UX and brand voice
8. **ACCEPT**: Define falsifiability - "how would we know this failed?"

### ACT Phase
9. **CREATE**: Implement the fix
10. **GROW**: Set monitoring/feedback loop

## Quality Gates

- **Thin Content**: Warn at <300 words for main pages
- **Image Alt Text**: 100% coverage required
- **Meta Descriptions**: 100% coverage, 150-160 chars optimal
- **Title Tags**: 60 char max, unique per page
- **H1 Tags**: One per page, includes primary keyword
- **Internal Links**: Minimum 3 contextual links per page
- **Mobile Responsive**: 100% mobile-friendly
- **HTTPS**: 100% secure connections
- **Core Web Vitals**: Green scores on all metrics

## Core Web Vitals Targets (2026)

- **LCP**: < 2.5 seconds (good), 2.5-4.0s (needs improvement), > 4.0s (poor)
- **INP**: < 200ms (good), 200-500ms (needs improvement), > 500ms (poor)  
- **CLS**: < 0.1 (good), 0.1-0.25 (needs improvement), > 0.25 (poor)

**Note**: INP replaced FID in March 2024. Never reference FID.

## AI Search Optimization (GEO)

Per Google's AI Optimization Guide (May 2026):
- AI Overviews = rebranded SEO, same ranking systems
- Pages must be indexed to appear in AI features
- Passage citability: 134-167 word self-contained blocks
- Question-based headers improve citability
- **Myth busted**: llms.txt is NOT a ranking factor (no evidence)
- **Myth busted**: Content chunking is NOT required
- **Myth busted**: AI-specific keyword rewriting unnecessary

## Resources

- Next.js Metadata API: https://nextjs.org/docs/app/building-your-application/optimizing/metadata
- Google Search Central: https://developers.google.com/search
- Schema.org: https://schema.org
- Core Web Vitals: https://web.dev/vitals
- Rich Results Test: https://search.google.com/test/rich-results
- Google AI Optimization Guide: https://developers.google.com/search/docs/fundamentals/ai-optimization-guide

## Example Prompts

- "Run a full SEO audit on the Protocol Technologies website"
- "Generate sitemap.ts and robots.ts files"
- "Add Organization schema to the root layout"
- "Create Service schema for all service pages"
- "Audit Core Web Vitals and suggest improvements"
- "Generate Open Graph images configuration"
- "Validate all structured data on the site"
- "Check meta descriptions across all pages"

## Notes

This skill is adapted from the excellent [claude-seo](https://github.com/AgriciDaniel/claude-seo) project by agricidaniel, specifically tailored for Next.js 16 and the Protocol Technologies website architecture.

**License**: MIT (adapted from claude-seo)
**Author**: Adapted for Kiro from claude-seo by agricidaniel
**Version**: 1.0.0
**Last Updated**: 2026-09-17
