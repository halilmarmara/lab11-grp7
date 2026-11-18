# Lab 11 - Counters and Dividers

In this lab, we learned how to make clock dividers from two types of counters.

## Rubric

| Item | Description | Value |
| ---- | ----------- | ----- |
| Summary Answers | Your writings about what you learned in this lab. | 25% |
| Question 1 | Your answers to the question | 25% |
| Question 2 | Your answers to the question | 25% |
| Question 3 | Your answers to the question | 25% |

## Names

## Summary
In this lab, we learned how to use flip-flops to build counters and clock dividers. We worked with two different types of counters: a modulo counter and a ripple counter. We used the center button as the input clock and tried to divide the signal by 12 using the modulo counter and by 8 using the ripple counter. After writing the Verilog code in Vivado, we also tested both circuits on the Basys 3 board and got the expected results.
## Lab Questions

### 1 - Why does the Modulo Counter actually divide clocks by 2 * Count?
Because the output toggles only when the counter reaches the target count. One toggle changes the output from 0 to 1, and the next toggle changes it from 1 to 0. Therefore, it takes two complete counts to make one full clock cycle. This is why the actual division is 2 times the count.
### 2 - Why does the ring counter's output go to all 1s on the first clock cycle?
Because all the flip-flops receive the same initial clock signal, but their outputs change at slightly different times. The change in one flip-flop triggers the next one before the previous signal has fully settled. This causes a ripple effect, making the output temporarily or initially appear as all 1s.
### 3 - What width of ring counter would you use to get to an output of ~1KHz?
The Basys 3 board has a 100 MHz input clock. Each T-FlipFlop divides the frequency by 2. We need to divide 100 MHz by approximately 1,000 Hz.
100,000,000 / 1,000 = 100,000
Since each flip-flop divides the frequency by 2, we need:
2^N ≈ 100,000
2^16 = 65,536 and 2^17 = 131,072.
Therefore, we would use a 17-bit ring counter to get an output close to 1 KHz.
