OPENQASM 2.0;
include "qelib1.inc";

// 3-Qubit Bit-Flip QEC — quantum stages 1-4 only
// Classical syndrome decode and conditional corrections (stages 5-8)
// use NOT / AND / OR / if that exceed QASM 2.0.
// Full circuit: spinachlang -l json qec_bit_flip.sph

qreg q[5];
creg c[5];

// STAGE 1: Prepare logical |+> on data (q[0])
h q[0];

// STAGE 2: Encode — copy data into rep1 (q[1]) and rep2 (q[2])
cx q[0],q[1];
cx q[0],q[2];

// STAGE 3: Inject bit-flip error on rep1 (q[1])
x q[1];

// STAGE 4: Syndrome measurement
//   anc0 (q[3]) accumulates parity of data XOR rep1
cx q[0],q[3];
cx q[1],q[3];
measure q[3] -> c[3];
//   anc1 (q[4]) accumulates parity of rep1 XOR rep2
cx q[1],q[4];
cx q[2],q[4];
measure q[4] -> c[4];

