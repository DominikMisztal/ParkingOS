class PaymentCalculator {
  Map<String, List<double>> tariffsMap = {};

  PaymentCalculator({required this.tariffsMap});

  double calculatePaymentFromTime(DateTime parkingStart, DateTime parkingEnd) {
    int parkingDuration = parkingEnd.difference(parkingStart).inHours;
    if (parkingEnd.difference(parkingStart).inMinutes > 0) {
      parkingDuration += 1;
    }

    return calculatePaymentFromHours(parkingStart, parkingDuration);
  }

  double calculatePaymentFromHours(DateTime parkingStart, int hours) {
    int currentStayDuration = 0;
    double currentPayment = 0.0;
    List<double> tariff_1_values = tariffsMap[tariffsMap.keys.first]!;
    List<double> tariff_2_values = tariffsMap[tariffsMap.keys.last]!;
    int tariff_1_start = int.parse(tariffsMap.keys.first);
    int tariff_2_start = int.parse(tariffsMap.keys.last);

    int tariff_1_len = tariff_1_values.length;
    int tariff_2_len = tariff_2_values.length;
    for (; hours > 0; hours--) {
      if (parkingStart.hour > tariff_1_start) {
        currentPayment += currentStayDuration < tariff_1_len
            ? tariff_1_values[currentStayDuration]
            : tariff_1_values.last;
        currentStayDuration += 1;
        parkingStart.add(Duration(hours: 1));
      } else if (parkingStart.hour > tariff_2_start ||
          parkingStart.hour < tariff_1_start) {
        currentPayment += currentStayDuration < tariff_2_len
            ? tariff_2_values[currentStayDuration]
            : tariff_2_values.last;
        currentStayDuration += 1;
        parkingStart.add(Duration(hours: 1));
      }
    }
    return currentPayment;
  }
}
