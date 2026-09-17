# Kiro Skills for Protocol Technologies

This directory contains custom Kiro skills for the Protocol Technologies website.

## Available Skills

### nextjs-seo.md
Comprehensive Next.js SEO analysis and optimization skill adapted from the excellent [claude-seo](https://github.com/AgriciDaniel/claude-seo) project.

**Triggers**: SEO, search engine optimization, meta tags, sitemap, schema markup, structured data, Core Web Vitals, page speed, Open Graph, robots.txt

**Key Features**:
- ✅ Full site SEO audits
- ✅ Metadata optimization (Next.js 16 Metadata API)
- ✅ Structured data (JSON-LD Schema.org)
- ✅ Sitemap and robots.txt generation
- ✅ Core Web Vitals analysis
- ✅ Open Graph and Twitter Cards
- ✅ AI Search optimization (GEO)
- ✅ E-E-A-T content quality
- ✅ Performance optimization guidance

**Usage Examples**:
```
Run a full SEO audit on the Protocol Technologies website

Generate sitemap.ts and robots.ts files for Next.js

Add Organization JSON-LD schema to the root layout

Check Core Web Vitals performance

Validate all structured data on the site
```

## How to Use Skills

Skills are automatically activated by Kiro when relevant keywords are detected in your messages. You can also explicitly invoke them by asking questions or giving commands related to the skill's domain.

## Methodology

The SEO skill follows a 10-principle framework:

### PERCEIVE
- Observe external signals (live site, SERP)
- Observe internal signals (code, implementation)
- Listen to user/search behavior

### ANALYZE
- Think in first principles
- Connect lateral relationships
- Connect system dependencies

### VALIDATE
- Feel for UX/brand alignment
- Accept falsifiability

### ACT
- Create the solution
- Grow with monitoring

## Adding New Skills

To add a new skill:
1. Create a new `.md` file in this directory
2. Add proper frontmatter with name, description, and triggers
3. Document the skill's capabilities and usage
4. Restart Kiro or reload skills

## Credits

**nextjs-seo skill**: Adapted from [claude-seo](https://github.com/AgriciDaniel/claude-seo) by [agricidaniel](https://github.com/AgriciDaniel)
- Original License: MIT
- Community: [AI Marketing Hub Pro](https://www.skool.com/ai-marketing-hub-pro)

## Resources

- Kiro Skills Documentation: Check Kiro docs for skills guide
- Next.js Documentation: https://nextjs.org/docs
- Google Search Central: https://developers.google.com/search
- Schema.org: https://schema.org
- Web.dev: https://web.dev
