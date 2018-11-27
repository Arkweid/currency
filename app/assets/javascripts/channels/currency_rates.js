App.rates = App.cable.subscriptions.create("CurrencyRatesChannel", {
  connected() {},

  disconnected() {},

  received(data) {
    var usd = $('#usd')

    if (usd) {
      usd.text(data['usd']);
    }
  }
});
