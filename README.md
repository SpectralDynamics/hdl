<p align="center">
<img src="spectral_logo.jpg" width="400" alt="Spectral Dynamics Logo">
</p>

---

# Spectral Dynamics — HDL Reference Design

This repository contains the HDL (Verilog) source files and Tcl scripts to build the **Panther** data acquisition project for the **Zedboard (Zynq-7000)** using Xilinx Vivado 2023.2.

> **Forked from:** [analogdevicesinc/hdl](https://github.com/analogdevicesinc/hdl)
> Original ADI HDL libraries and IP cores are used under their respective licenses (ADIBSD / GPL2 / LGPL). See [LICENSE_ADIBSD](LICENSE_ADIBSD), [LICENSE_GPL2](LICENSE_GPL2), and [LICENSE_LGPL](LICENSE_LGPL).

---

## Prerequisites

- [Xilinx Vivado Design Suite 2023.2](https://www.xilinx.com/support/download.html)
- Windows 10/11 or Linux
- Git (optional — or download as ZIP)

---

## How to Build the AD7768EVB Vivado Project

### Step 1 — Get the repository

**Option A: Clone with Git**
```
git clone https://github.com/SpectralDynamics/hdl.git
cd hdl
```

**Option B: Download ZIP**

1. Go to [https://github.com/SpectralDynamics/hdl](https://github.com/SpectralDynamics/hdl)
2. Click **Code → Download ZIP**
3. Extract the ZIP — the folder will be named `hdl-main`

### Step 2 — Open Vivado 2023.2

Launch **Vivado 2023.2**. Do not open any project — go directly to the Tcl Console.

### Step 3 — Run the project script

In the Vivado Tcl Console, navigate to the project directory and source the build script:

```tcl
cd c:/path/to/hdl-main/projects/ad7768evb/zed
source system_project.tcl
```

> Replace `c:/path/to/hdl-main` with the actual path where you extracted or cloned the repository.

Vivado will automatically:
- Create the `ad7768evb_zed` project
- Build the block design
- Run synthesis and implementation
- Generate the bitstream

This process typically takes **30–90 minutes** depending on your machine.

### Step 4 — Locate the output files

Once complete, the bitstream and hardware handoff file will be in:
```
projects/ad7768evb/zed/ad7768evb_zed.runs/impl_1/system_top.bit
projects/ad7768evb/zed/ad7768evb_zed.sdk/system_top.xsa
```

---

## Repository Structure

```
hdl/
├── library/              # ADI IP cores (axi_ad7768, axi_dmac, util_cpack2, etc.)
│   ├── axi_ad7768/       # AD7768 8-channel ADC interface core
│   ├── axi_dmac/         # DMA controller
│   ├── common/           # Shared RTL modules
│   ├── xilinx/           # Xilinx-specific primitives and constraints
│   └── ...
├── projects/
│   ├── ad7768evb/
│   │   ├── zed/          # Zedboard project (system_project.tcl, system_top.v, etc.)
│   │   └── common/       # Shared block design TCL (ad7768evb_bd.tcl)
│   ├── common/
│   │   └── zed/          # Zedboard base system block design
│   └── scripts/          # ADI project build scripts
├── scripts/              # Environment setup (adi_env.tcl)
└── linux/arch/arm/dts/   # Device tree sources for Linux on Zedboard
```

---

## Target Hardware

| Component | Details |
|-----------|---------|
| FPGA Board | Avnet Zedboard (Xilinx Zynq-7000 XC7Z020) |
| ADC Board | Analog Devices AD7768EVB |
| Interface | Parallel data bus (8-bit), DRDY-based |
| Channels | 8 simultaneous differential inputs |
| Tool | Vivado 2023.2 |

---

## License

The ADI IP cores in `library/` are licensed under the ADI BSD license (ADIBSD), GPL2, or LGPL.
See individual source files and the license files in the root of this repository for details.

Spectral Dynamics modifications and project files are provided under the same terms.
