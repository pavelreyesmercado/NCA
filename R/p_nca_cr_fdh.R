p_nca_cr_fdh <-
function (loop.data, bn.data) {
  x <- loop.data$x
  y <- loop.data$y

  # Find the points on the ceiling ("PEERS")
  peers <- p_peers(loop.data)

  if (!is.vector(peers) && length(peers) > 2) {
    # Perform OLS through the peers
    x <- peers[,1]
    y <- peers[,2]
    line <- lm(y~x)
    
    intercept <- unname(coef(line)["(Intercept)"])
    slope     <- unname(coef(line)["x"])
    ceiling   <- p_ceiling(loop.data, slope, intercept)
    above     <- p_above(loop.data, slope, intercept)
  } else {
    line      <- NULL
    ceiling   <- 0
    intercept <- NA
    slope     <- NA
    above     <- 0
  }

  effect      <- ceiling / loop.data$scope.area
  accuracy    <- p_accuracy(loop.data, above)
  fit         <- get_fit(ceiling, loop.data$ce_fdh_ceiling)
  ineffs      <- p_ineffs(loop.data, slope, intercept)
  bottleneck  <- p_bottleneck(loop.data, bn.data, slope, intercept)

  return(list(line=line,
              slope=slope, intercept=intercept,
              ceiling=ceiling, effect=effect,
              above=above, accuracy=accuracy, fit=fit,
              ineffs=ineffs, bottleneck=bottleneck))
}