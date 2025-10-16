# BahoAI Fine-Tuning Guide

## 🎯 Objective
Fine-tune GPT-4 to excel at:
1. Speaking, spelling, and writing fluent Kinyarwanda
2. Deep knowledge of Rwanda's health sector

---

## 📊 Data Collection Checklist

### Phase 1: Kinyarwanda Language Data (Target: 200-300 examples)

#### Health Conversations in Kinyarwanda
- [ ] Common symptoms (headache, fever, cough, etc.)
- [ ] Body parts terminology
- [ ] Medication instructions
- [ ] Disease names
- [ ] Preventive health advice
- [ ] Emergency situations
- [ ] Maternal and child health
- [ ] Mental health topics
- [ ] Nutrition and diet
- [ ] Traditional vs modern medicine

#### Sources:
1. **Rwanda Ministry of Health** - www.moh.gov.rw
   - Look for: Public health campaigns, brochures, educational materials
   
2. **Community Health Worker Materials**
   - CHW training manuals
   - Health education flip charts
   
3. **RapidSMS Health Programs**
   - SMS-based health campaigns
   - Mother and child health messages
   
4. **Local Health Radio Programs**
   - Transcripts from health shows on Radio Rwanda
   - BBC Gahuza health segments
   
5. **Kinyarwanda Medical Resources**
   - Medical terminology dictionaries
   - Health education booklets at health centers

### Phase 2: Rwanda Health Sector Knowledge (Target: 200-300 examples)

#### Health System Structure
- [ ] All referral hospitals (42 district hospitals)
- [ ] Health centers by district (500+ health centers)
- [ ] Private hospitals and clinics
- [ ] Pharmacies locations
- [ ] Emergency services (912, ambulances)
- [ ] Medical specialists and their locations

#### Health Programs & Policies
- [ ] Mutuelle de Santé (health insurance)
- [ ] Vaccination schedules (EPI program)
- [ ] Malaria prevention and treatment
- [ ] HIV/AIDS services
- [ ] TB treatment programs
- [ ] Family planning services
- [ ] Nutrition programs

#### Data Sources:
1. **HMIS (Health Management Information System)**
   - https://hmis.moh.gov.rw
   - Facility lists, health statistics
   
2. **Rwanda Biomedical Center (RBC)**
   - www.rbc.gov.rw
   - Disease prevention guidelines, immunization data
   
3. **WHO Rwanda**
   - Country health profile
   - Disease surveillance data
   
4. **Partners in Health Rwanda**
   - Health facility information
   - Community health programs
   
5. **Rwanda Demographic and Health Survey (RDHS)**
   - Comprehensive health data
   - Available at: www.statistics.gov.rw

---

## 🛠️ Data Preparation Process

### Step 1: Create Training Data Structure

Create a file called `training_data.jsonl` with this format:

```jsonl
{"messages": [{"role": "system", "content": "You are BahoAI, a health assistant for Rwanda. You speak fluent Kinyarwanda and have deep knowledge of Rwanda's health sector."}, {"role": "user", "content": "USER_QUESTION_IN_KINYARWANDA_OR_ENGLISH"}, {"role": "assistant", "content": "DETAILED_HELPFUL_RESPONSE"}]}
```

### Step 2: Data Quality Guidelines

Each example should:
- ✅ Be factually accurate
- ✅ Use natural, conversational Kinyarwanda
- ✅ Include specific Rwanda locations, hospitals, programs
- ✅ Be culturally sensitive
- ✅ Provide actionable advice
- ✅ Include emergency contact info when relevant
- ✅ Reference Rwandan health policies when applicable

### Step 3: Example Categories to Create

#### A. Symptom Assessment (40-50 examples)
- Headache, fever, cough, stomach pain, etc.
- Both Kinyarwanda and English versions
- Include when to seek emergency care

#### B. Hospital/Facility Information (50-60 examples)
- "Where is the nearest hospital in [District]?"
- "What are the operating hours of [Hospital]?"
- Emergency services information

#### C. Health Insurance (20-30 examples)
- Mutuelle de Santé procedures
- How to access care
- Payment categories

#### D. Disease-Specific Information (40-50 examples)
- Malaria prevention and treatment
- HIV/AIDS services
- TB treatment
- COVID-19 information
- Common childhood illnesses

#### E. Preventive Health (30-40 examples)
- Nutrition advice
- Vaccination schedules
- Hygiene practices
- Family planning

#### F. Mixed Language Conversations (20-30 examples)
- Code-switching between English and Kinyarwanda
- Technical terms in English with Kinyarwanda explanations

---

## 🚀 Fine-Tuning Process (OpenAI)

### Prerequisites
- OpenAI API account with payment method
- Minimum 50 examples (recommended 200-500)
- Cost estimate: $8-$100 depending on model and data size

