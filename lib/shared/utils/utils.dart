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
}
