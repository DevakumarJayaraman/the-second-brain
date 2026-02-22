---
title: Integrating LLMs into Simple Apps
sidebar_position: 1
displayed_sidebar: aiSidebar
tags:
  - llm
  - openai
  - api
  - integration
  - python
description: Learn how to integrate Large Language Models into your applications with practical examples and code samples.
---

# Integrating LLMs into Simple Apps

Learn how to integrate Large Language Models (LLMs) into your applications in 15 minutes! 🚀

---

## 🎯 What We'll Build

A simple Python application that:
- Connects to an LLM API (OpenAI/local model)
- Sends prompts and receives responses
- Handles errors and retries
- Streams responses for better UX

---

## 📋 Prerequisites

```bash
# Install required packages
pip install openai python-dotenv
```

**What you need:**
- Python 3.8+
- API key from OpenAI (or use a local model like Ollama)
- Basic understanding of Python

---

## 🔑 The Fundamentals

### What is an LLM?

**Large Language Model** - An AI model trained on massive amounts of text that can:
- Understand and generate human-like text
- Answer questions
- Summarize content
- Write code
- Translate languages
- And much more!

### Popular LLM Providers

| Provider | Model Examples | Best For |
|----------|---------------|----------|
| **OpenAI** | GPT-4, GPT-3.5-turbo | Production apps, high quality |
| **Anthropic** | Claude 3 | Long context, safety |
| **Local (Ollama)** | Llama 2, Mistral | Privacy, no API costs |
| **Google** | Gemini | Multimodal tasks |
| **Azure OpenAI** | GPT-4 | Enterprise, compliance |

---

## 🏗️ Basic Integration

### 1. Setup Environment Variables

Create a `.env` file:

```bash
# .env
OPENAI_API_KEY=sk-your-api-key-here
```

### 2. Simple Chat Completion

```python
# simple_llm.py
import os
from openai import OpenAI
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

def chat(prompt: str, model: str = "gpt-3.5-turbo") -> str:
    """
    Send a prompt to the LLM and get a response
    
    Args:
        prompt: The user's message
        model: Which model to use
        
    Returns:
        The LLM's response as a string
    """
    try:
        response = client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": "You are a helpful assistant."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.7,  # Controls randomness (0-2)
            max_tokens=500,   # Maximum response length
        )
        
        return response.choices[0].message.content
        
    except Exception as e:
        return f"Error: {str(e)}"

# Test it
if __name__ == "__main__":
    result = chat("Explain what an API is in one sentence.")
    print(result)
```

**Output:**
```
An API (Application Programming Interface) is a set of rules and protocols 
that allows different software applications to communicate with each other.
```

---

## 💬 Conversation with Context

LLMs can maintain context across multiple messages:

```python
# conversation.py
from openai import OpenAI
from dotenv import load_dotenv
import os

load_dotenv()
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

class ChatBot:
    def __init__(self, system_prompt: str = "You are a helpful assistant."):
        """Initialize chatbot with conversation history"""
        self.messages = [
            {"role": "system", "content": system_prompt}
        ]
    
    def chat(self, user_message: str) -> str:
        """Send a message and get response, maintaining context"""
        # Add user message to history
        self.messages.append({"role": "user", "content": user_message})
        
        # Get response from LLM
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=self.messages,
            temperature=0.7
        )
        
        # Add assistant response to history
        assistant_message = response.choices[0].message.content
        self.messages.append({"role": "assistant", "content": assistant_message})
        
        return assistant_message
    
    def reset(self):
        """Clear conversation history"""
        self.messages = self.messages[:1]  # Keep only system message

# Example usage
if __name__ == "__main__":
    bot = ChatBot(system_prompt="You are a Python expert assistant.")
    
    # Multi-turn conversation
    print("Bot:", bot.chat("What is a list comprehension?"))
    print("\nBot:", bot.chat("Can you show me an example?"))
    print("\nBot:", bot.chat("What about with a condition?"))
```

---

## 🌊 Streaming Responses

For better UX, stream responses as they're generated:

```python
# streaming.py
from openai import OpenAI
import os
from dotenv import load_dotenv

load_dotenv()
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

def stream_chat(prompt: str):
    """Stream LLM response word by word"""
    stream = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user", "content": prompt}],
        stream=True  # Enable streaming
    )
    
    print("Assistant: ", end="", flush=True)
    
    for chunk in stream:
        if chunk.choices[0].delta.content:
            content = chunk.choices[0].delta.content
            print(content, end="", flush=True)
    
    print()  # New line at end

# Test streaming
if __name__ == "__main__":
    stream_chat("Write a haiku about programming.")
```

**Output (appears word by word):**
```
Assistant: Code flows like a stream,
Logic branches intertwine,
Bugs lurk in shadows.
```

---

## 🔄 Error Handling & Retries

Production-ready integration with retry logic:

