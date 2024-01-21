class PaymentCalculator {
  DateTime tariff_1_start;
  List<double> tariff_1_values;
  DateTime tariff_2_start;
  List<double> tariff_2_values;

  PaymentCalculator({
    required this.tariff_1_start,
    required this.tariff_1_values,
    required this.tariff_2_start,
    required this.tariff_2_values,
  });

  double calculatePaymentFromTime(DateTime parkingStart, DateTime parkingEnd) {
    int parkingDuration = parkingEnd.difference(parkingStart).inHours;
    if (parkingEnd.difference(parkingStart).inMinutes > 0) {
      parkingDuration += 1;
    }

    return calculatePaymentFromHours(parkingStart, parkingDuration);
  }

  double calculatePaymentFromHours(DateTime parkingStart, int hours) {
    int currentStayDuration = 0;
    int parkingDuration = hours;
    double currentPayment = 0.0;

    int tariff_1_len = tariff_1_values.length;
    int tariff_2_len = tariff_2_values.length;
    for (; hours > 0; hours--) {
      if (parkingStart.hour > tariff_1_start.hour) {
        currentPayment += currentStayDuration > tariff_1_len
            ? tariff_1_values[currentStayDuration]
            : tariff_1_values.last;
        currentStayDuration += 1;
      } else if (parkingStart.hour > tariff_2_start.hour ||
          parkingStart.hour < tariff_1_start.hour) {
        currentPayment += currentStayDuration > tariff_1_len
            ? tariff_1_values[currentStayDuration]
            : tariff_1_values.last;
        currentStayDuration += 1;
      }
    }
    return currentPayment;
  }
}
