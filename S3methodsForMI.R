### Additional S3 methods for the "MI" class objects created by Zelig/Amelia II

## print method
print.MI <- function(object) {

    ## Work on one element at a time
    sapply(object,
           function(imp) {

               print(imp$result)
               cat("--------------------------------------------------------------------------------\n")
           })
    ## No meaningful return value
    return(invisible(NULL))
}
## Example
print(modelMiZelig)


## coef method
coef.MI <- function(object, simplify = FALSE) {

    ## Work on one element at a time
    sapply(object,
           function(imp) {

               ## Extract coefficients from the model
               coef(imp$result)
           },
           ## Determine if the result should be simplified to a matrix
           simplify = simplify)
}
## Examples
coef(modelMiZelig, simplify = TRUE)
coef(modelMiZelig)
