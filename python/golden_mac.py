import numpy as np

def mac_dot(w, a):
    """Reference: INT8 dot product with int32 accumulation."""
    w = np.array(w, dtype=np.int32)
    a = np.array(a, dtype=np.int32)
    return int(np.sum(w * a))

# sanity tests
print(mac_dot([1, 2, 3], [4, 5, 6]))        # 32
print(mac_dot([-128, -128], [-128, -128]))   # 32768
print(mac_dot([127]*64, [127]*64))           # 1032256

rng = np.random.default_rng(1)
N = 1000
w = rng.integers(-128, 128, N)
a = rng.integers(-128, 128, N)
acc = 0
with open("../data/mac_vectors.txt", "w") as f:
    for wi, ai in zip(w, a):
        acc += int(wi) * int(ai)
        f.write(f"{wi & 0xFF:02x} {ai & 0xFF:02x} {acc & 0xFFFFFFFF:08x}\n")