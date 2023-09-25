source("R/I2Rmodel_script.R")

# Economic Analysis -------------------------------------------------------
## Costs -------------------------------------------------------------------
# Drug costs
c_AZT <- 2278 # Zidovudine drug cost (monotherapy)
c_Lam <- 2086.50 # Lamivudine drug cost (added therapy)

# Direct health state costs
c_direct_state_A <- 1701 # direct costs associated with health state A
c_direct_state_B <- 1774 # direct costs associated with health state B
c_direct_state_C <- 6948 # direct costs associated with health state C
# Indirect health state costs
c_indirect_state_A <- 1055 # indirect costs associated with health state A
c_indirect_state_B <- 1278 # indirect costs associated with health state B
c_indirect_state_C <- 2059 # indirect costs associated with health state C

# Vector of costs:
v_c_SoC <- c(c_direct_state_A + c_indirect_state_A, 
             c_direct_state_B + c_indirect_state_B, 
             c_direct_state_C + c_indirect_state_C, 
             0)
# Array of state costs for Standard of Care
a_c_SoC <- array(matrix(v_c_SoC, nrow = n_states, ncol = n_states, byrow = T),
                  dim = c(n_states, n_states, n_cycles + 1),
                  dimnames = list(v_names_states, v_names_states, 0:n_cycles))
# Note: the advantage of creating a cost array with the same dimensions as the 
# transition array is that you can take advantage of vectorisation - which is very
# fast in R.

# Add drug costs
a_c_SoC[ , c("A", "B", "C"), ] <- a_c_SoC[ , c("A", "B", "C"), ] + c_AZT  # drug costs for SoC
a_c_NT <- a_c_SoC # create New Treatment costs array 
a_c_NT[ , c("A", "B", "C"), 1:2] <- a_c_NT[ , c("A", "B", "C"), 1:2] + c_Lam # drug costs for NT (combination therapy for first two cycles, mono therafter)

# Total costs
## Standard of Care
a_Y_c_SoC <- a_A_SoC * a_c_SoC
## Standard of Care
a_Y_c_NT <- a_A_NT * a_c_NT

# Calculate total costs per cycle
m_costs_SoC <- rowSums(t(colSums(a_Y_c_SoC))) # SoC
m_costs_NT <- rowSums(t(colSums(a_Y_c_NT))) # New Treatment

## Life Years --------------------------------------------------------------
# Standard of Care
m_lys_SoC <- rowSums(t(colSums(a_A_SoC[, c("A", "B", "C"), ]))) # LYs per cycle
sum(rowSums(t(colSums(a_A_SoC[, c("A", "B", "C"), ])))) # Total LYs

# New Treatment
m_lys_NT <- rowSums(t(colSums(a_A_NT[, c("A", "B", "C"), ]))) # LYs per cycle
sum(rowSums(t(colSums(a_A_NT[, c("A", "B", "C"), ])))) # Total LYs

## Discounting -------------------------------------------------------------
# Discount rates
d_e <- 0.0
d_c <- 0.06
# Discount weights for costs
v_dwc <- 1 / ((1 + d_c) ^ (0:n_cycles))
# Discount weights for effects
v_dwe <- 1 / ((1 + d_e) ^ (0:n_cycles))

# Apply discount
v_lys_disc_SoC <- t(m_lys_SoC) %*% v_dwe # SoC QALYs
v_costs_disc_SoC <- t(m_costs_SoC) %*% v_dwc # SoC costs

v_lys_disc_NT <- t(m_lys_NT) %*% v_dwe # NT QALYs
v_costs_disc_NT <- t(m_costs_NT) %*% v_dwc # NT costs

## ICER --------------------------------------------------------------------
icer <- (v_costs_disc_NT - v_costs_disc_SoC) / (v_lys_disc_NT - v_lys_disc_SoC) # deterministic icer
icer # where NT is the reference treatment

# End of file -------------------------------------------------------------


####Final exercise----

##Utilities
u_A<-0.8
u_B<-0.65
u_C<-0.60
u_Death<-0

# Vector of utilities:
v_u_SoC <- c(u_A,u_B,u_C,u_Death)
v_u_NT<-v_u_SoC

# Array of utilities for Standard of Care
a_u_SoC <- array(matrix(v_u_SoC, nrow = n_states, ncol = n_states, byrow = T),
                 dim = c(n_states, n_states, n_cycles + 1),
                 dimnames = list(v_names_states, v_names_states, 0:n_cycles))

a_u_NT<-a_u_SoC

# Total QALY per cycle
## Standard of Care
a_Y_u_SoC <- a_A_SoC * a_u_SoC
## New treatment
a_Y_u_NT <- a_A_NT * a_u_NT
# Calculate total QALYs per cycle
m_u_SoC <- rowSums(t(colSums(a_Y_u_SoC))) # SoC
m_u_NT <- rowSums(t(colSums(a_Y_u_NT))) # New Treatment

#Total QALYs
# Standard of Care
(n_QALYs_SoC<-sum(m_u_SoC))
# New Treatment
(n_QALYs_SoC<-sum(m_u_NT))


# Discount rates
d_e <- 0.03
d_c <- 0.06
# Discount weights for costs
v_dwc <- 1 / ((1 + d_c) ^ (0:n_cycles))
# Discount weights for effects
v_dwe <- 1 / ((1 + d_e) ^ (0:n_cycles))

# Apply discount
v_QALY_disc_SoC <- t(m_u_SoC) %*% v_dwe # SoC QALYs
v_costs_disc_SoC <- t(m_costs_SoC) %*% v_dwc # SoC costs

v_QALY_disc_NT <- t(m_u_NT) %*% v_dwe # NT QALYs
v_costs_disc_NT <- t(m_costs_NT) %*% v_dwc # NT costs

## ICER --------------------------------------------------------------------
icer <- (v_costs_disc_NT - v_costs_disc_SoC) / (v_QALY_disc_NT - v_QALY_disc_SoC) # deterministic icer
icer # where NT is the reference treatment




