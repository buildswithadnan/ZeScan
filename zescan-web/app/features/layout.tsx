import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: "Features",
  description: "Explore ZeScan's powerful features: privacy-first scanning, PDF toolkit (merge, compress, split), no watermarks, smart organization, and offline functionality. Free forever.",
  keywords: "document scanner features, PDF tools, privacy scanning, offline scanner, no watermark, PDF merge, PDF compress, PDF split",
  openGraph: {
    title: "Features - ZeScan Document Scanner",
    description: "Explore ZeScan's powerful features: privacy-first scanning, PDF toolkit, no watermarks, and smart organization. Free forever.",
    url: "https://zescan.zeppelinlabs.digital/features",
  },
};

export default function FeaturesLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
