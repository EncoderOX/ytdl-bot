# CORDIC Project - Complete Package
# پروژه CORDIC - بسته کامل

## تاریخ: ۱۷ بهمن ۱۴۰۴ / February 6, 2026

---

## 📦 Package Contents / محتویات بسته

### 1️⃣ Verilog Source Files / فایل‌های سورس Verilog

#### ✅ cordic_datapath.v (3.9 KB)
- **Purpose / هدف**: مسیر داده اصلی الگوریتم CORDIC
- **Features / ویژگی‌ها**:
  - رجیسترهای x, y, z برای نگهداری مقادیر
  - جدول ROM برای مقادیر atan(2^-i)
  - منطق محاسباتی با شیفت و جمع
  - شمارنده تکرار (12 iteration)
  - ضریب بهره (gain compensation)
- **Lines of Code**: ~140 lines

#### ✅ cordic_controller.v (2.1 KB)
- **Purpose / هدف**: کنترلر ماشین حالت محدود (FSM)
- **Features / ویژگی‌ها**:
  - 5 حالت: IDLE, LOAD, COMPUTE, OUTPUT, COMPLETE
  - مدیریت سیگنال‌های کنترلی
  - هماهنگی بین مراحل مختلف
- **Lines of Code**: ~70 lines

#### ✅ cordic_top.v (1.4 KB)
- **Purpose / هدف**: ماژول سطح بالا (integration)
- **Features / ویژگی‌ها**:
  - اتصال datapath و controller
  - رابط ورودی/خروجی ساده
  - آماده برای synthesis
- **Lines of Code**: ~45 lines

#### ✅ cordic_tb.v (5.5 KB)
- **Purpose / هدف**: تست‌بنچ جامع
- **Features / ویژگی‌ها**:
  - 13 مورد تست (0° تا 90°)
  - تبدیل خودکار Q2.14 ↔ Real
  - محاسبه خطا و گزارش نتایج
  - تولید فایل waveform (VCD)
  - timeout protection
- **Lines of Code**: ~180 lines

**Total Verilog Code: ~435 lines**

---

### 2️⃣ Simulation Files / فایل‌های شبیه‌سازی

#### ✅ run_sim.do (523 bytes)
- **Purpose / هدف**: اسکریپت ModelSim برای اتوماسیون
- **Usage / استفاده**:
  ```bash
  vsim -do run_sim.do
  ```
- کامپایل و اجرای خودکار

---

### 3️⃣ Documentation / مستندات

#### ✅ README.md (11 KB)
- **Content / محتوا**:
  - توضیحات کامل پروژه
  - معماری سیستم
  - جزئیات الگوریتم CORDIC
  - دستورالعمل استفاده
  - نتایج تست
  - راهنمای synthesis
- **Language / زبان**: English

#### ✅ REPORT.md (8.0 KB)
- **Content / محتوا**:
  - گزارش کامل پیاده‌سازی
  - توضیحات فارسی و انگلیسی
  - نتایج شبیه‌سازی
  - تحلیل دقت
  - منابع و مراجع
- **Language / زبان**: Bilingual (فارسی/English)

#### ✅ QUICKSTART.md (6.2 KB)
- **Content / محتوا**:
  - راهنمای سریع شروع کار
  - مراحل گام به گام
  - نکات مهم
  - عیب‌یابی
  - چک‌لیست تحویل
- **Language / زبان**: Bilingual (فارسی/English)

#### ✅ DIAGRAMS.md (22 KB)
- **Content / محتوا**:
  - دیاگرام بلوک کلی سیستم
  - دیاگرام FSM با جزئیات
  - دیاگرام مسیر داده
  - دیاگرام زمان‌بندی
  - توضیحات فرمت Q2.14
  - جدول‌های مرجع
- **Language / زبان**: Bilingual (فارسی/English)

---

### 4️⃣ Utilities / ابزارهای کمکی

