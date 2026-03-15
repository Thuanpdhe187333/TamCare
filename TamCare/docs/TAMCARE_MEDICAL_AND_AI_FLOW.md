# TamCare — Medical Visit Storage & AI Nutrition Flow

## Data flow architecture

```
Elderly (User) → ElderlyProfile (ProfileID)
                      ↓
                 VisitRecords (VisitID)
                      ↓
        ┌─────────────┼─────────────┬─────────────────┐
        ↓             ↓              ↓                  ↓
 MedicalHistory  TestResults  Prescriptions    HealthMetrics
 (per condition) (per test)   (per medication) (per metric)
```

**AI nutrition flow:**

```
MedicalHistory (ProfileID, DiseaseCode)
       → DiseaseProtocol / Diseases (DiseaseCode → name, rules)
              → DiseaseNutritionRules (Nutrient, Recommendation)
                     → Foods (by nutrient value)
                            → AISolutions (SolutionContent)
```

---

## PART 1 — Medical visit storage

### 1.1 Resolve ProfileID

For an elderly user (UserID), get ElderlyProfile.ProfileID:

```sql
SELECT TOP 1 ProfileID FROM ElderlyProfile WHERE UserID = ? ORDER BY ProfileID DESC;
```

If none exists, create one first or use a single "default" profile per user.

### 1.2 Insert visit and related data (example)

**Step 1 — VisitRecords**

```sql
INSERT INTO VisitRecords (ProfileID, VisitDateTime, VisitType, DoctorName, Diagnosis, TreatmentPlan)
VALUES (1, '2026-03-14 10:00:00', N'Khám định kỳ', N'BS. Nguyễn Văn A', N'Tăng huyết áp', N'Theo dõi huyết áp, uống thuốc đều');
-- Assume VisitID = 101 (from SCOPE_IDENTITY())
```

**Step 2 — MedicalHistory** (one or more conditions per visit)

```sql
INSERT INTO MedicalHistory (ProfileID, VisitID, DiseaseCode, ConditionName, HistoryType, DiagnosisDate, CurrentStatus, Notes)
VALUES
  (1, 101, 'I10', N'Cao huyết áp', N'Mạn tính', GETDATE(), N'Đang điều trị', N'Kiểm soát bằng thuốc');
```

**Step 3 — TestResults**

```sql
INSERT INTO TestResults (ProfileID, VisitID, TestName, ResultDescription, QuantitativeValue, Unit, DatePerformed)
VALUES
  (1, 101, N'Huyết áp', N'Huyết áp đo tại phòng khám', 125, 'mmHg', GETDATE()),
  (1, 101, N'Huyết áp tâm trương', NULL, 80, 'mmHg', GETDATE());
```

**Step 4 — Prescriptions**

```sql
INSERT INTO Prescriptions (ProfileID, VisitID, MedicationName, Dosage, Frequency, StartDate, EndDate)
VALUES
  (1, 101, N'Amlodipine', N'5mg', N'Mỗi ngày 1 viên', '2026-03-14', '2026-09-14');
```

**Step 5 — HealthMetrics** (optional; can also be filled from TestResults or separate device)

```sql
INSERT INTO HealthMetrics (ProfileID, MetricName, Value, Unit, MeasurementTime)
VALUES
  (1, N'Huyết áp', 125, 'mmHg', GETDATE()),
  (1, N'Nhịp tim', 72, 'bpm', GETDATE());
```

### 1.3 Backend flow (summary)

1. Receive form: visit (datetime, type, doctor, diagnosis, plan), conditions[], tests[], prescriptions[], metrics[].
2. Resolve ProfileID from session UserID (ElderlyProfile).
3. Insert VisitRecords; get VisitID (SCOPE_IDENTITY() or RETURNING).
4. Insert MedicalHistory rows (with VisitID if schema has it).
5. Insert TestResults, Prescriptions, HealthMetrics (with VisitID where applicable).
6. Redirect to visit history or medical history page.

---

## PART 2 — AI nutrition recommendation

### 2.1 Get diseases from medical history

