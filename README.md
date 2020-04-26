#  Project 1 - Vampire Number
-------
An interesting kind of number in mathematics is vampire number (Links to an external site.). A vampire number is a composite (Links to an external site.) natural number (Links to an external site.) with an even number of digits, that can be factored into two natural numbers each with half as many digits as the original number and not both with trailing zeroes, where the two factors contain precisely all the digits of the original number, in any order, counting multiplicity.  A classic example is: 1260= 21 x 60.

A vampire number can have multiple distinct pairs of fangs. A vampire numbers with 2 pairs of fangs is: 125460 = 204 × 615 = 246 × 510.

The goal of this first project is to use Elixir and the actor model to build a good solution to this problem that runs well on multi-core machines.

#### Group Members
------------
Subham Agrawal | UFID - 79497379
Pranav Puranik | UFID - 72038540

#### Steps to run
-------------
From the project directory run...
```
$ mix run proj1.exs 100000 200000
```

#### Number of worker actors
---------------
200 workers...

#### Size of the work unit
---------------
- Each worker solves for 500 vampire numbers.
- We used *trial and error*  to determine the worker actors.
- We created  10000, 1000, 500, 100, 10, 5 actors for many different architectures. With workers more than 200, the parallelism is high but the real-time is also high. Otherwise with lower workers, parallelism is low and real time is high. For us, 200 workers gave an optimum solution. 
- This is our final architecture...
![Check images folder or the docs, we will upload image after grading... ](/images/Architecture.PNG)
- Also, index.html in docs folder has more information about the project architecture...

#### Result
------------
```
102510 201 510
104260 260 401
105210 210 501
105264 204 516
105750 150 705
108135 135 801
110758 158 701
115672 152 761
116725 161 725
117067 167 701
118440 141 840
120600 201 600
123354 231 534
124483 281 443
125248 152 824
125433 231 543
125460 204 615 246 510
125500 251 500
126027 201 627
126846 261 486
129640 140 926
129775 179 725
131242 311 422
132430 323 410
133245 315 423
134725 317 425
135828 231 588
135837 351 387
136525 215 635
136948 146 938
140350 350 401
145314 351 414
146137 317 461
146952 156 942
150300 300 501
152608 251 608
152685 261 585
153436 356 431
156240 240 651
156289 269 581
156915 165 951
162976 176 926
163944 396 414
172822 221 782
173250 231 750
174370 371 470
175329 231 759
180225 225 801
180297 201 897
182250 225 810
182650 281 650
186624 216 864
190260 210 906
192150 210 915
193257 327 591
193945 395 491
197725 275 719
```

#### Running Time
------------
1.217 seconds

#### Ratio of CPU to Real time
---------------
Real time = 1.217 s
User time = 3.880 s
System time = 0.111 s
CPU/Real time = 3.28

#### Largest Vampire Number using the program
-------------
8 digits - 96977920
```
$ mix run proj1.exs 90000000 100000000 was successfull
90154989 9489 9501
...
96977920 9776 9920
```

#### (Top) References
-------------

[1] https://elixir-lang.org/
[2] https://elixirschool.com/
[3] https://hexdocs.pm/elixir/
[4] https://rosettacode.org/wiki/Vampire_number#Elixir (We also achieved 0.8 seconds real-time by optimizing some functions of this code)
[5] https://www.geeksforgeeks.org/vampire-number/