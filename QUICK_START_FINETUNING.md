# 🚀 Quick Start: Fine-Tuning BahoAI

This is a condensed, action-oriented guide to get you started with fine-tuning immediately.

---

## ⚡ TL;DR - What You Need to Do

1. **Collect 200-500 examples** of health conversations in Kinyarwanda and English
2. **Format them as JSONL** (see template)
3. **Upload to OpenAI** and start fine-tuning
4. **Test and iterate** based on results

**Estimated Time**: 4-6 weeks
**Estimated Cost**: $50-$200 (depending on data size and model choice)

---

## 📝 Step-by-Step Action Plan

### Week 1-2: Data Collection 🎯

**Day 1-3: Get Emergency & Hospital Data**
```
✅ Task: Create a spreadsheet with ALL hospitals in Rwanda
   - Visit: https://hmis.moh.gov.rw
   - Download: Hospital directory
   - Format: Name, Location, Phone, Services, Insurance Accepted

✅ Task: Create 20 emergency response examples
   - Format: User asks about emergency → AI provides immediate action + 912 + nearest hospital
```

**Day 4-7: Common Health Issues**
```
✅ Task: Create 40 examples for common symptoms:
   - Headache (umutwe) - 5 examples
   - Fever (umuriro) - 5 examples
   - Stomach pain (kurwara inda) - 5 examples
   - Cough (inkorora) - 5 examples
   - Malaria symptoms - 5 examples
   - Child illness - 10 examples
   - Pregnancy questions - 5 examples
   
   For EACH: Write in Kinyarwanda AND English versions
```

**Day 8-10: Health Insurance (Mutuelle)**
```
✅ Task: Create 20 examples about Mutuelle de Santé:
   - How to register - 5 examples
   - How to use it - 5 examples
   - Payment categories - 5 examples
   - Where it's accepted - 5 examples
   
   Source: http://www.rbc.gov.rw (search for Mutuelle information)
```

**Day 11-14: Vaccinations & Maternal Health**
```
✅ Task: Create 30 examples:
   - Child vaccination schedule - 10 examples
   - Pregnancy care (ANC) - 10 examples
   - Family planning - 10 examples
   
   Source: MOH EPI program guidelines, Maternal health guidelines
```

### Week 3-4: Disease-Specific Information 💊

**Day 15-18: Major Diseases**
```
✅ Malaria - 15 examples
   - Symptoms, prevention, treatment, where to get tested
   
✅ HIV/AIDS - 15 examples
   - Testing locations, treatment, prevention, destigmatizing language
   
✅ TB - 10 examples
   - Symptoms, free treatment, where to go
   
✅ COVID-19 - 10 examples
   - Vaccination sites, symptoms, prevention
```

**Day 19-21: Nutrition & Child Health**
```
✅ Task: Create 25 examples:
   - Child nutrition (0-5 years) - 15 examples
   - Adult nutrition - 5 examples
   - Breastfeeding - 5 examples
```

**Day 22-28: Fill Gaps & Quality Check**
```
✅ Review all examples with:
   - Native Kinyarwanda speaker
   - Healthcare professional (if possible)
   
✅ Add 50+ more examples in weak areas

✅ Target: 200-300 high-quality examples minimum
```

### Week 5: Format & Upload 📤

**Day 29-30: Format Your Data**

1. **Install OpenAI CLI**:
```bash
pip install openai
```

2. **Set your API key**:
```bash
# Windows PowerShell
$env:OPENAI_API_KEY="your-api-key-here"

# Or add to .env file
echo OPENAI_API_KEY=your-api-key-here >> .env
```

3. **Use the template format** (`training_data_template.jsonl`):
```jsonl
{"messages": [{"role": "system", "content": "You are BahoAI, a health assistant for Rwanda. You speak fluent Kinyarwanda and have deep knowledge of Rwanda's health sector."}, {"role": "user", "content": "USER_QUESTION"}, {"role": "assistant", "content": "AI_RESPONSE"}]}
```

4. **Validate your data**:
```bash
openai tools fine_tunes.prepare_data -f training_data.jsonl
```

**Day 31: Upload & Start Fine-Tuning**

1. **Upload training file**:
```bash
openai api files.create -f training_data.jsonl -p fine-tune
```
*Note the file ID returned (e.g., `file-abc123xyz`)*

2. **Start fine-tuning job**:

