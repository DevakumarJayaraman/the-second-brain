import React, { useState, useEffect } from 'react';
import { createPortal } from 'react-dom';
import styles from './ReadAloud.module.css';

const ReadAloud: React.FC = () => {
  const [timerStarted, setTimerStarted] = useState(false);
  const [elapsedTime, setElapsedTime] = useState(0);
  const [estimatedTime, setEstimatedTime] = useState(0);
  const [text, setText] = useState('');
  const timerIntervalRef = React.useRef<NodeJS.Timeout | null>(null);

  useEffect(() => {
    // Extract text from page
    const extractPageText = () => {
      const article = document.querySelector('article');
      if (article) {
        const fullText = article.innerText;
        setText(fullText);
        calculateReadingTime(fullText);
      }
    };

    extractPageText();

    return () => {
      if (timerIntervalRef.current) {
        clearInterval(timerIntervalRef.current);
      }
    };
  }, []);

  const calculateReadingTime = (content: string) => {
    // Average intelligent person reading for comprehension: 150-175 words per minute
    // Using 160 WPM - allows time to understand concepts and take notes
    const wordsPerMinute = 160;
    const wordCount = content.trim().split(/\s+/).length;
    const minutes = Math.ceil(wordCount / wordsPerMinute);
    setEstimatedTime(minutes);
  };

  const startTimer = () => {
    if (timerStarted) {
      // Stop timer
      if (timerIntervalRef.current) {
        clearInterval(timerIntervalRef.current);
      }
      setTimerStarted(false);
    } else {
      // Start timer
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

  const stickyCard = timerStarted && createPortal(
    <div className={styles.stickyTimerCard}>
      <div className={styles.stickyHeader}>
        ⏰ Reading Progress
      </div>
      
      <div className={styles.stickyContent}>
        <div className={styles.stickyTimeDisplay}>{formatTime(elapsedTime)}</div>
        
        <div className={styles.progressBar}>
          <div 
            className={styles.progressFill}
            style={{
              width: `${Math.min((elapsedTime / (estimatedTime * 60)) * 100, 100)}%`
            }}
          />
        </div>

        <div className={styles.stickyStatus}>
          {elapsedTime > estimatedTime * 60 
            ? `📌 Detailed read: ${Math.round((elapsedTime / (estimatedTime * 60)) * 100)}%`
            : `⏱️ ${Math.max(0, Math.round((estimatedTime * 60 - elapsedTime) / 60))}m remaining`
          }
        </div>

        <div className={styles.estimatedDisplay}>
          Expected: {estimatedTime}m
        </div>
      </div>

      <button
        onClick={resetTimer}
        className={styles.stickyResetBtn}
        title="Reset timer"
      >
        🔄 Reset
      </button>
    </div>,
    document.body
  );

  return (
    <>
      <div className={styles.readAloudContainer}>
        <div className={styles.timeInfo}>
          <div className={styles.estimatedTime}>
            📖 <strong>Est. Reading Time:</strong> {estimatedTime} {estimatedTime === 1 ? 'minute' : 'minutes'}
            <span className={styles.subtitle}>(for thoughtful comprehension)</span>
          </div>
        </div>

        <div className={styles.timerSection}>
          <button
            onClick={startTimer}
            className={`${styles.btn} ${timerStarted ? styles.btnStop : styles.btnStart}`}
            title={timerStarted ? 'Stop timer' : 'Start timer'}
          >
            {timerStarted ? '⏹ Stop Timer' : '⏱️ Start Reading Timer'}
          </button>

          {timerStarted && (
            <button
              onClick={resetTimer}
              className={`${styles.btn} ${styles.btnReset}`}
              title="Reset timer"
            >
              🔄 Reset
            </button>
          )}
        </div>
      </div>
      
      {stickyCard}
    </>
  );
};

export default ReadAloud;
