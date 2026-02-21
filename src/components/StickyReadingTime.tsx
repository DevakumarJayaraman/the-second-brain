import React, { useState, useEffect } from 'react';

export default function StickyReadingTime({ readingTime }: { readingTime?: number }) {
  const [timerStarted, setTimerStarted] = useState(false);
  const [elapsedTime, setElapsedTime] = useState(0);
  const [estimatedMinutes, setEstimatedMinutes] = useState<number>(0);
  const timerIntervalRef = React.useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    // Use prop if available, otherwise extract from page DOM
    if (readingTime) {
      setEstimatedMinutes(Math.ceil(readingTime));
    } else {
      const article = document.querySelector('article');
      if (article) {
        const wordsPerMinute = 160;
        const wordCount = article.innerText.trim().split(/\s+/).length;
        setEstimatedMinutes(Math.ceil(wordCount / wordsPerMinute));
      }
    }

    return () => {
      if (timerIntervalRef.current) {
        clearInterval(timerIntervalRef.current);
      }
    };
  }, [readingTime]);

  const startTimer = () => {
    if (timerStarted) {
      if (timerIntervalRef.current) {
        clearInterval(timerIntervalRef.current);
      }
      setTimerStarted(false);
    } else {
      setElapsedTime(0);
      timerIntervalRef.current = setInterval(() => {
        setElapsedTime(prev => prev + 1);
      }, 1000);
      setTimerStarted(true);
    }
  };

  const resetTimer = () => {
    if (timerIntervalRef.current) {
      clearInterval(timerIntervalRef.current);
    }
    setElapsedTime(0);
    setTimerStarted(false);
  };

  const formatTime = (seconds: number): string => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}:${secs < 10 ? '0' : ''}${secs}`;
  };

  if (!estimatedMinutes) return null;

  return (
    <div className="sticky-reading-time">
      <div className="sticky-reading-time-content">
        <div className="sticky-time-left">
          <span className="reading-time-label">📖 Est. Read:</span>
          <span className="reading-time-value">{estimatedMinutes} min</span>
        </div>

        <div className="sticky-time-middle">
          {timerStarted && (
            <span className="timer-display">{formatTime(elapsedTime)}</span>
          )}
        </div>

        <div className="sticky-time-right">
          <button
            onClick={startTimer}
            className={`sticky-timer-btn ${timerStarted ? 'btn-stop' : 'btn-start'}`}
            title={timerStarted ? 'Stop timer' : 'Start timer'}
          >
            {timerStarted ? '⏹ Stop' : '⏱️ Start'}
          </button>
          {timerStarted && (
            <button
              onClick={resetTimer}
              className="sticky-timer-btn btn-reset"
              title="Reset timer"
            >
              🔄
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
