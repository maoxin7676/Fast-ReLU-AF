# An Efficient Nonlinear Adaptive Filter Algorithm Based on the Rectified Linear Unit (Official Implementation)

This is the official MATLAB implementation for the research paper:  
**"An Efficient Nonlinear Adaptive Filter Algorithm Based on the Rectified Linear Unit"**
<p align="center">
<i>"I hope this implementation provides the community with a clearer and more intuitive understanding of the essence of nonlinear adaptive filtering."</i>
</p>
## 💡 Philosophy: Why This "Nonlinear-Only" Version?

In this official repository, I have deliberately provided the **Nonlinear-only version** of the algorithm. As the author, I stripped away the linear branch to provide researchers with a transparent look at the core mechanism of the ReLU-AF:

1.  **Isolating the Power of ReLU**: It demonstrates that a simple Rectified Linear Unit ($max(0, x)$) is intrinsically capable of "generating" the necessary harmonic and intermodulation components (e.g., difference and sum frequencies) required to cancel complex distortions.
2.  **Revealing the Essence**: It proves that nonlinear filtering is essentially a **feature mapping** problem. Once the input is mapped into the right nonlinear space, the distortion can be effectively suppressed using a minimalist structure.
3.  **Maximum Efficiency**: This version showcases the absolute lower bound of computational cost—achieving robust nonlinear compensation with approximately **$4N+1$** multiplications.

## 🚀 Key Advantages

*   **Ultra-Low Complexity**: Requires significantly fewer computations than traditional Second-Order Volterra filters ($O(N^2)$).
*   **Physical Intuition**: The ReLU operator naturally mimics physical "clipping" and "saturation" effects common in power amplifiers and low-cost speakers.
*   **Superior Convergence**: Due to the stability of the ReLU mapping, the algorithm allows for a larger step-size compared to conventional Functional Link Adaptive Filters (FLAF).

## 📊 Experimental Demo: Intermodulation Distortion (IMD)

The provided script simulates a system with intermodulation distortion: $d(n) = x(n) \cdot x(n-1)$.

### Spectral Logic Chain
By running `Main_Intermodulation_Demo.m`, you can observe the following logic:
- **Fig 1 (Input)**: Original dual-tone signal $x(n)$ (e.g., 500Hz and 800Hz).
- **Fig 2 (Desired)**: The target distortion $d(n)$ containing intermodulation products (e.g., 300Hz, 1000Hz, 1300Hz, 1600Hz).
- **Fig 3 (ReLU-Basis)**: The **ReLU-transformed signal**, which "creates" the missing frequency components required for cancellation.
- **Fig 4 (Error)**: The residual error $e(n)$, where distortion peaks are suppressed below -80dB.
  <img width="995" height="1119" alt="image" src="https://github.com/user-attachments/assets/9c7de413-a289-4a86-a2b8-82009947fef5" />


## 🛠️ Usage

1.  **Prerequisites**: MATLAB (R2020b or later recommended).
2.  **Run the Demo**: Open and run `Main_Intermodulation_Demo.m` in MATLAB to visualize the signal transformation and cancellation process.

## 📝 Official Citation

If you use this algorithm or code in your research, please cite the original paper:

```bibtex
@article{Mao2024ReLUAF,
  author  = {Mao, Xin and Xiang, Yang and Lu, Jing},
  journal = {Digital Signal Processing}, 
  title   = {An efficient nonlinear adaptive filter algorithm based on the rectified linear unit}, 
  year    = {2024},
  volume  = {146},
  pages   = {104373},
  doi     = {10.1016/j.dsp.2023.104373}
}


