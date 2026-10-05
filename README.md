# Toyota UK Used-Car Analysis 🚙

## Project Overview

This repository hosts the Power BI Desktop file (`ToyotaUKlistings.pbix`) and SQL Server queries (`Toyota_Queries.sql`) for an analysis of Toyota listings in the UK used-car market: which models dominate, how well each holds its value, and what a hybrid costs compared with the petrol version of the same car.

---

## 🔑 Headline Finding

**Toyota's small cars dominate UK used listings and hold their value: the Yaris keeps 72.5% of its price at 4-6 years, while the RAV4 loses over 15,000 per car. Hybrids cost 20-38% more than the petrol version of the same model.**

### Model mix (6,738 listings)

- **Yaris (31.5%) and Aygo (29.1%)** make up **60.6%** of all Toyota listings.
- By body type, city cars are 60.7% of listings, family cars 19.8%, SUVs 14.9%, and everything else about 4.6%.

| Body type | Share | Avg price | Avg mpg | Avg road tax |
|---|---|---|---|---|
| City car | 60.7% | 9,271 | 63.3 | 88 |
| Family car | 19.8% | 15,211 | 71.3 | 72 |
| SUV | 14.9% | 20,220 | 58.1 | 120 |
| MPV / van | 2.0% | 13,899 | 46.3 | 152 |
| Pickup | 1.3% | 21,504 | 33.8 | 261 |
| Sports | 1.3% | 24,261 | 35.2 | 175 |

### Value retention (price at 4-6 years vs nearly new)

| Model | Nearly new | 4-6 years old | Retained |
|---|---|---|---|
| Prius | 24,930 | 18,163 | 72.9% |
| Yaris | 12,938 | 9,378 | 72.5% |
| Aygo | 9,884 | 6,565 | 66.4% |
| RAV4 | 31,624 | 16,416 | 51.9% |

- The Yaris has the strongest evidence behind it (421 nearly-new and 601 older listings).
- The RAV4 loses about 15,200 per car, the most in absolute terms. A model redesign may be part of the reason, but the data can't prove it.
- Only models with at least 30 listings in both age groups are shown.

### Hybrid vs petrol (same model, cars from 2017)

| Model | Hybrid price | Petrol price | Hybrid premium | Hybrid mpg | Petrol mpg |
|---|---|---|---|---|---|
| Yaris | 13,300 | 11,113 | +20% | 77.9 | 54.1 |
| Auris | 15,670 | 11,376 | +38% | 73.7 | 57.0 |
| C-HR | 21,783 | 17,072 | +28% | 73.1 | 45.6 |
| Corolla | 23,146 | 17,992 | +29% | 74.8 | 39.2 |
| RAV4 | 25,058 | 19,424 | +29% | 54.3 | 44.1 |

The average premium across the five models is **28.5%**. Hybrids also have higher listed mpg and lower road tax in all five models.

---

## 🧩 Key Features

📊 Share of listings by model and body type

📉 Value retention at 4-6 years by model

🔋 Hybrid vs petrol price, mpg and tax for the same model

🔍 Slicers for fuel type, transmission, body type and model

---

## 🗂️ Data

- **Source:** "100,000 UK Used Car Data Set" on Kaggle (by adityadesai13), file `toyota.csv`.
- **Contents:** scraped UK used-car listings with model, year, price, transmission, mileage, fuel type, road tax, mpg and engine size.
- **Currency:** UK listings, so prices are presumably in pounds.

---

### 🛠️ Tools Used

- SQL Server (SSMS): data cleaning and analysis
- Power BI Desktop
- DAX (Measures & Calculations)

### SQL Highlights (`Toyota_Queries.sql`)

| Section | Purpose |
|---|---|
| T01 Model mix | Listings, share, average price and mpg by model (window functions) |
| T02 Value retention | Nearly-new vs 4-6-year-old prices by model, with sample-size guards (CTEs) |
| T03 Hybrid vs petrol | Same-model comparison of price, mpg, tax and mileage for 2017+ cars |
| T04 Body type | Groups models into city, family, SUV, MPV, pickup and sports segments |

### Data Model Highlights (DAX)

- `Age = CALCULATE(MAX(cars[year]), ALL(cars)) - cars[year]`
- `Retention 5yr vs New`: average price at ages 4-6 ÷ average price at ages 0-1, shown only where both groups have at least 30 listings.
- `Hybrid Premium`: hybrid price premium calculated model by model and then averaged, so the result isn't distorted by a different model mix.
- `Share of Toyota`: share of listings using `ALLSELECTED`, so each body type divides by the whole Toyota total.
- `Body Type`: calculated column grouping models into car types.

Page filter: brand is Toyota.

---

## ⚠️ Limitations

1. **Listings, not sales.** "Best-selling" here means most listed in the UK used market. It is not global new-car sales.
2. **Retention is not true depreciation.** It compares different cars at different ages. Redesigns (such as a new RAV4 generation) can move the numbers.
3. **Hybrid premium is an indication.** The comparison covers cars from 2017 onward but doesn't control for model year within that range, and some petrol samples are small (for example 33 RAV4s).
4. **mpg is the listed figure**, not real-world economy. Road tax depends on registration date and UK tax rules.
5. **Body types are my grouping.** Models were assigned to segments by judgment.
6. **Thin models are excluded or flagged.** Models with few listings (Camry, Supra, IQ and others) don't appear in the retention analysis, and the Prius result rests on 43 nearly-new listings.

---

## 🚀 Getting Started

To view and interact with the Power BI file:

1. **Download** the `Toyota UKlistings.pbix` file from this repository.
2. **Install** [Power BI Desktop](https://powerbi.microsoft.com/desktop/).
3. **Open** the file in Power BI Desktop.

To rerun the SQL:

1. Download the CSV from the Kaggle dataset linked above.
2. Import `toyota.csv` into SQL Server (use `int` for price, mileage and tax, since `smallint` overflows on prices above 32,767).
3. Run `Toyota_Queries.sql` from top to bottom.

---