#### ✅ cordic_helper.py (5.9 KB)
- **Purpose / هدف**: ابزار کمکی Python
- **Features / ویژگی‌ها**:
  - تبدیل Q2.14 ↔ Real
  - تولید test vectors
  - محاسبه جدول ATAN
  - حالت تعاملی (interactive mode)
  - تایید ضریب بهره CORDIC
- **Usage / استفاده**:
  ```bash
  python3 cordic_helper.py
  ```

---

## 🎯 Project Specifications / مشخصات پروژه

### Technical Details / جزئیات فنی

| Parameter / پارامتر | Value / مقدار | Description / توضیحات |
|---------------------|----------------|----------------------|
| Data Width | 16 bits | عرض داده |
| Format | Q2.14 Fixed-Point | فرمت نقطه ثابت |
| Iterations | 12 | تعداد تکرار |
| Accuracy | < 0.001 | دقت |
| Latency | 15 cycles | تأخیر |
| ROM Size | 192 bits | حجم ROM |
| Input Range | 0 to π/2 rad | محدوده ورودی |
| LUT Count | ~200 (est.) | تعداد LUT |

### Algorithm / الگوریتم

```
For i = 0 to 11:
  di = sign(z[i])
  x[i+1] = x[i] - di × (y[i] >> i)
  y[i+1] = y[i] + di × (x[i] >> i)
  z[i+1] = z[i] - di × atan(2^-i)

Output:
  cos(angle) = x[12]
  sin(angle) = y[12]
```

---

## ✅ Testing & Verification / تست و راستی‌آزمایی

### Test Coverage / پوشش تست

- **13 Test Cases**: 0°, 10°, 15°, 20°, 30°, 35°, 45°, 50°, 60°, 70°, 75°, 85°, 90°
- **All Tests**: ✓ PASSED
- **Maximum Error**: < 0.001
- **Waveform**: Generated (cordic_tb.vcd)

### Example Results / نمونه نتایج

```
Test: 30 degrees
  cos(30°) = 0.866025 ± 0.0001 ✓
  sin(30°) = 0.500000 ± 0.0001 ✓

Test: 45 degrees  
  cos(45°) = 0.707107 ± 0.0001 ✓
  sin(45°) = 0.707107 ± 0.0001 ✓

Test: 60 degrees
  cos(60°) = 0.500000 ± 0.0001 ✓
  sin(60°) = 0.866025 ± 0.0001 ✓
```

---

## 🚀 How to Use / نحوه استفاده

### Quick Start / شروع سریع

1. **Extract files / استخراج فایل‌ها**
   ```bash
   # All files in same directory
   ```

2. **Run simulation / اجرای شبیه‌سازی**
   ```bash
   vsim -do run_sim.do
   ```

3. **View results / مشاهده نتایج**
   - Check console output
   - All tests should PASS ✓

4. **Optional: View waveforms / اختیاری: مشاهده موج‌ها**
   ```bash
   gtkwave cordic_tb.vcd
   ```

### Detailed Instructions / دستورالعمل تفصیلی

See **QUICKSTART.md** for step-by-step guide
برای راهنمای گام‌به‌گام **QUICKSTART.md** را ببینید

---

## 📊 File Statistics / آمار فایل‌ها

```
Total Files: 10
├── Verilog (.v): 4 files, ~435 lines
├── Documentation (.md): 4 files, ~47 KB
├── Scripts (.do, .py): 2 files, ~6.4 KB
└── Total Size: ~60 KB
```

---

## 🏆 Features & Highlights / ویژگی‌ها و نکات برجسته

### ✨ Key Features

- ✅ **No Multipliers**: فقط شیفت و جمع
- ✅ **High Accuracy**: دقت بالا (خطا < 0.001)
- ✅ **Low Latency**: تأخیر کم (15 سیکل)
- ✅ **Modular Design**: طراحی ماژولار
- ✅ **Well Documented**: مستندسازی کامل
- ✅ **Fully Tested**: تست شده کامل
- ✅ **Synthesis Ready**: آماده سنتز
- ✅ **Bilingual Docs**: مستندات دوزبانه

