# V
------------------------
An interesting kind of number in mathematics is vampire number (Links to an external site.). A vampire number is a composite (Links to an external site.) natural number (Links to an external site.) with an even number of digits, that can be factored into two natural numbers each with half as many digits as the original number and not both with trailing zeroes, where the two factors contain precisely all the digits of the original number, in any order, counting multiplicity.  A classic example is: 1260= 21 x 60.

A vampire number can have multiple distinct pairs of fangs. A vampire numbers with 2 pairs of fangs is: 125460 = 204 × 615 = 246 × 510.

The goal of this first project is to use Elixir and the actor model to build a good solution to this problem that runs well on multi-core machines.



#### Group Members
------------
Subham Agrawal | UFID - 79497379
Pranav Puranik | UFID - 72038540

#### Steps to run
-------------
 Start all the nodes by typing the following command from the project directory:
  ```
$ iex --name node_name@ip_address --cookie choclate -S mix
```
Eg name - foo@192.168.0.2

Then, from the main_node, type the command:
  ```
  $ V.Registry.create([:"node_1@ip_1", :"node_2@ip_2", ...], 1000000000, 2000000000)
```
  Output:
  ```
All the nodes compute and print the vampire numbers on their screens.
```

#### Number of worker actors
---------------
200 workers per node.


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

#### Largest Vampire Number using the program
-------------


#### (Top) References
-------------
[1] https://elixir-lang.org/
[2] https://elixirschool.com/
[3] https://hexdocs.pm/elixir/
[4] https://rosettacode.org/wiki/Vampire_number#Elixir
[5] https://www.geeksforgeeks.org/vampire-number/


