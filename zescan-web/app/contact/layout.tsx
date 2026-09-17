import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: "Contact Us",
  description: "Get in touch with ZeScan. Send feedback, report bugs, or request features. We value your input to make ZeScan better.",
  keywords: "contact ZeScan, feedback, bug report, feature request, customer support, help",
  openGraph: {
    title: "Contact Us - ZeScan",
    description: "Get in touch with ZeScan. Send feedback, report bugs, or request features.",
    url: "https://zescan.zeppelinlabs.digital/contact",
  },
};

export default function ContactLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <>{children}</>;
}