**Option A: GPT-3.5-turbo (Cheaper, Faster)**
```bash
openai api fine_tuning.jobs.create -t file-abc123xyz -m gpt-3.5-turbo
```
- Cost: ~$8-$40
- Training time: 10-30 minutes
- Best for: Getting started, testing

**Option B: GPT-4o-mini (Better Quality)**
```bash
openai api fine_tuning.jobs.create -t file-abc123xyz -m gpt-4o-mini
```
- Cost: ~$30-$100
- Training time: 20-60 minutes
- Best for: Production use

3. **Monitor progress**:
```bash
# Check status (replace with your job ID)
openai api fine_tuning.jobs.retrieve -i ftjob-abc123

# Or list all jobs
openai api fine_tuning.jobs.list
```

You'll receive an email when training completes!

### Week 6: Test & Deploy 🧪

**Day 32-35: Testing**

1. **Get your fine-tuned model ID** from the completion email
   - Format: `ft:gpt-3.5-turbo:your-org:bahoai:abc123`

2. **Update `openai_integration.R`**:
```r
# Find this line (around line 20):
model = "gpt-4",

# Replace with your fine-tuned model:
model = "ft:gpt-3.5-turbo:your-org:bahoai:abc123",
```

3. **Test extensively**:
```
✅ Test in Kinyarwanda - 20 questions
✅ Test in English - 20 questions
✅ Test emergency scenarios - 10 questions
✅ Test hospital information - 10 questions
✅ Test with native speakers - Get feedback
✅ Test edge cases - Unusual questions
```

4. **Document issues**:
   - What responses are incorrect?
   - What Kinyarwanda phrases are awkward?
   - What information is missing?

**Day 36-38: Iterate**

Based on testing, create 50-100 MORE examples focusing on weak areas, then:
1. Append to `training_data.jsonl`
2. Upload new file
3. Start new fine-tuning job
4. Test again

**Day 39-42: Deploy**

1. **Update `.env`** with new model ID
2. **Test on shinyapps.io deployment**
3. **Gather user feedback**
4. **Plan next iteration**

---

## 💰 Cost Breakdown

### OpenAI Fine-Tuning Costs (Approximate)

**GPT-3.5-turbo:**
| Data Size | Training Cost | Usage Cost (per 1K tokens) |
|-----------|---------------|---------------------------|
| 100 examples (~50K tokens) | ~$4 | Input: $0.012, Output: $0.016 |
| 300 examples (~150K tokens) | ~$12 | Input: $0.012, Output: $0.016 |
| 500 examples (~250K tokens) | ~$20 | Input: $0.012, Output: $0.016 |

**GPT-4o-mini:**
| Data Size | Training Cost | Usage Cost (per 1K tokens) |
|-----------|---------------|---------------------------|
| 100 examples | ~$15 | Slightly higher than GPT-3.5 |
| 300 examples | ~$45 | Slightly higher than GPT-3.5 |
| 500 examples | ~$75 | Slightly higher than GPT-3.5 |

**Recommendation**: Start with GPT-3.5-turbo and 100-200 examples (~$10-15)

---

## 🎯 Priority Examples (Create These First)

### Critical Priority (Do First - Day 1-7)
1. ✅ Emergency situations (20 examples)
2. ✅ Hospital directory for all districts (50 examples)
3. ✅ Common symptoms: fever, headache, cough, stomach pain (30 examples)
4. ✅ Child health emergencies (15 examples)

### High Priority (Day 8-14)
5. ✅ Mutuelle de Santé (20 examples)
6. ✅ Child vaccinations (15 examples)
7. ✅ Pregnancy care (15 examples)
8. ✅ Malaria (15 examples)

### Medium Priority (Day 15-21)
9. ✅ HIV/AIDS information (15 examples)
10. ✅ TB information (10 examples)
11. ✅ Nutrition (15 examples)
12. ✅ Family planning (10 examples)

### Lower Priority (Day 22-28)
13. ✅ Mental health (10 examples)
14. ✅ Traditional medicine (5 examples)
15. ✅ Specific diseases (15 examples)
16. ✅ Medication information (10 examples)

**Total: 250 examples minimum**

---

## ✅ Quality Checklist (Use for EVERY Example)

Before adding an example to your training data:

