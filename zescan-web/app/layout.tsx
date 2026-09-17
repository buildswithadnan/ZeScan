import type { Metadata, Viewport } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import { Analytics } from "@vercel/analytics/next";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL('https://zescan.zeppelinlabs.digital'),
  title: {
    default: "ZeScan - Privacy-First Document Scanner & PDF Toolkit",
    template: "%s | ZeScan"
  },
  description: "Professional document scanner with powerful PDF tools. Scan, merge, compress, and split PDFs without watermarks or accounts. Free, secure, and privacy-first.",
  keywords: [
    "document scanner",
    "PDF tools",
    "merge PDF",
    "compress PDF",
    "split PDF",
    "no watermark scanner",
    "privacy document scanner",
    "free PDF tools",
    "offline document scanner",
    "Android scanner app",
    "PDF toolkit",
    "document organizer",
    "scan to PDF",
    "mobile scanner",
    "secure document scanner"
  ],
  authors: [{ name: "Zeppelin Labs", url: "https://zeppelinlabs.digital" }],
  creator: "Zeppelin Labs",
  publisher: "Zeppelin Labs",
  applicationName: "ZeScan",
  referrer: 'origin-when-cross-origin',
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
  alternates: {
    canonical: '/',
  },
  openGraph: {
    type: "website",
    locale: "en_US",
    url: "https://zescan.zeppelinlabs.digital",
    siteName: "ZeScan",
    title: "ZeScan - Privacy-First Document Scanner & PDF Toolkit",
    description: "Professional document scanner with powerful PDF tools. Scan, merge, compress, and split PDFs without watermarks or accounts. Free, secure, and privacy-first.",
    images: [
      {
        url: "/opengraph-image.png",
        width: 1200,
        height: 630,
        alt: "ZeScan - Document Scanner App",
        type: "image/png",
      },
    ],
  },
  twitter: {
    card: "summary_large_image",
    title: "ZeScan - Privacy-First Document Scanner",
    description: "Professional document scanner with powerful PDF tools. Free, secure, and privacy-first.",
    images: ["/twitter-image.png"],
    creator: "@zeppelinlabs",
  },
  icons: {
    icon: [
      { url: "/icon.png", sizes: "any", type: "image/png" },
      { url: "/images/dark_mode_icon.png", sizes: "32x32", type: "image/png" },
      { url: "/images/dark_mode_icon.png", sizes: "16x16", type: "image/png" },
    ],
    apple: [
      { url: "/apple-icon.png", sizes: "180x180", type: "image/png" },
    ],
    shortcut: "/icon.png",
  },
  appleWebApp: {
    capable: true,
    title: "ZeScan",
    statusBarStyle: "black-translucent",
    startupImage: [
      {
        url: "/images/splash_icon.png",
        media: "(device-width: 428px) and (device-height: 926px)",
      },
    ],
  },
  formatDetection: {
    telephone: false,
  },
  verification: {
    google: 'google-site-verification-code', // Add your verification code
    // yandex: 'yandex-verification-code',
    // bing: 'msvalidate-verification-code',
  },
  category: 'technology',
};

export const viewport: Viewport = {
  themeColor: [
    { media: "(prefers-color-scheme: dark)", color: "#111827" },
    { media: "(prefers-color-scheme: light)", color: "#ffffff" },
  ],
  width: "device-width",
  initialScale: 1,
  maximumScale: 5,
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const structuredData = {
    "@context": "https://schema.org",
    "@type": "SoftwareApplication",
    "name": "ZeScan",
    "applicationCategory": "ProductivityApplication",
    "operatingSystem": "Android",
    "offers": {
      "@type": "Offer",
      "price": "0",
      "priceCurrency": "USD"
    },
    "aggregateRating": {
      "@type": "AggregateRating",
      "ratingValue": "4.5",
      "ratingCount": "1000"
    },
    "description": "Privacy-first document scanner with powerful PDF tools. Scan, merge, compress, and split PDFs without watermarks or accounts.",
    "featureList": [
      "Privacy-first document scanning",
      "PDF merge, compress, and split",
      "No watermarks",
      "No account required",
      "Offline functionality",
      "Dark mode support"
    ],
    "screenshot": "https://zescan.zeppelinlabs.digital/screenhots/scanner.webp",
    "author": {
      "@type": "Organization",
      "name": "Zeppelin Labs",
      "url": "https://zeppelinlabs.digital"
    },
    "downloadUrl": "https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
  };

  const organizationData = {
    "@context": "https://schema.org",
    "@type": "Organization",
    "name": "ZeScan",
    "url": "https://zescan.zeppelinlabs.digital",
    "logo": "https://zescan.zeppelinlabs.digital/images/dark_mode_icon.png",
    "description": "Professional document scanner and PDF toolkit",
    "contactPoint": {
      "@type": "ContactPoint",
      "contactType": "Customer Support",
      "email": "info.adnansultan@gmail.com"
    },
    "sameAs": [
      "https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
    ]
  };

  return (
    <html
      lang="en"
      data-scroll-behavior="smooth"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased`}
    >
      <head>
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(structuredData) }}
        />
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{ __html: JSON.stringify(organizationData) }}
        />
      </head>
      <body className="min-h-full flex flex-col">
        {children}
        <Analytics />
      </body>
    </html>
  );
}
