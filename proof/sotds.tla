---- MODULE sotds ----
EXTENDS Integers,TLC, FiniteSets, Sequences

\* A simple trial division sieve for finding all primes between 1 and x
(*--algorithm trialDivision
variable
  \* Cheating here by using pre-computed values
  \* A "real" proof would compute these the hard way
  x = 100;
  numberOfPrimes = 25;

  i = 3;
  primes = {2};
  primeSeq = <<2>>;
  f = 2;
  index = 0;

define
  Half(num) == num \div 2
  IsComposite(num) ==
    \E m, n \in 2..Half(num):
      m * n = num
  IsPrime(num) == ~IsComposite(num)
  AllPrime(s) == \A p \in s: IsPrime(p)
  NoComposites == AllPrime(primes)
  SizeOfPrimes == pc = "Done" => Cardinality(primes) = numberOfPrimes
end define;

begin
  SOTDS:
    while i <= x do
      if i < 10 then
        f := 2;
        Factorisation:
          while f <= i do
            if i % f = 0 /\ i # f then
              goto Increment;
            end if;
            NotPrime:
              f := f + 1;
          end while;
      else
        index := 1;
        Factorisation2:
          \* Not sure how to iterate over the set primes
          \* So ended up creating a Sequence as well, which I'm sure is really inefficient
          while index <= Len(primeSeq) do
            if i % primeSeq[index] = 0 then
              goto Increment;
            end if;
            Factorisation3:
                index := index + 1;
          end while;
      end if;

      Prime:
        primes := primes \union {i};
        primeSeq := Append(primeSeq, i);
      
      Increment:
        i := i+2;
    end while;  
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "e00a957c" /\ chksum(tla) = "464111f9")
VARIABLES x, numberOfPrimes, i, primes, primeSeq, f, index, pc

(* define statement *)
Half(num) == num \div 2
IsComposite(num) ==
  \E m, n \in 2..Half(num):
    m * n = num
IsPrime(num) == ~IsComposite(num)
AllPrime(s) == \A p \in s: IsPrime(p)
NoComposites == AllPrime(primes)
SizeOfPrimes == pc = "Done" => Cardinality(primes) = numberOfPrimes


vars == << x, numberOfPrimes, i, primes, primeSeq, f, index, pc >>

Init == (* Global variables *)
        /\ x = 100
        /\ numberOfPrimes = 25
        /\ i = 3
        /\ primes = {2}
        /\ primeSeq = <<2>>
        /\ f = 2
        /\ index = 0
        /\ pc = "SOTDS"

SOTDS == /\ pc = "SOTDS"
         /\ IF i <= x
               THEN /\ IF i < 10
                          THEN /\ f' = 2
                               /\ pc' = "Factorisation"
                               /\ index' = index
                          ELSE /\ index' = 1
                               /\ pc' = "Factorisation2"
                               /\ f' = f
               ELSE /\ pc' = "Done"
                    /\ UNCHANGED << f, index >>
         /\ UNCHANGED << x, numberOfPrimes, i, primes, primeSeq >>

Prime == /\ pc = "Prime"
         /\ primes' = (primes \union {i})
         /\ primeSeq' = Append(primeSeq, i)
         /\ pc' = "Increment"
         /\ UNCHANGED << x, numberOfPrimes, i, f, index >>

Increment == /\ pc = "Increment"
             /\ i' = i+2
             /\ pc' = "SOTDS"
             /\ UNCHANGED << x, numberOfPrimes, primes, primeSeq, f, index >>

Factorisation == /\ pc = "Factorisation"
                 /\ IF f <= i
                       THEN /\ IF i % f = 0 /\ i # f
                                  THEN /\ pc' = "Increment"
                                  ELSE /\ pc' = "NotPrime"
                       ELSE /\ pc' = "Prime"
                 /\ UNCHANGED << x, numberOfPrimes, i, primes, primeSeq, f, 
                                 index >>

NotPrime == /\ pc = "NotPrime"
            /\ f' = f + 1
            /\ pc' = "Factorisation"
            /\ UNCHANGED << x, numberOfPrimes, i, primes, primeSeq, index >>

Factorisation2 == /\ pc = "Factorisation2"
                  /\ IF index <= Len(primeSeq)
                        THEN /\ IF i % primeSeq[index] = 0
                                   THEN /\ pc' = "Increment"
                                   ELSE /\ pc' = "Factorisation3"
                        ELSE /\ pc' = "Prime"
                  /\ UNCHANGED << x, numberOfPrimes, i, primes, primeSeq, f, 
                                  index >>

Factorisation3 == /\ pc = "Factorisation3"
                  /\ index' = index + 1
                  /\ pc' = "Factorisation2"
                  /\ UNCHANGED << x, numberOfPrimes, i, primes, primeSeq, f >>

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == SOTDS \/ Prime \/ Increment \/ Factorisation \/ NotPrime
           \/ Factorisation2 \/ Factorisation3
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 

====
