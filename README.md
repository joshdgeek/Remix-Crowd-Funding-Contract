A simple paymemt and withdraw smart contract written specificallly to be run on remix.
- To deploy on a real EVM testnet, USE THE INE OF CODE BELOW:
require(PriceLogic.ConvertWeiToUSD(msg.value) >= minimumDonation, "not up to minimum donation");