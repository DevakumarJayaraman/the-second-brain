import React from "react";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";

// Dynamic folder configuration - add new folders here
const docFolders = [
  {
    name: "Technology",
    icon: "💻",
    description: "DevOps, Architecture, Programming, and System Design",
    path: "/Technology/"
  },
  {
    name: "Finance",
    icon: "💰",
    description: "Investment strategies, Banking, and Financial planning",
    path: "/Finance/"
  },
  {
    name: "Personal Development",
    icon: "🚀",
    description: "Self-improvement, Career growth, and Soft skills",    
    path: "/Personal-Development/"
  }
];

export default function Home() {
  return (
    <Layout
      title="The Second Brain"
      description="Your personal knowledge base for continuous learning and reference"
    >
      <main className="homepage-container">
        <div className="homepage-hero">
          <p>Your personal knowledge base for continuous learning and reference</p>
        </div>
        <div className="cards-grid">
          {docFolders.map((folder) => (
            <Link key={folder.name} to={folder.path} className="doc-card">
              <span className="card-icon">{folder.icon}</span>
              <h2 className="card-title">{folder.name}</h2>
              <p className="card-description">{folder.description}</p>
            </Link>
          ))}
        </div>
      </main>
    </Layout>
  );
}
