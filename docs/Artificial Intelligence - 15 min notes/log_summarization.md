---
title: Log Summarization with AI
sidebar_position: 3
displayed_sidebar: aiSidebar
tags:
  - llm
  - logs
  - devops
  - automation
  - python
description: Use AI to automatically analyze and summarize application logs - a real-world practical example.
---

# Log Summarization with AI

Learn how to use LLMs to automatically analyze and summarize application logs! 🔍📊

---

## 🎯 Why Summarize Logs with AI?

**The Problem:** Modern applications generate thousands of log entries per minute. Finding issues manually is like finding a needle in a haystack.

**The Solution:** Use LLMs to:
- 🔍 Identify errors and warnings automatically
- 📊 Summarize what happened in plain English
- 🎯 Highlight critical issues
- 💡 Suggest potential fixes
- ⏱️ Save hours of manual log analysis

---

## 📋 Prerequisites

```bash
# Install required packages
pip install openai python-dotenv
```

---

## 📝 Sample Log Files

### Example 1: Web Server Logs

Create `sample_logs/web_server.log`:

```
2026-02-19 08:15:23 INFO  [Server] Application started on port 8080
2026-02-19 08:15:24 INFO  [Database] Connected to PostgreSQL at localhost:5432
2026-02-19 08:15:25 INFO  [Cache] Redis connection established at localhost:6379
2026-02-19 08:16:10 INFO  [API] GET /api/users - 200 OK (12ms)
2026-02-19 08:16:15 INFO  [API] POST /api/auth/login - 200 OK (145ms)
2026-02-19 08:16:20 ERROR [Database] Connection timeout after 30s
2026-02-19 08:16:20 ERROR [API] POST /api/orders - 500 Internal Server Error
2026-02-19 08:16:21 WARN  [Database] Retrying connection (attempt 1/3)
2026-02-19 08:16:25 INFO  [Database] Connection restored
2026-02-19 08:16:26 INFO  [API] POST /api/orders - 201 Created (234ms)
2026-02-19 08:17:45 ERROR [Auth] Invalid token for user_id=12345
2026-02-19 08:17:46 WARN  [Security] Multiple failed login attempts from IP 192.168.1.100
2026-02-19 08:18:00 ERROR [Payment] Stripe API timeout - transaction_id=tx_abc123
2026-02-19 08:18:01 INFO  [Payment] Retry scheduled for transaction_id=tx_abc123
2026-02-19 08:18:30 INFO  [Payment] Payment successful - transaction_id=tx_abc123
2026-02-19 08:19:45 CRITICAL [Memory] Heap usage at 95% - triggering GC
2026-02-19 08:19:46 INFO  [Memory] Garbage collection completed - freed 2.3GB
2026-02-19 08:20:00 INFO  [Scheduler] Running daily backup job
2026-02-19 08:21:15 ERROR [Backup] S3 upload failed - bucket not accessible
2026-02-19 08:21:16 ERROR [Backup] Daily backup job failed
```

### Example 2: Application Errors

Create `sample_logs/app_errors.log`:

```
[2026-02-19 10:30:15] ERROR: NullPointerException in UserService.getUserById()
    at com.example.service.UserService.getUserById(UserService.java:45)
    at com.example.controller.UserController.getUser(UserController.java:23)
    Caused by: Database connection is null

[2026-02-19 10:30:45] ERROR: Failed to parse JSON request
    Input: {"user": "john", "email": "invalid-email"}
    Expected format: valid email address

[2026-02-19 10:31:20] WARN: Slow query detected (2450ms)
    Query: SELECT * FROM orders WHERE status = 'pending' AND created_at < NOW() - INTERVAL '7 days'
    Affected rows: 15,000

[2026-02-19 10:32:00] ERROR: OutOfMemoryError: Java heap space
    at com.example.util.DataProcessor.loadFile(DataProcessor.java:89)
    Attempted to allocate: 512MB
    Available memory: 128MB

[2026-02-19 10:35:12] ERROR: API rate limit exceeded
    Endpoint: /api/v1/search
    User: api_user_789
    Current rate: 150 req/min (limit: 100 req/min)
```

