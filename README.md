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
## In-game test – Valorant Deathmatch (Ascent)

Below is a direct capture from two separate 8-minute LatencyMon sessions on the same rig, same map.  
Spawned into a Deathmatch on Ascent, remained for a full 8 min, actively moving and shooting players.  
The *only* variable toggled was the latency tool:  

| Metric (µs unless noted) | **TSC** | **SetTimerResolution&nbsp;** | Why It Matters |
|--------------------------|-------:|-------------------------------------:|----------------|
| **Highest interrupt-to-process latency** | **80.8** | 144.9 | Worst-case click-to-engine delay; lower = fewer “missed” 128-tick windows. |
| **Highest DPC execution time** | **171.4** (`dxgkrnl.sys`) | 247.7 (`nvlddmkm.sys`) | 250 µs is ~6 % of a 4.17 ms 240 Hz frame → visible hitch risk. |
| Highest ISR execution time | 42.2 | **41.2** | Essentially tied; both far below danger threshold. |
| Average interrupt-to-process latency | 5.12 | **3.88** | STR wins on averages, but spikes dominate perceived smoothness. |
| Total DPC time (%) | 1.24 % | **1.23 %** | Statistical tie. |
| Hard page-faults (count) | 443 | **78** | Occur during map load; irrelevant once in-match. |


### What The Numbers Tell Us
- **Spike control beats averages** – A single 248 µs `nvlddmkm` DPC under STR can delay the frame submit enough to miss the present-window or a network packet. TSC caps that spike at 171 µs, leaving ~75 µs of safety head-room.  
- **Tighter end-to-end path** – Highest interrupt-to-process latency (the full journey from mouse IRQ → game code) shrinks by **44 %** with TSC. That translates to crisper flick-shots and strafe cancels.  
- **Page-faults don’t hurt live play** – The bulk of TSC’s faults happened during the initial load-in. Once the round begins, Valorant’s memory set is locked in RAM.  
- **GPU driver sensitivity** – STR’s micro-hitch originates in `nvlddmkm.sys`. NVIDIA’s driver is known to coalesce DPCs differently when the OS tick interval is forced down, which explains the extra 70 µs spike.


| If you care about … | Do this |
|---------------------|---------|
| Lowest worst-case latency | **Use TSC** (install, reboot, verify LatencyMon). |
| Most driver compatibility | TSC again; it doesn’t touch global timer-resolution so fewer apps/anti-cheats complain. |
| Legacy titles that *need* 0.5 ms timers (e.g., CSGO, BF3, maybe some CoD titles) | Use STR **only for those sessions**, then uninstall. |

> **Bottom line:** The *tallest* latency spike is what ruins a round. **TSC lops that spike off** while keeping averages competitive, making it the safer bet for high-elo.
> Will do more testing soon
---
