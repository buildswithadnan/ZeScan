import { MetadataRoute } from 'next';

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: 'ZeScan - Privacy-First Document Scanner',
    short_name: 'ZeScan',
    description: 'Professional document scanner with powerful PDF tools. Scan, merge, compress, and split PDFs without watermarks or accounts.',
    start_url: '/',
    display: 'standalone',
    background_color: '#111827',
    theme_color: '#3b82f6',
    icons: [
      {
        src: '/images/dark_mode_icon.png',
        sizes: 'any',
        type: 'image/png',
      },
    ],
  };
}