---

## 🔧 Basic Log Summarizer

```python
# log_summarizer.py
import os
from openai import OpenAI
from dotenv import load_dotenv

load_dotenv()
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

def summarize_logs(log_content: str, max_tokens: int = 500) -> dict:
    """
    Summarize log file using LLM
    
    Args:
        log_content: Raw log file content
        max_tokens: Maximum length of summary
        
    Returns:
        Dictionary with summary, errors, and suggestions
    """
    
    prompt = f"""Analyze the following application logs and provide:

1. **Summary**: Brief overview of what happened
2. **Critical Issues**: List any errors or critical problems
3. **Warnings**: List warnings that need attention
4. **Recommendations**: Suggest fixes or actions to take
5. **Timeline**: Key events in chronological order

Format your response clearly with these sections.

LOGS:
{{log_content}}
"""
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a DevOps expert specializing in log analysis."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,  # Lower temperature for more focused analysis
            max_tokens=max_tokens
        )
        
        analysis = response.choices[0].message.content
        
        return {
            'success': True,
            'analysis': analysis,
            'tokens_used': response.usage.total_tokens
        }
        
    except Exception as e:
        return {
            'success': False,
            'error': str(e)
        }

# Test with sample log
if __name__ == "__main__":
    # Read sample log
    with open('sample_logs/web_server.log', 'r') as f:
        logs = f.read()
    
    # Analyze
    result = summarize_logs(logs)
    
    if result['success']:
        print("=== LOG ANALYSIS ===\n")
        print(result['analysis'])
        print(f"\n\nTokens used: {result['tokens_used']}")
    else:
        print(f"Error: {result['error']}")
```

**Output Example:**
```
=== LOG ANALYSIS ===

**Summary**
The application started normally but experienced several issues including database 
connection timeouts, authentication failures, payment gateway timeouts, high memory 
usage, and backup failures.

**Critical Issues**
1. Database connection timeout at 08:16:20, causing API failures
2. Memory usage reached 95%, triggering garbage collection
3. S3 bucket inaccessible, causing backup job failure

**Warnings**
1. Multiple failed login attempts from IP 192.168.1.100 (potential security threat)
2. Payment API timeout (resolved after retry)
3. Invalid authentication token for user_id=12345

**Recommendations**
1. Investigate database connection pool settings - timeout occurred under load
2. Monitor memory usage patterns - 95% is critically high
3. Verify S3 bucket permissions and network connectivity
4. Implement rate limiting for IP 192.168.1.100
5. Review authentication token validation logic

**Timeline**
- 08:15:23 - Application started successfully
- 08:16:20 - Database connection failure
- 08:16:25 - Database connection restored
- 08:17:46 - Security warning: multiple failed logins
- 08:19:45 - Critical memory usage (95%)
- 08:21:16 - Backup job failed due to S3 access issues

Tokens used: 487
```

---

## 🎨 Advanced Log Analyzer

With error categorization and severity scoring:

