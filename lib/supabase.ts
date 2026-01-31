import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY!;

if (!supabaseUrl || !supabaseAnonKey) {
    throw new Error('Missing Supabase environment variables');
}

/**
 * Supabase client for database operations
 * Used for storing user data, images, and other app data
 */
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: {
        // Disable auto-refresh since we're using Clerk for auth
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false,
    },
});

export { supabaseUrl, supabaseAnonKey };
