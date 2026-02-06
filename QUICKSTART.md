# Quick Start Guide - راهنمای سریع
## CORDIC Project Implementation

---

## فارسی (Persian)

### مراحل اجرا

#### 1️⃣ دریافت فایل‌ها
همه فایل‌های زیر را دانلود کنید:
- `cordic_datapath.v`
- `cordic_controller.v`
- `cordic_top.v`
- `cordic_tb.v`
- `run_sim.do`

#### 2️⃣ شبیه‌سازی با ModelSim

**روش اول (خودکار):**
```bash
vsim -do run_sim.do
```

**روش دوم (دستی):**
```bash
# ایجاد کتابخانه کاری
vlib work

# کامپایل فایل‌ها
vlog cordic_datapath.v
vlog cordic_controller.v
vlog cordic_top.v
vlog cordic_tb.v

# اجرای شبیه‌سازی
vsim -c cordic_tb
run -all
quit
```

#### 3️⃣ بررسی نتایج
- خروجی در کنسول نمایش داده می‌شود
- باید همه تست‌ها PASS شوند (✓)
- خطا باید کمتر از 0.001 باشد

#### 4️⃣ مشاهده موج‌ها (اختیاری)
```bash
gtkwave cordic_tb.vcd
```

### درک فرمت Q2.14

**نحوه تبدیل:**

زاویه به رادیان → ضرب در 16384 → مقدار Q2.14

**مثال:**
- 30 درجه = 0.5236 رادیان
- 0.5236 × 16384 = 8583
- پس angle_in = 8583

**برخی مقادیر مفید:**

| زاویه | رادیان  | Q2.14  | Hex    |
|-------|---------|--------|--------|
| 0°    | 0       | 0      | 0x0000 |
| 30°   | 0.5236  | 8583   | 0x2187 |
| 45°   | 0.7854  | 12868  | 0x3244 |
| 60°   | 1.0472  | 17159  | 0x4307 |
| 90°   | 1.5708  | 25736  | 0x6488 |

### ساختار کد

```
CORDIC_TOP (سطح بالا)
├── CONTROLLER (کنترلر FSM)
│   └── حالت‌ها: IDLE → LOAD → COMPUTE → OUTPUT → COMPLETE
│
└── DATAPATH (مسیر داده)
    ├── رجیسترها: x, y, z
    ├── جدول ROM: atan_table
    └── منطق محاسباتی: شیفت و جمع
```

### نکات مهم

✅ **انجام دهید:**
- همه فایل‌ها را در یک پوشه قرار دهید
- فایل‌ها را به ترتیب کامپایل کنید
- نتایج را با دقت بررسی کنید

❌ **انجام ندهید:**
- فایل‌ها را تغییر ندهید مگر لازم باشد
- فراموش نکنید که زاویه باید رادیان باشد
- فراموش نکنید که زاویه باید در ربع اول باشد (0 تا 90 درجه)

### عیب‌یابی

**مشکل: کامپایل نمی‌شود**
- بررسی کنید همه فایل‌ها موجود باشند
- نام فایل‌ها را چک کنید (case-sensitive)

**مشکل: نتایج غلط است**
- بررسی کنید زاویه در رادیان باشد
- بررسی کنید زاویه در ربع اول باشد (0-90°)

**مشکل: خطا زیاد است**
- عادی است، خطای کمتر از 0.001 قابل قبول است
- برای دقت بیشتر می‌توانید تعداد تکرار را افزایش دهید

---

## English

### Quick Steps

#### 1️⃣ Get the Files
Download all these files:
- `cordic_datapath.v`
- `cordic_controller.v`
- `cordic_top.v`
- `cordic_tb.v`
- `run_sim.do`

#### 2️⃣ Simulate with ModelSim

**Method 1 (Automated):**
```bash
vsim -do run_sim.do
```

**Method 2 (Manual):**
```bash
# Create work library
vlib work

# Compile files
vlog cordic_datapath.v
vlog cordic_controller.v
vlog cordic_top.v
vlog cordic_tb.v

# Run simulation
vsim -c cordic_tb
run -all
quit
```

#### 3️⃣ Check Results
- Output shown in console
- All tests should PASS (✓)
- Error should be < 0.001

#### 4️⃣ View Waveforms (Optional)
```bash
gtkwave cordic_tb.vcd
```

### Understanding Q2.14 Format

**How to convert:**

Angle in radians → multiply by 16384 → Q2.14 value

**Example:**
- 30 degrees = 0.5236 radians
- 0.5236 × 16384 = 8583
- So angle_in = 8583

**Useful Values:**

| Angle | Radians | Q2.14  | Hex    |
|-------|---------|--------|--------|
| 0°    | 0       | 0      | 0x0000 |
| 30°   | 0.5236  | 8583   | 0x2187 |
| 45°   | 0.7854  | 12868  | 0x3244 |
| 60°   | 1.0472  | 17159  | 0x4307 |
| 90°   | 1.5708  | 25736  | 0x6488 |

### Code Structure

```
CORDIC_TOP (Top Level)
├── CONTROLLER (FSM Controller)
│   └── States: IDLE → LOAD → COMPUTE → OUTPUT → COMPLETE
│
└── DATAPATH (Data Path)
    ├── Registers: x, y, z
    ├── ROM Table: atan_table
    └── Computation: shift and add
```

### Important Notes

✅ **DO:**
- Put all files in same directory
- Compile files in order
- Check results carefully

❌ **DON'T:**
- Don't modify files unless necessary
- Don't forget angle must be in radians
- Don't forget angle must be in first quadrant (0-90°)

### Troubleshooting

**Problem: Won't compile**
- Check all files are present
- Check file names (case-sensitive)

**Problem: Wrong results**
- Check angle is in radians
- Check angle is in first quadrant (0-90°)

**Problem: Large error**
- Normal, error < 0.001 is acceptable
- For better precision, increase iterations

---

## Test Case Examples / مثال‌های تست

```verilog
// Test 30 degrees
angle_in = 16'd8583;   // 30° in Q2.14
start = 1;
@(posedge done);
// Expected: cos_out ≈ 14189, sin_out ≈ 8192

// Test 45 degrees  
angle_in = 16'd12868;  // 45° in Q2.14
start = 1;
@(posedge done);
// Expected: cos_out ≈ 11585, sin_out ≈ 11585

// Test 60 degrees
angle_in = 16'd17159;  // 60° in Q2.14
start = 1;
@(posedge done);
// Expected: cos_out ≈ 8192, sin_out ≈ 14189
```

---

## Checklist / چک‌لیست تحویل

قبل از تحویل مطمئن شوید:

- [ ] همه فایل‌ها کامپایل می‌شوند
- [ ] تست‌ها PASS می‌شوند
- [ ] دیاگرام بلوک رسم شده
- [ ] دیاگرام FSM رسم شده  
- [ ] حداقل 10 تست موفق
- [ ] README/REPORT آماده است

Before submission, ensure:

- [ ] All files compile
- [ ] Tests PASS
- [ ] Block diagram drawn
- [ ] FSM diagram drawn
- [ ] At least 10 successful tests
- [ ] README/REPORT ready

---

## Contact / تماس

برای سوالات با استاد درس تماس بگیرید.

For questions, contact course instructor.

**موفق باشید! Good Luck!** 🎓