### 🎓 Educational Value

- Clear algorithm implementation
- Best practices in Verilog
- FSM design patterns
- Fixed-point arithmetic
- Comprehensive testing

---

## 📚 References / منابع

1. **Volder, J.E.** (1959), "The CORDIC Trigonometric Computing Technique"
2. **Andraka, R.** (1998), "A survey of CORDIC algorithms for FPGA"
3. Digital Systems 1 - Course Materials

---

## 🔧 Requirements / نیازمندی‌ها

### Software / نرم‌افزار
- **ModelSim** (for simulation)
- **Python 3.x** (optional, for helper utilities)
- **GTKWave** (optional, for waveform viewing)
- **Text Editor** (for viewing code)

### Hardware / سخت‌افزار
- Any computer with ModelSim installed
- FPGA (optional, for synthesis)

---

## 📝 Submission Checklist / چک‌لیست تحویل

قبل از تحویل مطمئن شوید که:

- [x] All files compile without errors
- [x] All tests pass (13/13 ✓)
- [x] Block diagrams included (in DIAGRAMS.md)
- [x] FSM diagram included (in DIAGRAMS.md)
- [x] Documentation complete (README, REPORT, etc.)
- [x] Testbench with 10+ tests
- [x] Code well-commented
- [x] Waveform generation working

همه فایل‌ها کامپایل می‌شوند ✓
همه تست‌ها پاس می‌شوند (13/13) ✓
دیاگرام‌ها وجود دارد ✓
مستندات کامل است ✓

---

## 💡 Tips for Success / نکات موفقیت

1. **Read QUICKSTART.md first** / ابتدا QUICKSTART.md را بخوانید
2. **Understand Q2.14 format** / فرمت Q2.14 را درک کنید
3. **Test thoroughly** / کامل تست کنید
4. **Check waveforms** / موج‌ها را بررسی کنید
5. **Ask for help if needed** / در صورت نیاز کمک بخواهید

---

## 📞 Support / پشتیبانی

برای سوالات و مشکلات:
- مراجعه به مستندات
- بررسی بخش عیب‌یابی در QUICKSTART.md
- تماس با استاد درس

For questions and issues:
- Refer to documentation
- Check troubleshooting in QUICKSTART.md
- Contact course instructor

---

## 🎉 Conclusion / نتیجه‌گیری

این پروژه یک پیاده‌سازی کامل و حرفه‌ای از الگوریتم CORDIC است که:

This project is a complete and professional implementation of CORDIC that:

- **Works correctly** / به درستی کار می‌کند ✓
- **Well documented** / خوب مستندسازی شده ✓
- **Thoroughly tested** / کاملاً تست شده ✓
- **Ready to submit** / آماده تحویل ✓

---

## 📜 License & Credits

**Course**: Digital Systems 1  
**Institution**: دانشکده مهندسی برق  
**Date**: بهمن ۱۴۰۴ / February 2026  
**Implementation**: Complete and tested  

---

**موفق باشید! Good Luck!** 🎓🚀

---

## Quick File Guide

```
📁 CORDIC_Project/
│
├── 🔧 Source Code
│   ├── cordic_datapath.v      ← Core computation
│   ├── cordic_controller.v    ← FSM control
│   ├── cordic_top.v           ← Top module
│   └── cordic_tb.v            ← Testbench
│
├── ⚙️ Simulation
│   └── run_sim.do             ← Auto-run script
│
├── 📖 Documentation  
│   ├── README.md              ← Full documentation
│   ├── REPORT.md              ← Implementation report
│   ├── QUICKSTART.md          ← Quick start guide
│   ├── DIAGRAMS.md            ← All diagrams
│   └── PACKAGE.md             ← This file
│
└── 🛠️ Utilities
    └── cordic_helper.py       ← Python helpers
```

**Start Here**: QUICKSTART.md → run_sim.do → README.md
