# R: an analogy to understanding what's going on 'under-the-R-hood' -------
# here we assign the numeric value 2 to the object 'x'
x <- 2

# Vectors -----------------------------------------------------------------
# we can see the length of x using the following 'base' r function:
length(x)
# to expand on the above, we assign *several* ordered values to a single object 
# using the *concatenate* function:
x <- c(5, 3, 1, 5.2, 2.45, 10.4, 9, 2.2)
# and by calling the object we can see what values are associated with that 
# object:
print(x)
# or simply
x

# the problem of coercion:
temp <- c(1, 2, "4", 5, "3 31")
temp * 2
str(temp)

# Coercion ----------------------------------------------------------------
# R also allows manipulation of logical quantities:
# here we are just creating an object v and assigning values between 1:10 
# randomly, using the base sample() function:
v <- sample(x = c(1:10), size = 5, replace = TRUE)
# are the lengths of x and v equal?
length(x) == length(v)
# are the lengths of x and v not equal? (in R we use != operator to identifying 
# whether an object or value is not equal to another)
length(x) != length(v)
# is the length of v greater than/less than/greater or equal to/less than or 
# equal to v? (in R we use >, <, >=, <=, like in maths) 
length(x) > length(v)
length(x) < length(v)
length(x) >= length(v)
length(x) <= length(v)

# Lists -------------------------------------------------------------------
list_example <- list(1:3, "a", c(TRUE, FALSE, TRUE), c(2.3, 5.9))
list_example

# Manipulation:
1/x
1/x[1/x <= 1]
# the third value of x:
x[3]
# the third, fourth, and fifth value of x:
x[c(3, 4, 5)]
# ... note the concatenate function to specify multiple values!

# Vectorised arithmetic ---------------------------------------------------
# in r this is coded as:
y <- (1 / x) * cos(pi)
# and now that we have an object stored in memory, we can recall it without running the code (which is very handy when we have lots of code!). Note, the matrix function is being here to just make it look neat. We will touch on matrix operations shortly.
matrix(data = y, nrow = 4)

# but vectorisation problem
# create object
z <- c(1, 2, 3)
# product of x * z?
x * z

# For loops ---------------------------------------------------------------
# we first create a matrix object with `x` rows and `z` columns
g <- matrix(data = NA, nrow = length(x), ncol = length(z))
# then we iterate over the rows and columns, multiplying all the values of `x` with the j'th column of `z`. This means that the whole vector of `x` is multiplied by a single value of `z` until all values of `z` of been iterated over `x`.
for (i in 1:length(x)) {
 for (j in 1:length(z)) {
  g[i, j] <- x[i] * z[j]
 }
}

# 
print(z)
# then multiply by the second value of z
x * z[2]
# or the third value of z
x * z[3]

# Matrix multiplication ---------------------------------------------------
x_matrix <- matrix(data = x, nrow = length(x), ncol = length(z))
# and then, et voila!
x_matrix * z

# create matrix
matrix_temp <- matrix(data = rnorm(n = 10*5, mean = 0, sd = 1),
                      nrow = 10, ncol = 5)
# print results
matrix_temp
# create a vector of values:
vector_eg <- runif(n = 5, min = 0, max = 1)
# create object to store output
output_temp <- matrix(data = NA, nrow = 10, ncol = 5)
# iterate for-loop over nrows by ncols
for (i in 1:nrow(matrix_temp)) {
 output_temp[i, ] <- matrix_temp[i, ] %*% vector_eg
}

# End file ----------------------------------------------------------------