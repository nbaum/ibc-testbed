
.app_state.slashing.params.downtime_jail_duration = "600s" |

.app_state.slashing.params.signed_blocks_window = "400" |

.app_state.slashing.params.min_signed_per_window = "0.1" |

.app_state.staking.params.unbonding_time = "1814400s" |

.app_state.staking.params.bond_denom = "acudos" |

.app_state.staking.params.max_validators = "100" |

.app_state.crisis.constant_fee.denom = "acudos" |

.app_state.gov.deposit_params.min_deposit = [ { "denom": "acudos", "amount": "10000000" } ] |

.app_state.gov.deposit_params.max_deposit_period = "600s" |

.app_state.gov.voting_params.voting_period = "600s" |

.app_state.gov.tally_params.quorum = "0.334" |

.app_state.gov.tally_params.threshold = "0.5" |

.app_state.gov.tally_params.veto_threshold = "0.334" |

.app_state.bank.denom_metadata = [{
  "symbol": "cudos",
  "name": "CUDOS",
  "description": "The native staking token of the Cudos Hub",
  "base": "acudos",
  "display": "cudos",
  "denom_units": [
    { "denom": "acudos", "exponent": "0" },
    { "denom": "fcudos", "exponent": "3" },
    { "denom": "pcudos", "exponent": "6" },
    { "denom": "ncudos", "exponent": "9" },
    { "denom": "ucudos", "exponent": "12" },
    { "denom": "mcudos", "exponent": "15" },
    { "denom": "cudos",  "exponent": "18" },
    { "denom": "kcudos", "exponent": "21" },
    { "denom": "Mcudos", "exponent": "24" },
    { "denom": "Gcudos", "exponent": "27" },
    { "denom": "Tcudos", "exponent": "30" },
    { "denom": "Pcudos", "exponent": "33" },
    { "denom": "Rcudos", "exponent": "36" },
    { "denom": "Qcudos", "exponent": "37" }
  ]
}] |

.app_state.gravity.erc20_to_denoms = [
  {
    "erc20": "0x28ea52f3ee46CaC5a72f72e8B3A387C0291d586d",
    "denom": "acudos"
  }
] |

.app_state.gravity.static_val_cosmos_addrs = [$VALIDATOR_ADDRESS]
