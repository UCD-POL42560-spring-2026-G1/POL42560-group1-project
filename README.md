# 🌍 The Grammar of Commerce
### *An Interpretable LLM Analysis of Trade Imbalances and Sentiment in Diplomatic Discourse*

This repository contains the research pipeline and analytical framework for **POL42560: AI and Large Language Models** (Spring Trimester 2026) at the **School of Politics and International Relations, University College Dublin**.

**Authors:** Luisa Feigl, Ultan Gannon, Tharanut Koonyotying, Xuenan Tian

---

## 📖 Project Overview
This study operationalizes Edward Luttwak’s "Grammar of Commerce" by analyzing the relationship between structural trade imbalances and diplomatic rhetoric. Utilizing a high-performance, reasoning-trace LLM (**DeepSeek-R1-Distill-Qwen-32B**), we scale the analysis of the **UN General Debate Corpus (UNGDC)** to identify how economic dissatisfaction manifests as diplomatic revisionism.

---

## 🚀 Research Pipeline

The workflow is divided into four distinct phases to ensure both scale and interpretability:
 
1.  **Lexical Filtering:** Application of custom geoeconomic lexicons (`Econ_main`) to isolate economic and geopolitical signaling.
2.  **Human-in-the-loop Validation:** * Creation of  **Gold Standard** via expert manual annotation.
    * Establishment of a rigorous **Semantic Validation** protocol (Cosine Similarity) to audit AI reasoning traces.
3.  **Transformers Performance Comparison:** Comparative benchmarking across 4 state-of-the-art architectures.
    * **Interpretable LLM:** Zero-shot and Few-shot sentiment extraction using **DeepSeek-R1-Distill-Qwen-32b**, providing transparent reasoning logs for every classification.
4.  **Data Harmonization:** Integration of the **UNGDC** speech data with **Our World in Data** trade balance data.
5.  **Statistical Modeling:** OLS and Time-Fixed Effects regressions linking trade volatility to "Negative (Revitionist)" vs. " Positive(Status Quo)" sentiment.

---



## 🛠 Installation & Setup

### **1. Clone the Repository**

```bash
git clone https://github.com/UCD-POL42560-spring-2026-G1/POL42560-group1-project
cd POL42560-group1-project
```

### **2. Environment Configuration**
Ensure you have Python 3.9+ installed.
```Bash
pip install -r requirements.txt
```

### **3. Data Management**

Due to file size constraints, raw and temp datasets are excluded from this repo.

The data sets could be found in the link in the **Documentation & Resource** section below


---

## 📊 Key Results & Visualizations

**Model Performance**: Confusion matrices and heatmaps comparing Transformer accuracy vs. LLM reasoning capabilities (F1 Score: 0.95).

**Semantic Alignment**: Boxplots demonstrating the 0.5 Cosine Similarity in reasoning between Human Experts and DeepSeek-R1.

**Sentiment Trends**: Regional visualizations showing negative and positive sentiment in diplomatic discourse.

**Regression Outputs**: Evidence of the " Negative (Revisionist) Shift" in states experiencing structural trade dissatisfaction.

---

## 📜 Documentation & Resources

Comprehensive guides for replication are located in the docs/ folder:

**Econ Codebook**: Guidelines for identifying geoeconomic markers.

**Sentiment Codebook**: Classification logic for Supportive, Neutral, and Critical stances.


🔗 [External Link to Google Drive](https://drive.google.com/drive/folders/13tM2ftKmXE5KTu4aWuIadW9n9yownwPc?usp=sharing)]: Access the full datasets

🔗 [External Link to Google Drive](https://drive.google.com/file/d/1vmEgg8VL-ew-CeQUDot7vfKC46dyQR2n/view?usp=sharing)]: Access the fine-tuned model weights.
