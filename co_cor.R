setwd("/Users/ryo/Documents/R/R_study/co-cor/input")
library(tuneR)

win_ln <- 2 / 1000 * 48000 ## sample

close.screen(all = T)
pwd <- sprintf("%s", getwd())
fnames <- list.files(path = pwd, pattern = "*.wav")

for (fname in fnames) {
  wav_l <- readWave(fname)@left
  wav_r <- readWave(fname)@right
  fs <- readWave(fname)@samp.rate
  ln <- length(wav_l)
  index <- 1
  i <- 1
  cor_dat <- numeric(ln / win_ln)
  while (index <= ln) {
    data_l <- wav_l[index:(index + win_ln - 1)]
    data_r <- wav_r[index:(index + win_ln - 1)]
    cor_dat[i] <- cor(data_l, data_r)
    index <- index + win_ln
    i <- i + 1
  }
  t <- seq(0, ln / fs, length = ln / win_ln)
  setwd("/Users/ryo/Documents/R/R_study/co-cor/out")
  png(sprintf("%s.png", substring(fname, 1, (nchar(fname) - 4))), width = 1080, height = 1080)
  par(mgp = c(2.3, 0.7, 0))
  plot(t, cor_dat, xlim = c(0, 2), type = "p", ylab = "IAC", xlab = "time(sec)", cex.lab = 1.7, cex.axis = 1.5, ylim = c(-1, 1)) # ,main = sprintf("%s", fname))
  dev.off()
  setwd("/Users/ryo/Documents/R/R_study/co-cor/input")
}
