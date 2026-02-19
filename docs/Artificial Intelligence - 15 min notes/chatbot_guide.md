---
title: Building a Sample Chatbot
sidebar_position: 2
displayed_sidebar: aiSidebar
tags:
  - chatbot
  - llm
  - flask
  - web-app
  - conversational-ai
description: Build a complete chatbot with web interface in 15 minutes using Flask and LLMs.
---

# Building a Sample Chatbot

Create a fully functional chatbot with a web interface in 15 minutes! 🤖💬

---

## 🎯 What We'll Build

A complete chatbot application with:
- ✨ Web-based chat interface
- 💬 Conversation memory
- 🎨 Styled UI with CSS
- 🔄 Real-time responses
- 📝 Conversation history

---

## 📋 Prerequisites

```bash
# Install required packages
pip install flask openai python-dotenv
```

**Project Structure:**
```
chatbot/
├── app.py              # Flask backend
├── .env                # API keys (don't commit!)
├── templates/
│   └── index.html      # Chat interface
└── static/
    └── style.css       # Styling
```

---

## 🏗️ Step 1: Backend (Flask + OpenAI)

Create `app.py`:

```python
# app.py
from flask import Flask, render_template, request, jsonify, session
from openai import OpenAI
import os
from dotenv import load_dotenv
import secrets

load_dotenv()

app = Flask(__name__)
app.secret_key = secrets.token_hex(16)  # For session management

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

# Store conversations in memory (use database in production)
conversations = {}

def get_conversation(session_id):
    """Get or create conversation history for a session"""
    if session_id not in conversations:
        conversations[session_id] = [
            {"role": "system", "content": "You are a helpful and friendly AI assistant."}
        ]
    return conversations[session_id]

@app.route('/')
def home():
    """Render the chat interface"""
    # Create unique session ID for each user
    if 'session_id' not in session:
        session['session_id'] = secrets.token_hex(16)
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    """Handle chat messages"""
    try:
        data = request.json
        user_message = data.get('message', '')
        
        if not user_message:
            return jsonify({'error': 'No message provided'}), 400
        
        # Get conversation history
        session_id = session.get('session_id')
        messages = get_conversation(session_id)
        
        # Add user message
        messages.append({"role": "user", "content": user_message})
        
        # Get LLM response
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=messages,
            temperature=0.7,
            max_tokens=500
        )
        
        assistant_message = response.choices[0].message.content
        
        # Add assistant message to history
        messages.append({"role": "assistant", "content": assistant_message})
        
        return jsonify({
            'response': assistant_message,
            'success': True
        })
        
    except Exception as e:
        return jsonify({
            'error': str(e),
            'success': False
        }), 500

@app.route('/reset', methods=['POST'])
def reset():
    """Reset conversation history"""
    session_id = session.get('session_id')
    if session_id in conversations:
        del conversations[session_id]
    return jsonify({'success': True})

if __name__ == '__main__':
    app.run(debug=True, port=5000)
```

---

## 🎨 Step 2: Frontend (HTML + CSS + JavaScript)

