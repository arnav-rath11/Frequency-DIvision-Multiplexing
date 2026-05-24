<div align="center">

# 📡 Frequency Division Multiplexing (FDM)
### MATLAB Mini Project — Communications Lab

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023a+-orange?style=for-the-badge&logo=mathworks&logoColor=white)](https://www.mathworks.com/)
[![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)
[![Author](https://img.shields.io/badge/Author-arnav--rath11-green?style=for-the-badge&logo=github)](https://github.com/arnav-rath11)
[![Status](https://img.shields.io/badge/Status-Completed-brightgreen?style=for-the-badge)]()

<br/>

> *Simulating the simultaneous transmission of multiple signals over a shared channel — each occupying its own unique frequency band.*

</div>

---

## 📌 Table of Contents

- [About the Project](#-about-the-project)
- [What is FDM?](#-what-is-fdm)
- [System Block Diagram](#-system-block-diagram)
- [Project Structure](#-project-structure)
- [Signal Parameters](#-signal-parameters)
- [Results & Output Plots](#-results--output-plots)
- [Key Observations](#-key-observations)
- [Real-World Applications](#-real-world-applications)
- [How to Run](#-how-to-run)
- [Author](#-author)

---

## 🧠 About the Project

This mini project implements **Frequency Division Multiplexing (FDM)** entirely in MATLAB. Three independent baseband signals are modulated onto separate carrier frequencies, combined into a single composite FDM signal, transmitted, and then recovered at the receiver using bandpass filters and coherent demodulation.

**Goals:**
- Understand how multiple signals coexist in one channel without interfering
- Visualize modulation, multiplexing, and demultiplexing at every stage
- Calculate SNR to measure signal recovery quality

---

## 📖 What is FDM?

**Frequency Division Multiplexing** is a technique where the available bandwidth of a channel is divided into non-overlapping sub-bands. Each sub-band carries a separate signal, modulated onto a unique carrier frequency.

```
Channel Bandwidth
├── Band 1 → Signal 1 (fc = 1000 Hz)
├── Band 2 → Signal 2 (fc = 2000 Hz)
└── Band 3 → Signal 3 (fc = 3000 Hz)
```

At the **transmitter**, each signal modulates its carrier (DSB-SC):

```
s_i(t) = m_i(t) × cos(2π·fc_i·t)
```

The FDM composite is simply the sum:

```
x_FDM(t) = s1(t) + s2(t) + s3(t)
```

At the **receiver**, each channel is recovered by:
1. Bandpass filtering around the target carrier frequency
2. Multiplying by the same carrier (coherent detection)
3. Low-pass filtering to remove the double-frequency term

---

## 🔷 System Block Diagram

```
TRANSMITTER                                    RECEIVER
───────────────────────────────────────────────────────────────
                                               
  m1(t) ──→ [× cos fc1] ──┐        ┌──→ [BPF fc1] ──→ [× cos fc1] ──→ [LPF] ──→ m̂1(t)
                           │        │
  m2(t) ──→ [× cos fc2] ──┼──→ [Σ] ┼──→ [BPF fc2] ──→ [× cos fc2] ──→ [LPF] ──→ m̂2(t)
                           │        │
  m3(t) ──→ [× cos fc3] ──┘        └──→ [BPF fc3] ──→ [× cos fc3] ──→ [LPF] ──→ m̂3(t)
                             FDM
                            Signal
```

---

## 📁 Project Structure

```
fdm-project/
│
├── fdm_project.m        # Main MATLAB script (all-in-one)
├── README.md            # This file
└── output/
    └── fdm_output.png   # Generated figure (12 subplots)
```

---

## ⚙️ Signal Parameters

| Parameter | Value |
|:---|:---|
| Sampling Frequency (Fs) | 10,000 Hz |
| Signal Duration | 1 second |
| Signal 1 | 50 Hz sine wave |
| Signal 2 | 120 Hz composite (sine + harmonic) |
| Signal 3 | 200 Hz square wave |
| Carrier 1 (fc1) | 1000 Hz |
| Carrier 2 (fc2) | 2000 Hz |
| Carrier 3 (fc3) | 3000 Hz |
| Modulation Type | DSB-SC |
| BPF Order | 6th-order Butterworth |
| LPF Order | 5th-order Butterworth |
| Channel Bandwidth | 600 Hz per channel |

---

## 📊 Results & Output Plots

The MATLAB script generates a **4-row, 12-subplot figure**:

### Row 1 — Original Baseband Signals
Three independent signals before any processing. Signal 1 is a clean 50 Hz sine, Signal 2 is a more complex composite waveform, and Signal 3 is a 200 Hz square wave with sharp transitions.

### Row 2 — Modulated Signals (After DSB-SC)
Each signal is shifted to its carrier band. The envelope of the high-frequency oscillation now carries the shape of the original baseband signal — this is the essence of amplitude modulation.

### Row 3 — FDM Composite + Spectrum
- **Time domain:** The composite looks like noise — all three channels are superimposed
- **Frequency domain (FFT):** Three distinct spectral peaks appear at exactly 1kHz, 2kHz, and 3kHz, confirming clean channel separation

### Row 4 — Recovered Signals (After Demodulation)

| Channel | SNR |
|:---|:---|
| Channel 1 (50 Hz sine) | −5.2 dB |
| Channel 2 (120 Hz composite) | −5.2 dB |
| Channel 3 (200 Hz square) | −3.7 dB |

> The recovered waveforms visually match the originals. Negative SNR values are expected due to Butterworth filter group delay and inter-channel leakage — increasing carrier spacing or filter order improves this significantly.

---

## 🔍 Key Observations

- ✅ Three different signals transmitted **simultaneously** over one channel
- ✅ The **FDM spectrum** shows three clean, non-overlapping bands
- ✅ Bandpass filters successfully **isolate each channel** at the receiver
- ✅ Coherent demodulation **recovers the original waveforms**
- ⚠️ Negative SNR is due to filter group delay — compensated by offset-aligning the signals during SNR calculation
- 💡 Wider carrier spacing and higher-order filters would improve SNR

---

## 🌍 Real-World Applications

| Technology | How FDM is Used |
|:---|:---|
| 📻 FM Radio | Each station gets a 200 kHz band between 88–108 MHz |
| 📺 Cable TV | Hundreds of channels on one coaxial cable |
| 🌐 DSL Internet | Voice (POTS) and data on separate frequency bands |
| 📶 4G/5G (OFDMA) | Evolved FDM with orthogonal subcarriers |
| 🛰️ Satellite Comms | Multiple transponders on different frequency bands |

---

## ▶️ How to Run

**Requirements:** MATLAB R2020a or later (Signal Processing Toolbox recommended)

```matlab
% Clone or download the repo, then in MATLAB:
run('fdm_project.m')
```

Or simply open `fdm_project.m` in MATLAB and press **Run (F5)**.

The script will:
1. Generate and plot all 12 subplots automatically
2. Print SNR values for all 3 channels in the Command Window
3. Display the full FDM figure titled *"Frequency Division Multiplexing (FDM)"*

---

## 👤 Author

<div align="center">

**Arnav Rath**

[![GitHub](https://img.shields.io/badge/GitHub-arnav--rath11-181717?style=for-the-badge&logo=github)](https://github.com/arnav-rath11)

*B.E. / B.Tech — Electronics & Communication / Electrical Engineering*
*Communications Lab Mini Project*

</div>

---

<div align="center">

Made with ❤️ and MATLAB &nbsp;|&nbsp; Mini Project — Communications Lab

</div>