```python
# robust_llm.py
from openai import OpenAI
import os
import time
from dotenv import load_dotenv

load_dotenv()
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

def chat_with_retry(
    prompt: str, 
    max_retries: int = 3,
    retry_delay: int = 2
) -> str:
    """
    Chat with automatic retry on failure
    
    Args:
        prompt: User message
        max_retries: Number of retry attempts
        retry_delay: Seconds to wait between retries
    """
    for attempt in range(max_retries):
        try:
            response = client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[{"role": "user", "content": prompt}],
                timeout=30  # 30 second timeout
            )
            return response.choices[0].message.content
            
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {str(e)}")
            
            if attempt < max_retries - 1:
                print(f"Retrying in {retry_delay} seconds...")
                time.sleep(retry_delay)
            else:
                return f"Failed after {max_retries} attempts: {str(e)}"

# Test
if __name__ == "__main__":
    result = chat_with_retry("What is machine learning?")
    print(result)
```

---

## 🎨 Using Local Models (Ollama)

Don't want to pay for APIs? Run models locally!

### Install Ollama

```bash
# Install Ollama (Mac/Linux)
curl -fsSL https://ollama.com/install.sh | sh

# Pull a model
ollama pull llama2
```

### Use with OpenAI-Compatible API

```python
# local_llm.py
from openai import OpenAI

# Point to local Ollama server
client = OpenAI(
    base_url='http://localhost:11434/v1',
    api_key='ollama'  # Required but unused for Ollama
)

def chat_local(prompt: str) -> str:
    """Chat with local Ollama model"""
    response = client.chat.completions.create(
        model="llama2",  # Use any installed Ollama model
        messages=[{"role": "user", "content": prompt}]
    )
    return response.choices[0].message.content

# Test
if __name__ == "__main__":
    result = chat_local("What are the benefits of local LLMs?")
    print(result)
```

**Benefits of Local Models:**
- ✅ No API costs
- ✅ Complete privacy
- ✅ No rate limits
- ✅ Works offline
- ❌ Slower than cloud
- ❌ Requires good hardware

---

## 🎛️ Key Parameters Explained

### Temperature (0-2)
Controls randomness in responses:
- **0.0** - Deterministic, focused, consistent
- **0.7** - Balanced (default)
- **1.5+** - Creative, varied, unpredictable

```python
# Deterministic (same answer every time)
response = client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[{"role": "user", "content": "What is 2+2?"}],
    temperature=0
)

# Creative (different each time)
response = client.chat.completions.create(
    model="gpt-3.5-turbo",
    messages=[{"role": "user", "content": "Write a creative story opening."}],
    temperature=1.5
)
```

### Max Tokens
Limits response length:
- 1 token ≈ 0.75 words
- 100 tokens ≈ 75 words
- 1000 tokens ≈ 750 words

### Top P (0-1)
Alternative to temperature for controlling randomness:
- Uses nucleus sampling
- 0.1 = only top 10% likely tokens
- 1.0 = all tokens considered

---

## 💰 Cost Management

OpenAI pricing (as of 2024):
- **GPT-3.5-turbo**: $0.50 / 1M input tokens, $1.50 / 1M output tokens
- **GPT-4-turbo**: $10 / 1M input tokens, $30 / 1M output tokens

**Tips to reduce costs:**
1. Use GPT-3.5-turbo for simple tasks
2. Limit max_tokens to prevent long responses
3. Cache common responses
4. Use local models when possible
5. Implement rate limiting

```python
# Cost tracking example
def track_costs(input_tokens: int, output_tokens: int, model: str = "gpt-3.5-turbo"):
    """Calculate API call cost"""
    prices = {
        "gpt-3.5-turbo": {"input": 0.50, "output": 1.50},
        "gpt-4-turbo": {"input": 10.0, "output": 30.0}
    }
    
    cost = (
        (input_tokens / 1_000_000) * prices[model]["input"] +
        (output_tokens / 1_000_000) * prices[model]["output"]
    )
    
    return f"${cost:.6f}"
```

---

## 🎯 Best Practices

| Practice | Why |
|----------|-----|
| ✅ Use environment variables | Keep API keys secure |
| ✅ Implement timeouts | Prevent hanging requests |
| ✅ Add retry logic | Handle transient failures |
| ✅ Stream responses | Better user experience |
| ✅ Set max_tokens | Control costs and response length |
| ✅ Validate inputs | Prevent prompt injection |
| ✅ Cache common queries | Reduce API calls |
| ✅ Monitor usage | Track costs and errors |

---

## 🔗 Next Steps

Now that you can integrate LLMs:
1. Build a [chatbot](./chatbot_guide.md) with a web interface
2. Try [log summarization](./log_summarization.md) for a real-world use case
3. Experiment with different models and parameters

---

## 📚 Useful Resources

| Resource | Description |
|----------|-------------|
| [OpenAI API Docs](https://platform.openai.com/docs) | Official OpenAI documentation |
| [Ollama](https://ollama.com) | Run LLMs locally |
| [LangChain](https://python.langchain.com) | Framework for LLM apps |
| [OpenAI Cookbook](https://cookbook.openai.com) | Code examples |
| [Anthropic Claude](https://www.anthropic.com) | Alternative LLM provider |

---

*You're now ready to integrate LLMs into any application! Start with simple prompts and gradually build more complex features.* 🚀

*Last updated: February 2026*