Create `templates/index.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Chatbot</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <div class="chat-container">
        <div class="chat-header">
            <h1>🤖 AI Assistant</h1>
            <button id="reset-btn" class="reset-btn">🔄 Reset</button>
        </div>
        
        <div id="chat-messages" class="chat-messages">
            <div class="message bot-message">
                <div class="message-content">
                    Hello! I'm your AI assistant. How can I help you today? 👋
                </div>
            </div>
        </div>
        
        <div class="chat-input-container">
            <input 
                type="text" 
                id="user-input" 
                class="chat-input" 
                placeholder="Type your message here..."
                autocomplete="off"
            >
            <button id="send-btn" class="send-btn">Send</button>
        </div>
    </div>

    <script>
        const chatMessages = document.getElementById('chat-messages');
        const userInput = document.getElementById('user-input');
        const sendBtn = document.getElementById('send-btn');
        const resetBtn = document.getElementById('reset-btn');

        // Add message to chat
        function addMessage(content, isUser = false) {
            const messageDiv = document.createElement('div');
            messageDiv.className = `message ${isUser ? 'user-message' : 'bot-message'}`;
            
            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            contentDiv.textContent = content;
            
            messageDiv.appendChild(contentDiv);
            chatMessages.appendChild(messageDiv);
            
            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }

        // Send message to backend
        async function sendMessage() {
            const message = userInput.value.trim();
            
            if (!message) return;
            
            // Add user message to UI
            addMessage(message, true);
            userInput.value = '';
            
            // Disable input while waiting
            userInput.disabled = true;
            sendBtn.disabled = true;
            
            // Show typing indicator
            const typingDiv = document.createElement('div');
            typingDiv.className = 'message bot-message typing';
            typingDiv.innerHTML = '<div class="message-content">Typing...</div>';
            chatMessages.appendChild(typingDiv);
            
            try {
                const response = await fetch('/chat', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ message: message })
                });
                
                const data = await response.json();
                
                // Remove typing indicator
                typingDiv.remove();
                
                if (data.success) {
                    addMessage(data.response);
                } else {
                    addMessage('Sorry, something went wrong. Please try again.');
                }
                
            } catch (error) {
                typingDiv.remove();
                addMessage('Error: Could not connect to the server.');
            } finally {
                userInput.disabled = false;
                sendBtn.disabled = false;
                userInput.focus();
            }
        }

        // Reset conversation
        async function resetConversation() {
            if (confirm('Are you sure you want to reset the conversation?')) {
                try {
                    await fetch('/reset', { method: 'POST' });
                    
                    // Clear messages except welcome
                    chatMessages.innerHTML = `
                        <div class="message bot-message">
                            <div class="message-content">
                                Hello! I'm your AI assistant. How can I help you today? 👋
                            </div>
                        </div>
                    `;
                } catch (error) {
                    alert('Error resetting conversation');
                }
            }
        }

        // Event listeners
        sendBtn.addEventListener('click', sendMessage);
        resetBtn.addEventListener('click', resetConversation);
        
        userInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                sendMessage();
            }
        });

        // Focus input on load
        userInput.focus();
    </script>
</body>
</html>
```

---

## 💅 Step 3: Styling (CSS)

Create `static/style.css`:

```css
/* static/style.css */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 20px;
}

.chat-container {
    width: 100%;
    max-width: 800px;
    height: 90vh;
    max-height: 700px;
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.chat-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.chat-header h1 {
    font-size: 24px;
    font-weight: 600;
}

.reset-btn {
    background: rgba(255, 255, 255, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.3);
    color: white;
    padding: 8px 16px;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    transition: all 0.3s ease;
}

.reset-btn:hover {
    background: rgba(255, 255, 255, 0.3);
}

.chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 20px;
    background: #f7f7f7;
}

.message {
    margin-bottom: 16px;
    display: flex;
    animation: slideIn 0.3s ease;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.message-content {
    max-width: 70%;
    padding: 12px 16px;
    border-radius: 12px;
    line-height: 1.5;
    word-wrap: break-word;
}

.user-message {
    justify-content: flex-end;
}

.user-message .message-content {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-bottom-right-radius: 4px;
}

.bot-message .message-content {
    background: white;
    color: #333;
    border-bottom-left-radius: 4px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.typing .message-content {
    animation: pulse 1.5s ease-in-out infinite;
}

@keyframes pulse {
    0%, 100% {
        opacity: 1;
    }
    50% {
        opacity: 0.5;
    }
}

.chat-input-container {
    padding: 20px;
    background: white;
    border-top: 1px solid #e0e0e0;
    display: flex;
    gap: 10px;
}

.chat-input {
    flex: 1;
    padding: 12px 16px;
    border: 2px solid #e0e0e0;
    border-radius: 12px;
    font-size: 15px;
    outline: none;
    transition: border-color 0.3s ease;
}

.chat-input:focus {
    border-color: #667eea;
}

.send-btn {
    padding: 12px 24px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    border-radius: 12px;
    font-size: 15px;
    font-weight: 600;
    cursor: pointer;
    transition: transform 0.2s ease;
}

.send-btn:hover {
    transform: translateY(-2px);
}

.send-btn:active {
    transform: translateY(0);
}

.send-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

/* Scrollbar styling */
.chat-messages::-webkit-scrollbar {
    width: 8px;
}

.chat-messages::-webkit-scrollbar-track {
    background: #f1f1f1;
}

.chat-messages::-webkit-scrollbar-thumb {
    background: #888;
    border-radius: 4px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
    background: #555;
}
```

---

## 🚀 Step 4: Run Your Chatbot

