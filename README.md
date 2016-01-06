# Line of Credit

It should have

* Have a built in APR and credit limit
* Be able to draw money and make payments
  * *You can do this by making negative-value transactions, eg -300 is a payment of 300*
* Keep track of principal balance over real number of days
* APR Calculation based on outstanding principal balance over real number of days
* Interest is not compounded
* Keep track of transactions
* 30 day payment periods based on principal over actual number of days outstanding during the period
  * *This is actually based off the beginning/end of a month, so January has 31 days for example*

The calculated amounts will be slightly off due to the difference in the number of days (31 vs 30 this month)

## How to use it

1. Visit http://avant.eriksingleton.com
2. Type in any email to log in/create an account
3. Create a `New Credit Line` with the parameters you want
4. Click on the newly created Credit Line
5. Create `New Transaction`s until you're satisfied
  * You'll be restricted to just this month via front end
  * There is no restriction via back end right now
6. Click `Calculate Interest` to create a new transaction that is for the amount of your interest over the payment period
  * If you add new transactions after calculating your interest, you must recalculate to get a correct estimate of the owed interest

## With More Time...

I would've:

1. Cleaned up some of my angular templates
  * Perhaps moved them to separate files
2. Made the interface a bit nicer, though angular-material is pretty cool
3. Added more unit tests to rails, though I think I covered some of the more important ones
4. Made it possible to create transactions across multiple months
5. Cleaned up the `CreditLine.recalculate_transaction_balances` method, and how the detection takes place in the `Transaction` model

Though this is probably a fair representation of the code I output over the course of a few days.

## Questions?

Feel free to ask if you have any questions regarding the implementation.
