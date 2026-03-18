# spinachlang-algorithms

Popular quantum algorithms implemented in Spinach, covering
everything from basic primitives to a full error-correction protocol.

## Algorithms

| File | Algorithm | Qubits | Key features |
|------|-----------|--------|--------------|
| `superposition.sph` | Single-qubit superposition | 1 | H gate, measurement |
| `entanglement.sph` | Bell pair (entanglement) | 2 | H, FCX, wildcard `*` |
| `interference.sph` | Quantum interference | 1 | H, Z, H cancellation |
| `deutsch.sph` | Deutsch's algorithm | 2 | Phase kickback, oracle |
| `deutsch_jozsa.sph` | Deutsch-Jozsa (n=2) | 3 | Named instructions, H\|FCX\|H pipeline |
| `bernstein_vazirani.sph` | Bernstein-Vazirani (s=101) | 4 | Named instructions, oracle |
| `grover.sph` | Grover's search (2-qubit, target \|11⟩) | 2 | Named instruction, reverse pipeline `<-`, CZ |
| `half_adder.sph` | Quantum half-adder | 3 | CCX (Toffoli), CX |
| `qft.sph` | Quantum Fourier Transform (3-qubit) | 3 | CU1 rotation gates, SWAP |
| `phase_estimation.sph` | Quantum Phase Estimation (1-bit) | 2 | Pipeline: H\|CZ\|H\|M |
| `swap_test.sph` | Swap test (state fidelity) | 3 | CSWAP (Fredkin), H sandwich |
| `teleportation.sph` | Quantum teleportation | 3 | FCX, list measurement, `if` conditionals |
| `superdense_coding.sph` | Superdense coding ("11") | 2 | Long pipeline, Z\|X encoding |
| `ghz.sph` | GHZ state | 3 | H, cascaded FCX |
| `qec_bit_flip.sph` | **3-Qubit Bit-Flip QEC** ★ | 5+ancilla | See below |

## Spotlight: `qec_bit_flip.sph`

The largest algorithm in the collection — a complete **quantum error correction** protocol
that exercises every major Spinach feature in one program:

```
# Named instructions — encode, synmeas0, synmeas1
encode   : FCX(rep1) | FCX(rep2)
synmeas0 : CX(data) | CX(rep1)

# Reverse pipeline — adjoint of encode
data -> encode <-

# Classical bit logic — NOT / AND / OR
nots0  -> NOT(syn0)
corr1  -> AND(syn0, syn1)
anyerr -> OR(syn0, syn1)

# Conditional (if) — feedforward correction
rep1 -> X if corr1

# Conditional (if-else) — diagnostic phase tag
data -> S if anyerr else T

# List target + wildcard
[anc0, anc1] -> M
* -> BARRIER
```

The nine-stage protocol:

1. **Prepare** logical |+⟩ on `data`
2. **Encode** into 3-qubit repetition code via `data -> encode`
3. **Inject** a bit-flip error (`rep1 -> X`) to simulate noise
4. **Syndrome measurement** — two ancilla qubits reveal which qubit flipped
5. **Classical decode** — NOT/AND/OR bit arithmetic identifies the error
6. **Feedforward correction** — conditional X restores the damaged qubit
7. **Diagnostic** — `if-else` tags the execution path with a phase gate
8. **Decode** — `data -> encode <-` (reverse pipeline) uncomputes the encoding
9. **Measure all** — `* -> M` reads out the final state

> **QASM note**: the classical bit operations in stages 5-7 exceed QASM 2.0.
> The `.qasm` companion captures stages 1-4 only.
> For the full corrected circuit:
> ```
> spinachlang -l json qec_bit_flip.sph
> ```

## Running the examples

```bash
# Compile any algorithm to QASM
spinachlang -l qasm spinachlang-algorithms/grover.sph

# Use JSON for circuits with classical post-processing
spinachlang -l json spinachlang-algorithms/qec_bit_flip.sph

# Pipe to stdout
cat spinachlang-algorithms/superposition.sph | spinachlang -l qasm -
```
