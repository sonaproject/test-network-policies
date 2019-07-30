# test-network-policies
Testing Kubernetes network policies behavior against SONA-CNI.

Before running the tests, setup Kubernetes with SONA-CNI:

Run all tests:
```
./test_netpol.sh
```

Run specific test:
```
# pass relative path to test file as argument
./test_netpol.sh tests/alllow-all-without-internet.sh 
```