```python
# advanced_log_analyzer.py
import os
from openai import OpenAI
from dotenv import load_dotenv
import json
from typing import List, Dict
import re

load_dotenv()
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

class LogAnalyzer:
    def __init__(self):
        self.client = client
    
    def parse_log_file(self, filepath: str) -> str:
        """Read and return log file content"""
        with open(filepath, 'r') as f:
            return f.read()
    
    def extract_errors(self, log_content: str) -> List[str]:
        """Extract error and critical lines from logs"""
        lines = log_content.split('\n')
        error_lines = [
            line for line in lines 
            if any(keyword in line.upper() for keyword in ['ERROR', 'CRITICAL', 'EXCEPTION', 'FATAL'])
        ]
        return error_lines
    
    def get_structured_analysis(self, log_content: str) -> dict:
        """Get structured analysis from LLM"""
        
        prompt = f"""Analyze these logs and respond ONLY with valid JSON in this exact format:

{{
  "severity": "low|medium|high|critical",
  "summary": "one sentence overview",
  "total_errors": number,
  "total_warnings": number,
  "critical_issues": [
    {{"issue": "description", "timestamp": "time", "impact": "description"}}
  ],
  "root_causes": ["cause1", "cause2"],
  "recommendations": [
    {{"action": "what to do", "priority": "high|medium|low"}}
  ],
  "affected_components": ["component1", "component2"]
}}

LOGS:
{{log_content}}
"""
        
        try:
            response = self.client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are a log analysis expert. Always respond with valid JSON only."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.2,
                max_tokens=1000
            )
            
            analysis_text = response.choices[0].message.content
            
            # Extract JSON from response (in case LLM adds extra text)
            json_match = re.search(r'\{.*\}', analysis_text, re.DOTALL)
            if json_match:
                analysis = json.loads(json_match.group())
            else:
                analysis = json.loads(analysis_text)
            
            return {
                'success': True,
                'data': analysis,
                'tokens_used': response.usage.total_tokens
            }
            
        except Exception as e:
            return {
                'success': False,
                'error': str(e)
            }
    
    def generate_report(self, analysis: dict) -> str:
        """Generate human-readable report"""
        if not analysis['success']:
            return f"Analysis failed: {analysis['error']}"
        
        data = analysis['data']
        
        report = f"""
╔════════════════════════════════════════════════════╗
║          LOG ANALYSIS REPORT                       ║
╚════════════════════════════════════════════════════╝

📊 SEVERITY: {data['severity'].upper()}
📝 SUMMARY: {data['summary']}

📈 STATISTICS:
   • Errors: {data['total_errors']}
   • Warnings: {data['total_warnings']}

🚨 CRITICAL ISSUES:
"""
        
        for i, issue in enumerate(data['critical_issues'], 1):
            report += f"\n   {i}. {issue['issue']}"
            report += f"\n      Time: {issue['timestamp']}"
            report += f"\n      Impact: {issue['impact']}\n"
        
        report += "\n🔍 ROOT CAUSES:\n"
        for i, cause in enumerate(data['root_causes'], 1):
            report += f"   {i}. {cause}\n"
        
        report += "\n✅ RECOMMENDATIONS:\n"
        for i, rec in enumerate(data['recommendations'], 1):
            priority_emoji = {"high": "🔴", "medium": "🟡", "low": "🟢"}
            emoji = priority_emoji.get(rec['priority'].lower(), "⚪")
            report += f"   {emoji} {rec['action']} (Priority: {rec['priority']})\n"
        
        report += f"\n🎯 AFFECTED COMPONENTS:\n"
        report += "   " + ", ".join(data['affected_components'])
        
        report += f"\n\n{'='*52}\n"
        report += f"Tokens used: {analysis['tokens_used']}\n"
        
        return report

# Example usage
if __name__ == "__main__":
    analyzer = LogAnalyzer()
    
    # Analyze web server logs
    print("Analyzing web server logs...\n")
    logs = analyzer.parse_log_file('sample_logs/web_server.log')
    analysis = analyzer.get_structured_analysis(logs)
    report = analyzer.generate_report(analysis)
    print(report)
    
    # Save report to file
    with open('log_analysis_report.txt', 'w') as f:
        f.write(report)
    
    print("\n✅ Report saved to log_analysis_report.txt")
```