```sql
SELECT DISTINCT mh.DiseaseCode, mh.ConditionName, dp.DiseaseName_EN
FROM MedicalHistory mh
LEFT JOIN DiseaseProtocol dp ON dp.DiseaseCode = mh.DiseaseCode
WHERE mh.ProfileID = ? AND mh.CurrentStatus IN (N'Đang điều trị', N'Theo dõi');
```

If using `Diseases` table with `DiseaseID`:

```sql
SELECT DISTINCT mh.DiseaseCode, d.DiseaseName
FROM MedicalHistory mh
JOIN Diseases d ON d.DiseaseCode = mh.DiseaseCode
WHERE mh.ProfileID = ?;
```

### 2.2 Get nutrition rules (DiseaseProtocol / DiseaseNutritionRules)

If rules are in a table linked by DiseaseCode:

```sql
SELECT nr.Nutrient, nr.Recommendation, nr.Notes
FROM DiseaseNutritionRules nr
JOIN DiseaseProtocol dp ON dp.DiseaseCode = nr.DiseaseCode
WHERE nr.DiseaseCode = ?
   OR dp.DiseaseCode = ?;
```

If linked by DiseaseID:

```sql
SELECT nr.Nutrient, nr.Recommendation, nr.Notes
FROM DiseaseNutritionRules nr
JOIN Diseases d ON d.DiseaseID = nr.DiseaseID
WHERE d.DiseaseCode = ?;
```

### 2.3 Get suggested foods (e.g. high potassium, low sodium)

```sql
-- Increase potassium
SELECT TOP 5 FoodName, Potassium FROM Foods WHERE Potassium > 0 ORDER BY Potassium DESC;

-- Reduce sodium: avoid high-sodium; show low-sodium
SELECT TOP 5 FoodName, ISNULL(Sodium,0) AS Sodium FROM Foods ORDER BY ISNULL(Sodium,999) ASC;
```

### 2.4 Build recommendation text and save

- Concatenate: disease name, nutrients to increase, to reduce, suggested food names.
- Example: *"Dựa trên lịch sử bệnh (Cao huyết áp), bác nên giảm muối và tăng thực phẩm giàu kali như chuối, rau bina, yến mạch."*
- Store in `AISolutions`: `INSERT INTO AISolutions (ProfileID, SolutionContent, SolutionType, CreationTime) VALUES (?, ?, 'Nutrition', GETDATE());`

### 2.5 Retrieve latest recommendation for homepage

```sql
SELECT TOP 1 SolutionID, SolutionContent, SolutionType, CreationTime
FROM AISolutions
WHERE ProfileID = ? AND SolutionType = 'Nutrition'
ORDER BY CreationTime DESC;
```

---

## PART 3 & 4 — Homepage UI

- **Layout:** One row, two columns (flexbox or grid).
  - Left: "Mẹo sống khỏe" (existing).
  - Right: "Gợi ý dinh dưỡng cho hôm nay" — content from latest AISolutions (disease, nutrients to increase/avoid, suggested foods).
- **Data:** Resolve ProfileID from session UserID; query latest AISolutions by ProfileID; if none, show placeholder (e.g. "Hoàn thiện hồ sơ và lịch sử bệnh để nhận gợi ý.").
- **Responsive:** Stack columns on small screens (e.g. `flex-direction: column` or `grid-template-columns: 1fr`).

---

## Schema requirements (AI flow)

- **MedicalHistory:** ProfileID, DiseaseCode, ConditionName, CurrentStatus (and optionally VisitID, DiagnosisDate, Notes).
- **DiseaseProtocol** (or **Diseases**): DiseaseCode (PK), DiseaseName_EN / DiseaseName.
- **DiseaseNutritionRules:** DiseaseCode (or DiseaseID FK to Diseases), Nutrient, Recommendation (`'Increase'` / `'Reduce'`).
- **Foods:** FoodName, and nutrient columns (e.g. Potassium, Sodium, Fiber, Calcium, Iron, Omega3, Protein) for ordering.
- **AISolutions:** ProfileID, SolutionContent, SolutionType, CreationTime.
- **ElderlyProfile:** ProfileID, UserID (so that we can resolve ProfileID from session UserID for the elderly).
