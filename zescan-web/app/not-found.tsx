'use client';

import { motion } from 'framer-motion';
import { Home, Search, Download, ArrowRight, AlertCircle } from 'lucide-react';
import Image from 'next/image';
import Link from 'next/link';
import { useRouter } from 'next/navigation';

export default function NotFound() {
  const router = useRouter();

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-900 via-gray-900 to-black text-white flex flex-col">
      {/* Navigation */}
      <nav className="fixed top-0 w-full z-50 backdrop-blur-lg bg-gray-900/80 border-b border-gray-800">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link href="/" className="flex items-center space-x-3">
              <div className="relative w-10 h-10">
                <Image 
                  src="/images/dark_mode_icon.png"
                  alt="ZeScan Logo" 
                  fill
                  sizes="40px"
                  className="object-contain"
                />
              </div>
              <span className="text-2xl font-bold bg-gradient-to-r from-blue-400 to-blue-600 text-transparent bg-clip-text">
                ZeScan
              </span>
            </Link>

            <Link 
              href="/"
              className="bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 px-6 py-2 rounded-full transition flex items-center space-x-2 shadow-lg shadow-blue-500/30"
            >
              <Home className="w-4 h-4" />
              <span>Go Home</span>
            </Link>
          </div>
        </div>
      </nav>

      {/* 404 Content */}
      <main className="flex-1 flex items-center justify-center px-4 sm:px-6 lg:px-8 pt-20">
        <div className="max-w-4xl mx-auto text-center">
          {/* Animated Background Elements */}
          <div className="absolute inset-0 overflow-hidden pointer-events-none">
            <div className="absolute top-1/4 left-1/4 w-64 h-64 bg-blue-500 rounded-full opacity-5 blur-3xl animate-pulse"></div>
            <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-blue-600 rounded-full opacity-5 blur-3xl animate-pulse" style={{ animationDelay: '1s' }}></div>
          </div>

          {/* Main Content */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.6 }}
            className="relative z-10"
          >
            {/* 404 Number with Animation */}
            <motion.div
              initial={{ scale: 0.5, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ duration: 0.8, ease: "easeOut" }}
              className="mb-8"
            >
              <div className="inline-flex items-center justify-center">
                <AlertCircle className="w-24 h-24 text-blue-400 animate-pulse" />
              </div>
              <h1 className="text-9xl md:text-[12rem] font-bold bg-gradient-to-r from-blue-400 via-blue-500 to-blue-600 text-transparent bg-clip-text leading-none">
                404
              </h1>
            </motion.div>

            {/* Title */}
            <motion.h2
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.3, duration: 0.6 }}
              className="text-3xl md:text-5xl font-bold mb-4"
            >
              Page Not Found
            </motion.h2>

            {/* Description */}
            <motion.p
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.4, duration: 0.6 }}
              className="text-xl text-gray-400 mb-8 max-w-2xl mx-auto"
            >
              Oops! The page you're looking for seems to have been moved or doesn't exist. 
              But don't worry, we can help you find what you need.
            </motion.p>

            {/* Illustration */}
            <motion.div
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              transition={{ delay: 0.5, duration: 0.6 }}
              className="mb-12 relative w-full max-w-md mx-auto"
            >
              <div className="relative w-full aspect-square">
                <Image
                  src="/illustrations/undraw_not-found_6bgl.svg"
                  alt="404 Not Found Illustration"
                  fill
                  sizes="(max-width: 768px) 100vw, 448px"
                  loading="eager"
                  priority
                  className="object-contain"
                />
              </div>
            </motion.div>

            {/* CTA Buttons */}
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.6, duration: 0.6 }}
              className="flex flex-col sm:flex-row gap-4 justify-center items-center mb-12"
            >
              <Link
                href="/"
                className="group bg-gradient-to-r from-blue-500 to-blue-600 hover:from-blue-600 hover:to-blue-700 px-8 py-4 rounded-full transition flex items-center space-x-2 shadow-lg shadow-blue-500/30 transform hover:scale-105"
              >
                <Home className="w-5 h-5" />
                <span className="font-medium">Go to Homepage</span>
                <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition" />
              </Link>

              <a
                href="https://play.google.com/store/apps/details?id=com.zeppelinlabs.digital.zescan"
                target="_blank"
                rel="noopener noreferrer"
                className="group bg-gray-800 hover:bg-gray-700 border border-gray-700 hover:border-blue-500 px-8 py-4 rounded-full transition flex items-center space-x-2 transform hover:scale-105"
              >
                <Download className="w-5 h-5" />
                <span className="font-medium">Download App</span>
              </a>
            </motion.div>

            {/* Quick Links */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.7, duration: 0.6 }}
              className="border-t border-gray-800 pt-8"
            >
              <p className="text-sm text-gray-500 mb-4">Quick Links:</p>
              <div className="flex flex-wrap justify-center gap-6">
                <Link href="/features" className="text-gray-400 hover:text-blue-400 transition text-sm flex items-center space-x-1">
                  <Search className="w-4 h-4" />
                  <span>Features</span>
                </Link>
                <Link href="/privacy" className="text-gray-400 hover:text-blue-400 transition text-sm flex items-center space-x-1">
                  <Search className="w-4 h-4" />
                  <span>Privacy Policy</span>
                </Link>
                <Link href="/contact" className="text-gray-400 hover:text-blue-400 transition text-sm flex items-center space-x-1">
                  <Search className="w-4 h-4" />
                  <span>Feedback</span>
                </Link>
              </div>
            </motion.div>

            {/* Search Suggestion */}
            <motion.div
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ delay: 0.8, duration: 0.6 }}
              className="mt-8"
            >
              <div className="bg-gray-800/50 backdrop-blur-sm border border-gray-700 rounded-2xl p-6 max-w-md mx-auto">
                <p className="text-sm text-gray-400 mb-3">
                  Looking for something specific?
                </p>
                <button
                  onClick={() => router.push('/')}
                  className="w-full bg-gray-900 border border-gray-700 rounded-lg px-4 py-3 text-left text-gray-500 hover:border-blue-500 transition flex items-center space-x-2"
                >
                  <Search className="w-4 h-4" />
                  <span>Search our website...</span>
                </button>
              </div>
            </motion.div>
          </motion.div>
        </div>
      </main>

      {/* Footer */}
      <footer className="py-8 px-4 border-t border-gray-800 bg-black">
        <div className="max-w-7xl mx-auto text-center">
          <p className="text-sm text-gray-400">
            © 2026 ZeScan. All rights reserved. | Developed by{' '}
            <a 
              href="https://zeppelinlabs.digital" 
              target="_blank" 
              rel="noopener noreferrer"
              className="text-blue-400 hover:text-blue-300 transition"
            >
              Zeppelin Labs
            </a>
          </p>
        </div>
      </footer>
    </div>
  );
}
