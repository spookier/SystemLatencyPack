# System Latency Pack

**by Spookier**

Two different scripts for Windows, both optimized for the smoothest mouse response, perfect for gaming, esports, and low-latency applications.

---

## ⚔️ SetTimerResolution vs TSC - Which One Should You Use?

> ❗❗⚠️ **Important:** You should **NOT run both at the same time !**   
> Choose **either SetTimerResolution** or **TSC**, not both.

### 🔧 SetTimerResolution
- Boosts Windows timer resolution (typically to 0.5 ms or lower)
- Useful for certain games and applications that benefit from more frequent system wakeups


### ⚙️ TSC
- Configures Windows to rely on the **Time Stamp Counter**, a super-fast hardware-based CPU timer.
- More modern and efficient than traditional timer resolution tweaks.

> ✅ **If you don’t know which one to use, test both and keep the one that feels best.**  
> 💡 However, **TSC is recommended** as the cleaner, more efficient long-term solution, especially for modern CPUs.

## 🛠 How to Use

### 1. [Download the ZIP](https://github.com/spookier/SystemLatencyPack/releases/download/release/SystemLatencyPack.rar) and extract it anywhere

### 2. Choose Only One Method

Pick either:
- Run `SetTimerResolution/Run This To Install STR.bat`  
  **OR**
- Run `TSC/Run This To Install TSC.bat`  

> ❗ Again: **do not use both at the same time**. If you want to switch, uninstall the one you're using first.

### 3. Follow the On-Screen Menu

Each tweak includes:
- A simple menu
- Install & Uninstall options
- Reboot prompt when needed

---

