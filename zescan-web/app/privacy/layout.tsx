import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: "Privacy Policy",
  description: "ZeScan Privacy Policy: Your documents stay on your device. No cloud uploads, no data collection, no tracking. Complete privacy and security guaranteed.",
  keywords: "privacy policy, data privacy, secure scanner, offline processing, no data collection, privacy-first app",
  openGraph: {
    title: "Privacy Policy - ZeScan",
    description: "Your documents stay on your device. No cloud uploads, no data collection, no tracking. Complete privacy guaranteed.",
    url: "https://zescan.zeppelinlabs.digital/privacy",
  },
};

export default function PrivacyLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
