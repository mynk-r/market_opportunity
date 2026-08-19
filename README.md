# India Market Opportunity Engine

### State × Industry Market Intelligence & Expansion Prioritization

> A data-driven decision-support engine that identifies attractive Indian state–industry markets by combining startup activity, economic strength, industry growth, digital penetration, market concentration and machine-learning-based growth potential.

---

## 📌 Overview

Businesses entering or expanding in India face a fundamental market-selection problem:

> **Which states and industries should we prioritize, and why?**

The India Market Opportunity Engine addresses this problem by integrating multiple publicly available Indian datasets into a unified state × industry analytical framework.

The engine evaluates markets across multiple dimensions:

- Startup ecosystem strength
- Industry growth
- Economic strength
- Startup intensity
- Industry concentration
- Digital penetration
- Market underpenetration
- Future growth potential

The final system combines:

**SQL + Python + Statistical Analysis + Feature Engineering + Opportunity Scoring + Random Forest ML + BI Dashboarding**

to transform raw data into actionable market-expansion recommendations.

---

# 🎯 Business Objective

The primary objective is to answer:

> **"For a given industry and business strategy, which Indian states represent the most attractive markets for expansion?"**

The engine is designed to support three strategic scenarios:

### 1. Balanced Strategy

Prioritizes a combination of:

- Economic strength
- Industry presence
- Industry growth
- Startup momentum
- Underpenetration

### 2. Growth Strategy

Prioritizes markets with:

- Strong industry growth
- Startup momentum
- Economic growth
- Emerging market potential

### 3. Market Entry Strategy

Prioritizes markets where:

- Economic fundamentals are attractive
- Industry potential exists
- Current penetration is relatively low
- Competitive concentration may provide room for entry

---

## 📊 Data Sources:

The project combines multiple datasets to create a state–industry panel.

### 1. Startup Ecosystem Data (DPIIT): 
Startup data contains information on recognized startups across:
- State
- Industry
- Year
- Startup count
This forms the core of the market activity analysis.

### 2. NSVA — Net State Value Added (RBI DBIE)
NSVA is used as a proxy for state-level economic output. It enables the engine to distinguish between:
- Large economies with relatively strong startup ecosystems
- Large economies with relatively weak startup penetration
- Smaller economies with rapidly developing startup ecosystems

### 3. Internet Penetration (WORLD BANK)
Internet penetration is used as a digital-market readiness indicator. It helps capture the underlying digital accessibility of a market.

### 4. Population (WORLD BANK)
Population is used to contextualise:
- Market scale
- Startup activity
- Economic output
- Digital penetration

---

## Repository Structure

```text
india-market-opportunity-engine/
├── 00_clean.ipynb
│
├── engine/
│   ├── 01_EDA.ipynb
│   ├── 02_Feature.ipynb
│   ├── 03_Opportunity.ipynb
│   ├── 04_Explainability.ipynb
│   └── 05_ML.ipynb
│
├── data/
│   ├── raw/
│   │   ├── india_startup_master_dataset.csv
│   │   ├── internet_penetration.csv
│   │   ├── nsva_data.csv
│   │   ├── population.csv
│   │   └── startups_dpiit_2016_2025.csv
│   │
│   ├── processed/
│   │   ├── engine_latest_data.csv
│   │   ├── engine_master_data.csv
│   │   ├── india_market_opportunity_engine.csv
│   │   ├── opportunity_engine.csv
│   │   ├── opportunity_engine_final.csv
│   │   └── top_market_opportunities.csv
│   │
│   └── ML/
│       ├── india_market_opportunity_engine.csv
│       └── ml_growth_predictions.csv
│
├── sql/
│   ├── 01_database_setup.sql
│   ├── 02_business_analysis.sql
│   └── 03_opportunity_engine.sql
│
├── dashboard/
│   └── [Tableau / Streamlit files - Coming Soon]
│
└── README.md
```

---

# 🧩 Project Architecture

The project follows an end-to-end analytics pipeline:

```text
                    RAW DATA
                       │
                       ▼
             DATA CLEANING & MERGING
                       │
                       ▼
                MASTER DATASET
                       │
              ┌────────┴────────┐
              ▼                 ▼
             SQL              Python
          ANALYSIS         EDA & Features
              │                 │
              └────────┬────────┘
                       ▼
              FEATURE ENGINEERING
                       │
          ┌────────────┴────────────┐
          ▼                         ▼
   OPPORTUNITY ENGINE          ML MODULE
          │                         │
          │                    Random Forest
          │                         │
          ▼                         ▼
  Market Attractiveness       Growth Probability
          │                         │
          └────────────┬────────────┘
                       ▼
             FINAL MARKET ENGINE
                       │
                       ▼
               TABLEAU/ STREAMLIT
                 (Coming Soon)
