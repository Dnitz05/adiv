# Supabase Setup Guide - Smart Divination Platform

This guide provides step-by-step instructions for setting up the Supabase backend for the Smart Divination platform.

## Prerequisites

- [Supabase CLI](https://supabase.com/docs/guides/cli) installed
- A [Supabase](https://supabase.com) account
- Node.js 18+ installed

## 1. Create Supabase Project

1. Go to [Supabase Dashboard](https://app.supabase.com)
2. Click "New Project"
3. Choose your organization
4. Fill in project details:
   - **Name**: Smart Divination
   - **Database Password**: Generate a strong password
   - **Region**: Choose closest to your users
   - **Plan**: Start with Free tier

## 2. Configure Environment Variables

1. Copy `.env.example` to `.env.local`:
   ```bash
   cp .env.example .env.local
   ```

2. Fill in your Supabase credentials from the project dashboard:
   - Go to **Settings** → **API**
   - Copy the **Project URL** and **anon/public key**
   - Copy the **service_role key** (keep this secret!)

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key_here
```

## 3. Run Database Migration

### Option A: Using Supabase Dashboard (Recommended for beginners)

1. Go to your Supabase project dashboard
2. Navigate to **SQL Editor**
3. Copy the entire contents of `supabase/migrations/20250101000001_initial_schema.sql`
4. Paste it into a new query
5. Click **Run** to execute the migration

### Option B: Using Supabase CLI

1. Initialize Supabase in your project:
   ```bash
   supabase init
   ```

2. Link to your remote project:
   ```bash
   supabase link --project-ref your-project-id
   ```

3. Apply the migration:
   ```bash
   supabase db push
   ```

## 4. Verify Database Setup

After running the migration, verify that the following tables were created:

- **users** - User profiles and preferences
- **sessions** - Divination sessions and results
- **user_stats** - Usage statistics per user per technique
- **api_usage** - API monitoring and analytics

You can check this in the Supabase dashboard under **Database** → **Tables**.

## 5. Configure Authentication

### Enable Email Authentication

1. Go to **Authentication** → **Settings**
2. Under **Site URL**, add your domain:
   - Development: `http://localhost:3000`
   - Production: `https://your-domain.vercel.app`

### Configure OAuth Providers (Optional)

#### Google OAuth
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create OAuth 2.0 credentials
3. Add authorized origins and redirect URIs
4. Copy Client ID and Secret to your `.env.local`
5. Enable Google provider in Supabase dashboard

#### Apple OAuth
1. Go to [Apple Developer Portal](https://developer.apple.com)
2. Create Sign in with Apple service
3. Configure domains and redirect URIs
4. Copy credentials to your `.env.local`
5. Enable Apple provider in Supabase dashboard

## 6. Test the Setup

### Test Database Connection

Run this simple test to verify your database connection:

```javascript
import { getSupabaseClient } from './lib/utils/supabase';

async function testConnection() {
  const supabase = getSupabaseClient();
  const { data, error } = await supabase.from('users').select('count');
  
  if (error) {
    console.error('Database connection failed:', error);
  } else {
    console.log('Database connection successful!');
  }
}
```

### Test Authentication

Try creating a test user through your app or the Supabase dashboard.

## 7. Production Deployment

### Vercel Environment Variables

When deploying to Vercel, add these environment variables:

```bash
vercel env add SUPABASE_URL production
vercel env add SUPABASE_ANON_KEY production  
vercel env add SUPABASE_SERVICE_ROLE_KEY production
vercel env add DEEPSEEK_API_KEY production
```

### Update Authentication URLs

Update your Supabase authentication settings with production URLs:
- Site URL: `https://your-app.vercel.app`
- Redirect URLs: Add all your production domains

## 8. Optional Integrations

### DeepSeek AI Integration

1. Sign up at [DeepSeek](https://platform.deepseek.com)
2. Generate API key
3. Add to your `.env.local`:
   ```env
   DEEPSEEK_API_KEY=your_deepseek_api_key_here
   ```

### Random.org Integration

1. Sign up at [Random.org](https://api.random.org)
2. Get API key
3. Add to your `.env.local`:
   ```env
   RANDOM_ORG_KEY=your_random_org_api_key_here
   ```

## 9. Security Best Practices

### Row Level Security (RLS)

Our migration automatically enables RLS with these policies:
- Users can only access their own data
- Sessions are private to the user who created them
- Service role has full access for admin operations

### API Security

- Never expose `SUPABASE_SERVICE_ROLE_KEY` to client-side code
- Use the anon key for public operations
- Implement rate limiting for sensitive endpoints

## 10. Monitoring and Maintenance

### Database Maintenance

Set up periodic cleanup of old data:

```sql
-- Run monthly to clean up old deleted sessions
SELECT cleanup_old_deleted_sessions();

-- Refresh user statistics
SELECT refresh_user_stats('user-uuid-here');
```

### Performance Monitoring

Monitor your database performance in the Supabase dashboard:
- Go to **Database** → **Extensions** → Enable `pg_stat_statements`
- Use the **Reports** section to monitor query performance

## Troubleshooting

### Common Issues

1. **Migration fails**: Check that you have the correct permissions and the database is accessible
2. **Authentication not working**: Verify site URLs match exactly
3. **RLS blocking queries**: Make sure users are properly authenticated
4. **Connection timeouts**: Check your database region and connection limits

### Getting Help

- [Supabase Documentation](https://supabase.com/docs)
- [Supabase Discord](https://discord.supabase.com)
- Check the logs in your Supabase dashboard

## Conclusion

Your Supabase backend is now configured for the Smart Divination platform! The database schema supports:

- ✅ User management with preferences and tiers
- ✅ Secure divination session storage
- ✅ Real-time statistics and analytics
- ✅ Multi-technique support (Tarot, I Ching, Runes)
- ✅ AI interpretation history
- ✅ Row-level security for data protection

Next steps:
1. Test all API endpoints with the database
2. Set up the Flutter frontend integration
3. Configure monitoring and analytics
4. Deploy to production