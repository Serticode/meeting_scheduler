class AppUtils {
  const AppUtils._();

//!
//! FETCH MONTH NAME
  static String getMonth({required DateTime dateTime}) {
    String theMonth = "";
    switch (dateTime.month) {
      case 1:
        theMonth = "Jan";
        return theMonth;
      case 2:
        theMonth = "Feb";
        return theMonth;
      case 3:
        theMonth = "Mar";
        return theMonth;
      case 4:
        theMonth = "Apr";
        return theMonth;
      case 5:
        theMonth = "May";
        return theMonth;
      case 6:
        theMonth = "Jun";
        return theMonth;
      case 7:
        theMonth = "Jul";
        return theMonth;
      case 8:
        theMonth = "Aug";
        return theMonth;
      case 9:
        theMonth = "Sep";
        return theMonth;
      case 10:
        theMonth = "Oct";
        return theMonth;
      case 11:
        theMonth = "Nov";
        return theMonth;
      case 12:
        theMonth = "Dec";
        return theMonth;

      //! DEFAULT VALUES
      default:
        theMonth = "Could not fetch the month";
        return theMonth;
    }
  }

  //!
//! FETCH MONTH NAME
  static int getMonthNumber({required String monthName}) {
    int monthNumber = 0;
    switch (monthName) {
      case "Jan":
        monthNumber = 1;
        return monthNumber;
      case "Feb":
        monthNumber = 2;
        return monthNumber;
      case "Mar":
        monthNumber = 3;
        return monthNumber;
      case "Apr":
        monthNumber = 4;
        return monthNumber;
      case "May":
        monthNumber = 5;
        return monthNumber;
      case "Jun":
        monthNumber = 6;
        return monthNumber;
      case "Jul":
        monthNumber = 7;
        return monthNumber;
      case "Aug":
        monthNumber = 8;
        return monthNumber;
      case "Sep":
        monthNumber = 9;
        return monthNumber;
      case "Oct":
        monthNumber = 10;
        return monthNumber;
      case "Nov":
        monthNumber = 11;
        return monthNumber;
      case "Dec":
        monthNumber = 12;
        return monthNumber;

      //! DEFAULT VALUES
      default:
        monthNumber = 1;
        return monthNumber;
    }
  }

  //!
  static const List<String> listOfMonths = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> listOfDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];
}
