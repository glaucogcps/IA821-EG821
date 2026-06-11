
# Nonlinear Control of a Magnetic Levitation System (MLS)
### Robustness Analysis under Parametric Uncertainties (up to 25%)

![Status](https://img.shields.io/badge/Status-Completed-success)
![Tools](https://img.shields.io/badge/Tools-Matlab%20|%20Simulink%20|%20Python-blue)
![Theory](https://img.shields.io/badge/Theory-SMC%20|%20ISMC%20|%20Feedback%20Linearization-orange)

Este repositório contém o trabalho final da disciplina de Controle Não Linear, focado no projeto de controladores robustos para um Sistema de Levitação Magnética (MLS). O projeto evolui de uma abordagem de linearização por feedback sensível para um **Controle por Modos Deslizantes Integral (ISMC)** capaz de lidar com variações paramétricas severas.

---

## Origem e Referência
Este trabalho foi desenvolvido a partir do estudo e aprimoramento dos resultados apresentados em:
> **Pradhan, S. K., & Singh, R.** (2014). *"Nonlinear Control of a Magnetic Levitation System using Feedback Linearization"*. IEEE International Conference on Advanced Communication Control and Computing Technologies.

**Contribuições deste projeto além do artigo original:**
*   **Modelagem Física Detalhada:** Reconstrução do modelo de 3ª ordem considerando a geometria do solenoide (Lei de Biot-Savart) e a dinâmica elétrica (Lei de Kirchhoff), superando o modelo simplificado que trata a corrente apenas como entrada.
*   **Upgrade de Robustez:** Enquanto o artigo original foca em *Feedback Linearization* (sensível a erros de 1%), este projeto implementa **SMC** e **ISMC** para suportar incertezas de até **25%**.
*   **Simulação de Monte Carlo:** Validação estatística da robustez através de múltiplas simulações aleatórias.

---

## O Sistema (MLS)
O sistema de levitação magnética é inerentemente instável e altamente não linear. O modelo de estados de terceira ordem é definido por:
- $x_1$: Posição da esfera ($m$)
- $x_2$: Velocidade da esfera ($m/s$)
- $x_3$: Corrente na bobina ($A$)

A força magnética é modelada como uma função não linear da posição e da corrente:
$$F(x, i) = \frac{I^2}{b_0 + b_1x + b_2x^2 + b_3x^3}$$

---

## Estratégias de Controle Implementadas

### 1. Feedback Linearization (Inversão Dinâmica)
Utilizada como *baseline*. O controlador cancela as não linearidades nominais para impor uma dinâmica linear de erro.
*   **Ponto Fraco:** Falha catastrófica no rastreamento de referência com apenas **1%** de erro na estimativa da massa ou indutância.

### 2. Sliding Mode Control (SMC)
Implementação de uma superfície de deslize estável (Hurwitz) com lei de controle descontínua.
*   **Vantagem:** Robustez inerente contra incertezas de 25%.
*   **Limitação:** Presença de erro de regime permanente devido à camada limite usada para mitigar o *chattering*.

### 3. Integral Sliding Mode Control (ISMC) - *Solução Definitiva*
A superfície de deslizamento é aumentada com um estado integral:
$$s(z) = z_3 + 3\lambda z_2 + 3\lambda^2 z_1 + \lambda^3 \int e(\tau)d\tau$$
*   **Resultado:** Eliminação total do erro de regime, estabilidade numérica superior e excelente rejeição de distúrbios.

---

## Resultados e Robustez
As validações foram feitas via **Simulação de Monte Carlo** (10 iterações com parâmetros variando aleatoriamente em $\pm 25\%$).

| Critério | Feedback Linearization | ISMC (Proposto) |
| :--- | :--- | :--- |
| **Erro de Regime (Nominal)** | 0% | 0% |
| **Erro de Regime (Incerteza 25%)** | Inadequados | Nulo |
| **Estabilidade** | Sensível | Globalmente Robusto |

### Gráficos de Monte Carlo (Python Reconstruction)
As trajetórias individuais e a média demonstram a convergência para a referência, evidenciando o sucesso do termo integral na superfície de deslizamento.

---

## Tecnologias Utilizadas
*   **MATLAB R2018b**: Simulação numérica e S-Functions.
*   **Simulink**: Modelagem do diagrama de blocos e loops de controle.
*   **Python (Pandas/Matplotlib)**: Pós-processamento de dados e geração de gráficos de alta qualidade (PGF/PNG) para documentação acadêmica.

---

## Referências
[1] S. K. Pradhan and R. Singh, “Nonlinear control of a magnetic levitation system using feedback linearization,” in 2014 IEEE International Conference on Advanced Communications, Control and Computing Technologies, 2014, pp. 152–156. </br>
[2] S. D. Umans, Máquinas elétricas de Fitzgerald e Kingsley, 7th ed. Porto Alegre: AMGH, 2014, tradução de Anat´olio Laschuk.  </br>
[3] H. K. Khalil, Nonlinear Control. Pearson, 2015.  </br>
[4] G. F. Franklin, J. D. Powell, and A. Emami-Naeini, Sistemas de controle para engenharia, 6th ed. Porto Alegre: Bookman, 2013, tradução de Fernando de Oliveira Souza.  </br>
[5] M. Rubagotti, A. Estrada, F. Castanos, A. Ferrara, and L. Fridman, “Integral sliding mode control for nonlinear systems with matched and unmatched perturbations,” IEEE Transactions on Automatic Control, vol. 56, no. 11, pp. 2699–2704, 2011.  </br>
[6] Y. Pan, C. Yang, L. Pan, and H. Yu, “Integral sliding mode control: Performance, modification, and improvement,” IEEE Transactions on Industrial Informatics, vol. 14, no. 7, pp. 3087–3096, 2018  </br>

---

## 📧 Contato
**Glauco C. P. Soares**  
Faculdade de Engenharia Elétrica e de Computação (FEEC) - UNICAMP  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/glauco-soares)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:glauco.gcps@gmail.com)


---
*Este projeto foi realizado para fins acadêmicos e todos os créditos ao trabalho original de Pradhan et al. foram mantidos.*