```bash
# Create .env file
echo "OPENAI_API_KEY=your-api-key-here" > .env

# Run the application
python app.py
```

Open http://localhost:5000 in your browser! 🎉

---

## 🎨 Enhanced Features

### 1. Add System Prompt Customization

```python
# Add to app.py
@app.route('/set-personality', methods=['POST'])
def set_personality():
    """Change chatbot personality"""
    data = request.json
    personality = data.get('personality', 'helpful')
    
    personalities = {
        'helpful': "You are a helpful and friendly AI assistant.",
        'professional': "You are a professional business consultant.",
        'casual': "You are a casual, fun friend who uses emojis.",
        'technical': "You are a technical expert who explains things in detail."
    }
    
    session_id = session.get('session_id')
    conversations[session_id] = [
        {"role": "system", "content": personalities.get(personality, personalities['helpful'])}
    ]
    
    return jsonify({'success': True})
```

### 2. Add Typing Indicator Animation

```javascript
// Enhanced typing indicator
function showTyping() {
    const typingDiv = document.createElement('div');
    typingDiv.className = 'message bot-message typing';
    typingDiv.innerHTML = `
        <div class="message-content">
            <span class="dot">.</span>
            <span class="dot">.</span>
            <span class="dot">.</span>
        </div>
    `;
    typingDiv.id = 'typing-indicator';
    chatMessages.appendChild(typingDiv);
}
```

### 3. Save Conversation to File

```python
# Add to app.py
import json
from datetime import datetime

@app.route('/export', methods=['POST'])
def export_conversation():
    """Export conversation as JSON"""
    session_id = session.get('session_id')
    messages = conversations.get(session_id, [])
    
    export_data = {
        'timestamp': datetime.now().isoformat(),
        'conversation': messages
    }
    
    filename = f"chat_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
    
    with open(filename, 'w') as f:
        json.dump(export_data, f, indent=2)
    
    return jsonify({'success': True, 'filename': filename})
```

---

## 🔧 Adding Local Model Support

Use Ollama for free, local chatbot:

```python
# Modify app.py to support Ollama
import os

USE_LOCAL = os.getenv('USE_LOCAL_MODEL', 'false').lower() == 'true'

if USE_LOCAL:
    client = OpenAI(
        base_url='http://localhost:11434/v1',
        api_key='ollama'
    )
    MODEL = "llama2"
else:
    client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))
    MODEL = "gpt-3.5-turbo"

# Update chat route to use MODEL variable
response = client.chat.completions.create(
    model=MODEL,
    messages=messages,
    temperature=0.7,
    max_tokens=500
)
```

---

## 📱 Mobile Responsive

The CSS above is already responsive! The chatbot works great on mobile devices.

---

## 🎯 Production Improvements

For production use, consider:

1. **Database Storage** - Replace in-memory dict with Redis/PostgreSQL
2. **Authentication** - Add user login system
3. **Rate Limiting** - Prevent abuse with Flask-Limiter
4. **Error Logging** - Use proper logging framework
5. **HTTPS** - Deploy with SSL certificate
6. **Message Moderation** - Filter inappropriate content
7. **Analytics** - Track usage and errors

```python
# Example: Add rate limiting
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address

limiter = Limiter(
    app=app,
    key_func=get_remote_address,
    default_limits=["200 per day", "50 per hour"]
)

@app.route('/chat', methods=['POST'])
@limiter.limit("10 per minute")  # Limit to 10 messages per minute
def chat():
    # ... existing code
```

---

## 🔗 Next Steps

Enhance your chatbot:
1. Add **voice input** with Web Speech API
2. Implement **message reactions** (👍 👎)
3. Add **conversation branching**
4. Create **chatbot personas** (professional, casual, etc.)
5. Integrate with **messaging platforms** (Slack, Discord)

Try the [Log Summarization](./log_summarization.md) example to see another practical use case!

---

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [Flask Documentation](https://flask.palletsprojects.com/) | Web framework docs |
| [OpenAI Chat API](https://platform.openai.com/docs/guides/chat) | Chat completion guide |
| [Gradio](https://gradio.app/) | Quick UI alternative |
| [Streamlit](https://streamlit.io/) | Another UI option |
| [LangChain](https://python.langchain.com/) | Advanced chatbot features |

---

*You now have a fully functional chatbot! Customize it, add features, and deploy it to share with the world.* 🚀

*Last updated: February 2026*