### Step 1: Validate Your Data

```bash
# Install OpenAI CLI
pip install openai

# Validate training file
openai tools fine_tunes.prepare_data -f training_data.jsonl
```

### Step 2: Upload Training Data

```bash
# Upload your training file
openai api files.create -f training_data.jsonl -p fine-tune
```

### Step 3: Create Fine-Tuning Job

```bash
# For GPT-3.5-turbo (recommended to start)
openai api fine_tuning.jobs.create -t file-abc123 -m gpt-3.5-turbo

# For GPT-4 (more expensive, better results)
openai api fine_tuning.jobs.create -t file-abc123 -m gpt-4o-mini
```

### Step 4: Monitor Training

```bash
# Check status
openai api fine_tuning.jobs.retrieve -i ftjob-abc123

# List all fine-tuning jobs
openai api fine_tuning.jobs.list
```

### Step 5: Use Your Fine-Tuned Model

Update `openai_integration.R`:
```r
model = "ft:gpt-3.5-turbo:your-org:bahoai:abc123"  # Your fine-tuned model ID
```

---

## 💰 Cost Estimation

### OpenAI Fine-Tuning Costs (as of 2024)

**GPT-3.5-turbo:**
- Training: $0.008 per 1K tokens
- Usage: $0.012 per 1K tokens (input), $0.016 per 1K tokens (output)
- **Estimated for 300 examples**: $8-$20

**GPT-4o-mini:**
- Training: $0.03 per 1K tokens
- Usage: Slightly higher than GPT-3.5
- **Estimated for 300 examples**: $30-$100

---

## 📝 Data Collection Template

Create a spreadsheet with these columns:

| ID | Language | Category | User Message | Assistant Response | Source | Verified |
|----|----------|----------|--------------|-------------------|--------|----------|
| 1 | Kinyarwanda | Symptom | Ndwaye umutwe | [Detailed response] | MOH | ✅ |
| 2 | English | Hospital | Hospitals in Kigali | [Detailed response] | HMIS | ✅ |

---

## 🔄 Continuous Improvement

### After Fine-Tuning:
1. Test the model extensively
2. Collect real user conversations
3. Identify areas for improvement
4. Add new training examples
5. Re-train the model (iterative process)

### Metrics to Track:
- Response accuracy in Kinyarwanda
- Factual correctness about Rwanda health system
- User satisfaction ratings
- Language quality scores

---

## 📚 Key Resources

### Kinyarwanda Language:
- Kinyarwanda-English dictionaries
- Language learning apps (Duolingo, Memrise)
- Rwanda Academy of Language and Culture (RALC)

### Health Data:
- Rwanda Ministry of Health: www.moh.gov.rw
- HMIS Portal: https://hmis.moh.gov.rw
- Rwanda Biomedical Center: www.rbc.gov.rw
- National Institute of Statistics Rwanda: www.statistics.gov.rw

### Technical:
- OpenAI Fine-Tuning Guide: https://platform.openai.com/docs/guides/fine-tuning
- OpenAI Community Forum: community.openai.com

---

## 🎯 Timeline

**Week 1-2:** Data Collection
- Research and gather resources
- Compile hospital and health facility data
- Collect Kinyarwanda health conversations

**Week 3-4:** Data Preparation
- Format data into JSONL
- Quality assurance and verification
- Validation with OpenAI tools

**Week 5:** Fine-Tuning
- Upload data
- Start fine-tuning job
- Monitor progress

**Week 6+:** Testing & Iteration
- Test model extensively
- Gather feedback
- Plan next iteration

---

## 🚨 Important Considerations

### Medical Accuracy:
- **Consult with Rwandan healthcare professionals** to verify all medical information
- Include disclaimers that AI should not replace professional medical advice
- Ensure emergency information (like 912) is always accurate

### Cultural Sensitivity:
- Respect traditional medicine practices
- Be aware of health taboos and stigmas
- Use appropriate language for sensitive topics

### Legal & Ethical:
- Comply with Rwanda's data protection laws
- Don't provide diagnoses, only general health information
- Always recommend seeing a healthcare provider for serious conditions

---

## 🤝 Next Steps

1. **Start Small**: Begin with 50-100 high-quality examples
2. **Test Frequently**: Validate model responses with native Kinyarwanda speakers
3. **Iterate**: Fine-tuning is an ongoing process
4. **Get Feedback**: Work with healthcare workers to improve responses
5. **Scale Up**: Gradually increase training data as you see improvements

---

## 📞 Getting Help

If you need assistance:
- OpenAI Support: help.openai.com
- Rwanda Health Sector: Contact MOH or RBC
- Kinyarwanda Experts: Rwanda Academy of Language and Culture

---

*Good luck with your fine-tuning journey! This will make BahoAI truly exceptional.* 🇷🇼✨

