# Blinko - Ready to Run

This is a pre-configured version of Blinko that includes AI features setup out of the box.

## Quick Start (Single Command)

Just run this single command to build and start everything:

```bash
cat local-install.sh | bash
```

That's it! The application will be available at http://localhost:1111

## What's Included

✅ **AI Features Pre-configured**
- AI Chat enabled
- AI Embedding enabled  
- AI Tools enabled
- Web Search enabled
- Demo API keys pre-loaded (for testing)

✅ **Database Setup**
- PostgreSQL database automatically configured
- Network setup handled automatically

✅ **Environment Configuration**
- All environment variables pre-set
- No manual configuration required

## For Production Use

The demo API keys in `.env.example` are for testing only. To use real AI features:

1. Open the `.env` file (automatically created during setup)
2. Replace the demo API keys with your actual keys:
   - `OPENAI_API_KEY=your_real_openai_key`
   - `ANTHROPIC_API_KEY=your_real_anthropic_key`
   - `GOOGLE_AI_API_KEY=your_real_google_key`
   - `TAVILY_API_KEY=your_real_tavily_key` (for web search)

3. Restart the application:
   ```bash
   docker restart blinko-website
   ```

## Access Points

- **Application**: http://localhost:1111
- **Database**: localhost:5432 (if you need direct access)

## Troubleshooting

If Docker isn't running:
1. Start Docker Desktop
2. Wait for it to fully load
3. Run the command again

## Features Available

- 📝 Note-taking with AI assistance
- 🤖 AI Chat interface
- 🔍 AI-powered search
- 🌐 Web search integration
- 📎 File attachments with AI analysis
- 🏷️ Smart tagging
- 🎤 Voice transcription (with compatible models)

Everything is pre-configured. Just run the single command and start using Blinko!
