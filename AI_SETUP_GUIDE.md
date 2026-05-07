# Blinko AI Setup Guide with Google Gemini

## 🎯 Summary
- ✅ Resource page removed from main menu
- ✅ About page removed from settings
- ✅ Application running on Docker at http://localhost:1111
- ✅ Google Gemini models identified and configured

## 🐳 Application Status
The Blinko application is now running successfully with Docker:
- **URL**: http://localhost:1111
- **Database**: PostgreSQL (port 5432)
- **Status**: Healthy and ready for AI configuration

## 🤖 Available Google Gemini Models

### Main Chat Models
1. **gemini-1.5-pro** - Most capable model
   - Capabilities: Chat, Tools, Vision, Video, Audio
   - Best for: Complex tasks, reasoning, multi-modal

2. **gemini-1.5-flash** - Fast and efficient
   - Capabilities: Chat, Tools, Vision, Video, Audio  
   - Best for: Quick responses, real-time applications

3. **gemini-pro** - Previous generation
   - Capabilities: Chat, Tools
   - Best for: Basic text tasks

4. **gemini-pro-vision** - Vision focused
   - Capabilities: Chat, Vision
   - Best for: Image analysis tasks

### Embedding Models
1. **text-embedding-004** - Latest embedding model
   - Dimensions: 768
   - Best for: Semantic search, RAG

2. **text-embedding-gecko** - Previous generation
   - Dimensions: 768
   - Best for: Basic embeddings

## 📋 Step-by-Step AI Setup

### Step 1: Get Google Gemini API Key
1. Visit [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key (starts with "AIza...")

### Step 2: Configure Environment Variables
Update your `.env` file with:
```env
GOOGLE_AI_API_KEY=your_actual_gemini_api_key_here
```

Or set via Docker:
```bash
docker-compose down
GOOGLE_AI_API_KEY=your_actual_gemini_api_key_here docker-compose up -d
```

### Step 3: Configure AI in Blinko UI
1. Open http://localhost:1111 in your browser
2. Go to **Settings** → **AI**
3. **Add Provider**:
   - **Provider**: Google AI
   - **Name**: Google AI (or your preferred name)
   - **API Key**: Your Gemini API key
   - **Base URL**: https://generativelanguage.googleapis.com (default)
4. Click **Test Connection** to verify
5. **Add Models**:
   - Select from available Gemini models
   - Recommended: `gemini-1.5-flash` for main use
   - Recommended: `text-embedding-004` for embeddings

### Step 4: Set Default Models
1. In AI Settings, configure:
   - **Main Model**: gemini-1.5-flash
   - **Embedding Model**: text-embedding-004 (optional)
   - **Voice Model**: (if needed)
   - **Image Model**: (if needed)

### Step 5: Enable AI Features
Ensure these are enabled in Settings → AI:
- ✅ Enable AI Features
- ✅ Enable AI Chat
- ✅ Enable AI Embeddings (for search)
- ✅ Enable AI Tools
- ✅ Enable Web Search (optional)

## 🚀 Testing Your Setup

### Test AI Chat
1. Go to **AI** tab in the sidebar
2. Start a conversation
3. Try: "Hello, can you help me organize my notes?"

### Test Vision
1. Upload an image to a note
2. Ask AI about the image: "What do you see in this image?"

### Test Embeddings
1. Create several notes
2. Use AI search to find related content
3. Ask: "Find notes about [topic]"

## 🔧 Troubleshooting

### Common Issues

**API Key Not Working**
- Verify key starts with "AIza..."
- Check key has no extra spaces
- Ensure billing is enabled in Google Cloud

**Model Not Available**
- Some models may be region-restricted
- Try `gemini-1.5-flash` as it's widely available
- Check Google AI console for model availability

**Connection Failed**
- Verify internet connection
- Check firewall settings
- Ensure API key is valid

**Docker Issues**
```bash
# Check container status
docker ps

# View logs
docker logs blinko-website

# Restart services
docker-compose restart
```

## 📚 Advanced Configuration

### Model Selection Guide
- **For speed**: `gemini-1.5-flash`
- **For quality**: `gemini-1.5-pro`
- **For images**: Any model with "vision" capability
- **For search**: `text-embedding-004`

### Cost Optimization
- Use `gemini-1.5-flash` for most tasks
- Reserve `gemini-1.5-pro` for complex reasoning
- Monitor usage in Google AI Studio

### Security Best Practices
- Never commit API keys to git
- Use environment variables
- Rotate API keys regularly
- Monitor API usage

## 🎉 You're All Set!

Your Blinko application is now configured with:
- ✅ Clean interface (resource/about pages removed)
- ✅ Docker deployment running
- ✅ Google Gemini AI integration
- ✅ Multi-modal capabilities (text, image, audio, video)

Start exploring AI-powered note-taking! 🚀
