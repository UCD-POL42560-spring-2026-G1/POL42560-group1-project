#Gemini generate this code for the async sentiment analysis using deepseek, we modified the prompt template to be more specific to the IEO sentiment analysis task and added more detailed instructions for the model to follow. We also added error handling to log any issues that arise during processing, and we increased the max_tokens to ensure the model has enough room to provide detailed reasoning in its response.


import asyncio
import pandas as pd
import re
import os
from dotenv import load_dotenv
from huggingface_hub import AsyncInferenceClient
from tqdm.asyncio import tqdm

# --- 1. SETUP & CREDENTIALS ---
load_dotenv()
# Ensure you have HF_TOKEN and ENDPOINT_URL in the .env file
HF_TOKEN = os.getenv("HF_TOKEN")
ENDPOINT_URL = os.getenv("ENDPOINT_URL")
INPUT_CSV = "data/temp/neo_geo_class_sentences.csv" #change path to data/temp/ieo_sen_gt.csv for sample run
OUTPUT_CSV = "data/temp/deepseek_ieo_sentiment_results_final_full.csv" #change path to data/temp/ieo_sentiment_results_v4.csv for sample run
TEXT_COLUMN = "text"

client = AsyncInferenceClient(base_url=ENDPOINT_URL, token=HF_TOKEN)

# --- 2. UPDATED PROMPT TEMPLATE (SENTIMENT FOCUSED) ---
example = """
Example 1: 
Text: We believe that the deepening of economic interdependence under the framework of the WTO remains the surest path to global prosperity and peace.
Sentiment: Positive
Reasoning: Expresses trust in existing multilateral institutions (WTO) and the benefits of globalization.

Example 2:
Text: The current international financial architecture is morally bankrupt, favoring the wealthy while trapping developing nations in a cycle of debt and underdevelopment.
Sentiment: Negative
Reasoning: Expresses structural grievance against the 'financial architecture' and describes the order as unfair/unjust.

Example 3:
Text: It must be frankly said that such declarations are not in harmony with the actions of the United States Government and in particular with the breaking of the aforementioned trade agreement with the USSR, which can only be evaluated as an act designed to bring about a further deterioration of relations between the USSR and the United States.
Sentiment: Negative
Reasoning: Declarations are not in harmony with actions, suggesting dissatisfaction with the current state of affairs
"""
#remove rule-based trade in positive, satifaction with the global.......
PROMPT_TEMPLATE = """You are an expert political scientist. 
Task: Analyze the sentiment of the following UN speech text toward the "International Economic Order" (IEO).

Sentiment Categories:
1. Positive: Satisfaction with globalization, multilateralism, WTO/IMF/World Bank, and the belief that the current order produces mutual benefits.
2. Negative: Grievances regarding structural inequality, unfair trade terms, debt burdens, 'economic imperialism', or calls for reform of the 'unjust' order. Expresses skepticism or dissatisfaction with the current global economic system.


Instruction: 
analyze the sentiment and stricly provide only Positive and Negative only.
- Sentiment: [Positive/Negative]


Output Format:
Sentiment: [Positive/Negative]


---
### EXAMPLES
{example}
---

<text_to_analyze>
{text}
</text_to_analyze>"""

# --- 3. UPDATED ASYNC ENGINE ---
async def process_sentence(sentence, semaphore):
    async with semaphore:
        try:
            # vLLM requires the exact model ID from your endpoint
            MODEL_ID = "deepseek-ai/DeepSeek-R1-Distill-Qwen-32B"
            
            # Use chat_completion for the vLLM /v1/chat/completions route
            response = await client.chat_completion(
                model=MODEL_ID,
                messages=[
                    {"role": "user", "content": PROMPT_TEMPLATE.format(example=example, text=sentence)}
                ],
                max_tokens=3000, # Increased so <think> tags have room to finish
                temperature=0.6,
                top_p=0.95
            )
            
            full_text = response.choices[0].message.content
            
            # Extract reasoning from R1 <think> tags (with fallback)
            reasoning_match = re.search(r'<think>(.*?)</think>', full_text, re.DOTALL)
            if reasoning_match:
                reasoning_text = reasoning_match.group(1).strip()
            else:
                # Fallback: if tags are missing, take the first 500 chars as the 'thought'
                reasoning_text = full_text.split("Sentiment:")[0].strip() if "Sentiment:" in full_text else "No reasoning found."

            # Extract Data using hardened Regex
            # Note: We use .strip() and .capitalize() for cleaner CSV data
            sentiment_match = re.search(r'Sentiment:\s*(Positive|Negative|Neutral)', full_text, re.IGNORECASE)

            
            return {
                "reasoning": reasoning_text,
                "sentiment": sentiment_match.group(1).capitalize() if sentiment_match else "Neutral",

            }
        except Exception as e:
            # Logs the specific error into the CSV so you can debug later
            return {
                "reasoning": f"Error: {str(e)}", 
                "sentiment": "Error"
            }

async def main():
    df = pd.read_csv(INPUT_CSV)
    sentences = df[TEXT_COLUMN].tolist()
    semaphore = asyncio.Semaphore(25)
    
    tasks = [process_sentence(s, semaphore) for s in sentences]
    results = await tqdm.gather(*tasks)
    
    # Mapping results back to the DataFrame
    df['r1_reasoning'] = [r['reasoning'] for r in results]
    df['ieo_sentiment'] = [r['sentiment'] for r in results]

    
    df.to_csv(OUTPUT_CSV, index=False)
    print(f"Sentiment Analysis Complete. Saved to {OUTPUT_CSV}")

if __name__ == "__main__":
    asyncio.run(main())