- [ ] **Accurate**: Verified with official source (MOH, RBC, HMIS)
- [ ] **Natural Kinyarwanda**: Reviewed by native speaker
- [ ] **Complete**: Includes when to see a doctor, emergency contacts
- [ ] **Safe**: Doesn't provide diagnosis, just guidance
- [ ] **Specific**: Uses Rwanda-specific info (hospitals, programs)
- [ ] **Emergency info**: Includes 912 for emergencies when relevant
- [ ] **Actionable**: Clear next steps for the user
- [ ] **Culturally sensitive**: Respectful, non-judgmental

---

## 🚨 Common Mistakes to Avoid

❌ **Don't**: Copy generic medical information from the internet
✅ **Do**: Use Rwanda-specific sources (MOH, RBC, HMIS)

❌ **Don't**: Use Google Translate for Kinyarwanda
✅ **Do**: Work with native speakers or verified translations

❌ **Don't**: Provide medical diagnoses
✅ **Do**: Provide general health information and when to see a doctor

❌ **Don't**: Skip testing with real users
✅ **Do**: Test extensively before deploying

❌ **Don't**: Forget emergency information
✅ **Do**: Always include 912 and nearest hospital info for serious symptoms

❌ **Don't**: Use inconsistent terminology
✅ **Do**: Create a glossary of medical terms in Kinyarwanda

---

## 📊 Track Your Progress

Create a simple tracking sheet:

| Week | Goal | Status | Examples Created | Notes |
|------|------|--------|------------------|-------|
| 1 | Emergency & hospitals | ⬜ In Progress | 0/70 | |
| 2 | Mutuelle & vaccinations | ⬜ Not Started | 0/50 | |
| 3 | Diseases | ⬜ Not Started | 0/65 | |
| 4 | Fill gaps & QA | ⬜ Not Started | 0/65 | |
| 5 | Format & upload | ⬜ Not Started | - | |
| 6 | Test & iterate | ⬜ Not Started | - | |

**Target: 250+ examples**

---

## 🎓 Learning Resources

### Quick Tutorials:
1. **OpenAI Fine-Tuning Tutorial** (30 min):
   https://platform.openai.com/docs/guides/fine-tuning

2. **JSONL Format** (10 min):
   https://jsonlines.org/

3. **Preparing Training Data** (20 min):
   https://platform.openai.com/docs/guides/fine-tuning/preparing-your-dataset

### Video Tutorials:
- Search YouTube: "OpenAI fine-tuning tutorial"
- Watch: OpenAI developer conference fine-tuning sessions

---

## 💡 Pro Tips for Success

1. **Start small**: 50-100 examples, then iterate
2. **Test early**: Don't wait until you have 500 examples
3. **Document sources**: Keep track of where info came from
4. **Version control**: Name files like `training_data_v1.jsonl`, `v2`, etc.
5. **Backup everything**: Store training data in multiple places
6. **Get feedback**: Show to healthcare workers and native speakers
7. **Stay organized**: Use the CSV template to collect data before converting to JSONL
8. **Be patient**: Quality > quantity always

---

## 🎯 Your First Action (Do This Now!)

1. **Open `data_collection_template.csv`**
2. **Fill in 5 emergency examples** (should take 30 minutes)
3. **Show them to a native Kinyarwanda speaker** for feedback
4. **Revise based on feedback**
5. **Repeat until you have 20 good emergency examples**

This will give you a feel for the process and quality level needed.

---

## 📞 Need Help?

**Technical Issues:**
- OpenAI Discord: https://discord.com/invite/openai
- OpenAI Forum: https://community.openai.com

**Rwanda Health Info:**
- Ministry of Health: info@moh.gov.rw
- RBC Website: www.rbc.gov.rw

**Language Help:**
- Rwanda Academy of Language: www.ralc.gov.rw
- Find Kinyarwanda tutors on: iTalki, Preply

---

## 🎉 Success Metrics

You'll know your fine-tuned model is working when:

✅ Native speakers say "This sounds natural!"
✅ Kinyarwanda responses have proper grammar and spelling
✅ Hospital information is accurate and complete
✅ Emergency responses are appropriate and helpful
✅ Users feel the AI "understands" Rwandan health context
✅ The AI correctly uses Rwandan health terminology
✅ Responses are culturally sensitive and appropriate

---

**Ready to start? Open that `data_collection_template.csv` and create your first 5 examples!** 🚀🇷🇼

Good luck! You're about to make BahoAI incredibly powerful for Rwanda! 💪✨

