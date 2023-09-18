pub fn nth(n: usize) -> u32 {
    let mut num: u32 = 2;
    let mut primes = vec![0; 100000];
    let mut number_of_primes: usize = 0;

    loop {
        let mut prime = true;
        if num < 10 {
            let max_factorial = (num / 2) + 1;
            for x in 2..max_factorial {
                if num % x == 0 {
                    prime = false;
                    break;
                }
            }
        } else {
            for x in 2..10 {
                if num % x == 0 {
                    prime = false;
                    break;
                }
            }

            let mut prime_index = 0;
            loop {
                if prime_index > (num / 2)
                    || prime_index > number_of_primes as u32
                    || primes[prime_index as usize] == 0
                {
                    break;
                }
                if num % primes[prime_index as usize] == 0 {
                    prime = false;
                    break;
                }
                prime_index = prime_index + 1;
            }
        }
        if prime {
            println!("Prime {} is {}", number_of_primes, num);
            primes[number_of_primes] = num;
            number_of_primes = number_of_primes + 1;
        }
        num = num + 1;
        if number_of_primes > n {
            break;
        }
    }
    primes[n]
}