**Output Example:**
```
╔════════════════════════════════════════════════════╗
║          LOG ANALYSIS REPORT                       ║
╚════════════════════════════════════════════════════╝

📊 SEVERITY: HIGH
📝 SUMMARY: Multiple system failures including database timeouts, 
            authentication issues, and backup failures

📈 STATISTICS:
   • Errors: 6
   • Warnings: 2

🚨 CRITICAL ISSUES:

   1. Database connection timeout
      Time: 08:16:20
      Impact: API requests failed, potential data loss

   2. High memory usage (95%)
      Time: 08:19:45
      Impact: Application performance degraded, GC triggered

   3. Backup job failure
      Time: 08:21:16
      Impact: No backup available for disaster recovery

🔍 ROOT CAUSES:
   1. Database connection pool exhaustion under load
   2. Memory leak in application causing high heap usage
   3. S3 bucket permissions or network connectivity issue

✅ RECOMMENDATIONS:
   🔴 Increase database connection pool size (Priority: high)
   🔴 Investigate memory leak with profiler (Priority: high)
   🔴 Verify S3 bucket access and restore backups (Priority: high)
   🟡 Block suspicious IP (192.168.1.100) (Priority: medium)
   🟡 Review authentication token expiry settings (Priority: medium)

🎯 AFFECTED COMPONENTS:
   Database, Payment Gateway, Authentication, Backup System, Memory Management

====================================================
Tokens used: 542
```

---

## 🤖 Real-Time Log Monitoring

Monitor logs in real-time and get alerts:

```python
# real_time_monitor.py
import time
import os
from openai import OpenAI
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()
client = OpenAI(api_key=os.getenv('OPENAI_API_KEY'))

class LogMonitor:
    def __init__(self, log_file: str):
        self.log_file = log_file
        self.last_position = 0
        self.error_buffer = []
        self.buffer_size = 10  # Analyze every 10 errors
    
    def check_severity(self, log_lines: List[str]) -> dict:
        """Check if recent errors are severe"""
        
        logs_text = '\n'.join(log_lines)
        
        prompt = f"""Analyze these recent error logs. Respond with JSON:
{{
  "is_critical": true/false,
  "severity": "low|medium|high|critical",
  "alert_message": "one sentence description",
  "should_notify": true/false
}}

LOGS:
{{logs_text}}
"""
        
        try:
            response = client.chat.completions.create(
                model="gpt-3.5-turbo",
                messages=[
                    {"role": "system", "content": "You are a monitoring system. Respond only with JSON."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.1,
                max_tokens=200
            )
            
            result = json.loads(response.choices[0].message.content)
            return result
            
        except Exception as e:
            return None
    
    def tail_log(self):
        """Monitor log file for new entries"""
        print(f"🔍 Monitoring {self.log_file}...")
        print("Press Ctrl+C to stop\n")
        
        try:
            with open(self.log_file, 'r') as f:
                # Move to end of file
                f.seek(0, 2)
                
                while True:
                    line = f.readline()
                    
                    if line:
                        print(f"[{datetime.now().strftime('%H:%M:%S')}] {line.strip()}")
                        
                        # Check for errors
                        if any(keyword in line.upper() for keyword in ['ERROR', 'CRITICAL', 'FATAL']):
                            self.error_buffer.append(line.strip())
                            
                            # Analyze when buffer is full
                            if len(self.error_buffer) >= self.buffer_size:
                                analysis = self.check_severity(self.error_buffer)
                                
                                if analysis and analysis['should_notify']:
                                    self.send_alert(analysis)
                                
                                self.error_buffer = []
                    else:
                        time.sleep(1)  # Wait for new lines
                        
        except KeyboardInterrupt:
            print("\n\n✅ Monitoring stopped")
    
    def send_alert(self, analysis: dict):
        """Send alert (print to console, in production send to Slack/email/PagerDuty)"""
        
        severity_emoji = {{
            'low': '🟢',
            'medium': '🟡',
            'high': '🟠',
            'critical': '🔴'
        }}
        
        emoji = severity_emoji.get(analysis['severity'], '⚪')
        
        alert = f"""
{{'='*50}}
{{emoji}} ALERT: {{analysis['severity'].upper()}}
{{'='*50}}
{{analysis['alert_message']}}
Time: {{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}}
{{'='*50}}
"""
        print(alert)
        
        # In production, send to notification service:
        # - Slack webhook
        # - Email (SendGrid, AWS SES)
        # - PagerDuty
        # - SMS (Twilio)

# Example usage
if __name__ == "__main__":
    monitor = LogMonitor('sample_logs/web_server.log')
    monitor.tail_log()
```

---

## 📊 Batch Log Analysis

Analyze multiple log files and generate comparative report:

```python
# batch_analyzer.py
import os
from pathlib import Path
from log_summarizer import summarize_logs
import json

def analyze_directory(log_dir: str) -> dict:
    """Analyze all log files in a directory"""
    
    log_dir = Path(log_dir)
    results = {}
    
    for log_file in log_dir.glob('*.log'):
        print(f"Analyzing {log_file.name}...")
        
        with open(log_file, 'r') as f:
            content = f.read()
        
        analysis = summarize_logs(content, max_tokens=300)
        results[log_file.name] = analysis
    
    return results

def generate_summary_report(results: dict) -> str:
    """Create comparative summary of all logs"""
    
    report = "="*60 + "\n"
    report += "BATCH LOG ANALYSIS SUMMARY\n"
    report += "="*60 + "\n\n"
    
    for filename, analysis in results.items():
        report += f"\n📄 {filename}\n"
        report += "-"*60 + "\n"
        
        if analysis['success']:
            # Extract first paragraph as summary
            summary = analysis['analysis'].split('\n\n')[0]
            report += summary + "\n"
            report += f"Tokens used: {analysis['tokens_used']}\n"
        else:
            report += f"❌ Analysis failed: {analysis['error']}\n"
    
    return report

# Example usage
if __name__ == "__main__":
    results = analyze_directory('sample_logs')
    report = generate_summary_report(results)
    
    print(report)
    
    # Save full results as JSON
    with open('batch_analysis_results.json', 'w') as f:
        json.dump(results, f, indent=2)
    
    print("\n✅ Full results saved to batch_analysis_results.json")
```

---

## 🎯 Best Practices

| Practice | Why |
|----------|-----|
| ✅ Filter logs before sending | Reduce tokens and cost |
| ✅ Batch small log entries | More efficient than one-by-one |
| ✅ Use lower temperature (0.1-0.3) | More consistent analysis |
| ✅ Extract errors first | Focus on important entries |
| ✅ Set reasonable max_tokens | Control costs |
| ✅ Cache common patterns | Avoid re-analyzing same errors |
| ✅ Use structured output (JSON) | Easier to integrate with systems |
| ✅ Monitor API costs | Set budgets and alerts |

---

## 💰 Cost Estimation

For GPT-3.5-turbo:
- Average log file: 1000 lines ≈ 2000 tokens
- Analysis output: ≈ 500 tokens
- Cost per analysis: ~$0.002 (less than a penny!)

For 1000 log files per day:
- Monthly cost: ~$60
- Compare to: engineer time saved

---

## 🚀 Integration Ideas

### 1. CI/CD Pipeline
```bash
# Add to your pipeline
python log_summarizer.py test_logs/
# Fail build if critical issues found
```

### 2. Cron Job
```bash
# Analyze logs daily at midnight
0 0 * * * python batch_analyzer.py /var/log/myapp/
```

### 3. Alerting System
```python
# Send to Slack when critical issues detected
if analysis['severity'] == 'critical':
    send_slack_alert(analysis['alert_message'])
```

### 4. Dashboard Integration
Display summaries in Grafana, Datadog, or custom dashboard

---

## 🔗 Next Steps

Now that you can summarize logs:
1. Integrate with your existing logging infrastructure
2. Set up automated daily reports
3. Create alerts for critical issues
4. Build a dashboard to visualize trends

Go back to [LLM Integration](./llm_integration.md) for more fundamentals or check out [Chatbot Guide](./chatbot_guide.md) for another practical example!

---

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [OpenAI API Docs](https://platform.openai.com/docs) | Official documentation |
| [Structured Outputs](https://platform.openai.com/docs/guides/structured-outputs) | JSON response format |
| [ELK Stack](https://www.elastic.co/elastic-stack) | Log aggregation platform |
| [Grafana Loki](https://grafana.com/oss/loki/) | Log aggregation system |
| [Papertrail](https://www.papertrail.com/) | Cloud logging service |

---

*You now have the power to tame the chaos of application logs with AI! Happy debugging!* 🔍✨

*Last updated: February 2026*
