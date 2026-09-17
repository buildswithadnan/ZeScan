import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { sendFeedbackEmail } from '@/lib/emailService';

// Validation schema for feedback
const feedbackSchema = z.object({
  type: z.enum(['feedback', 'feature_request', 'bug_report']),
  email: z.string().email().optional().or(z.literal('')),
  phone: z.string().optional().or(z.literal('')),
  subject: z.string().min(3).max(200),
  message: z.string().min(10).max(2000),
  appVersion: z.string().optional(),
  deviceInfo: z.string().optional(),
});

export async function POST(request: NextRequest) {
  try {
    // Parse request body
    const body = await request.json();
    
    // Validate input
    const validatedData = feedbackSchema.parse(body);
    
    // Create feedback entry
    const feedback = {
      id: `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`,
      ...validatedData,
      email: validatedData.email || undefined,
      timestamp: new Date().toISOString(),
      status: 'new',
      ipAddress: request.headers.get('x-forwarded-for') || 
                 request.headers.get('x-real-ip') || 
                 'unknown',
      userAgent: request.headers.get('user-agent') || 'unknown',
    };

    // Log feedback to console (you can view this in Vercel logs)
    console.log('='.repeat(80));
    console.log('📝 NEW FEEDBACK RECEIVED');
    console.log('='.repeat(80));
    console.log('ID:', feedback.id);
    console.log('Type:', feedback.type.toUpperCase());
    console.log('Subject:', feedback.subject);
    console.log('Message:', feedback.message);
    console.log('Email:', feedback.email || 'Not provided');
    console.log('Phone:', feedback.phone || 'Not provided');
    console.log('App Version:', feedback.appVersion || 'Not provided');
    console.log('Device:', feedback.deviceInfo || 'Not provided');
    console.log('Timestamp:', feedback.timestamp);
    console.log('IP:', feedback.ipAddress);
    console.log('='.repeat(80));

    // Send email notification
    try {
      await sendFeedbackEmail({
        ...feedback,
        feedbackId: feedback.id,
      });
      console.log('✅ Email notification sent for feedback:', feedback.id);
    } catch (emailError) {
      console.error('❌ Failed to send email notification:', emailError);
      // Continue even if email fails - don't block the user
    }

    // TODO: Save to database (Firestore, MongoDB, Supabase, etc.)
    // For now, feedback is logged to Vercel deployment logs
    // You can view these in: Vercel Dashboard → Deployments → Functions → Logs

    return NextResponse.json(
      {
        success: true,
        message: 'Thank you for your feedback! We appreciate your input.',
        feedbackId: feedback.id,
      },
      { status: 201 }
    );
  } catch (error) {
    if (error instanceof z.ZodError) {
      return NextResponse.json(
        {
          success: false,
          message: 'Invalid input data',
          errors: error.issues,
        },
        { status: 400 }
      );
    }

    console.error('❌ Error processing feedback:', error);
    return NextResponse.json(
      {
        success: false,
        message: 'An error occurred while processing your feedback',
      },
      { status: 500 }
    );
  }
}

export async function GET() {
  return NextResponse.json(
    {
      message: 'Feedback API endpoint',
      methods: ['POST'],
      expectedFields: {
        type: 'feedback | feature_request | bug_report',
        email: 'string (optional)',
        phone: 'string (optional)',
        subject: 'string (3-200 chars)',
        message: 'string (10-2000 chars)',
        appVersion: 'string (optional)',
        deviceInfo: 'string (optional)',
      },
    },
    { status: 200 }
  );
}
