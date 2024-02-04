import 'dart:math';
import 'dart:convert';

class Region {
  double x1;
  double y1; 
  double x2;
  double y2;
  Region(
    this.x1,
    this.y1,
    this.x2,
    this.y2,
  );
}

class Event {
  int index;
  double x;
  int state;
  Event(this.index, this.x, this.state);
}

List<Region> savedLocation = [];

saveLoaction(Region rect) {
  
  if (savedLocation.isEmpty) {
    savedLocation.add(rect);
    return true;
  } else {
    
    List<Event> eventList = [];
    var filteredLocation = [];
    // Check overlap
    for (var i = 0; i < savedLocation.length; i++) {
      var location = savedLocation[i];
      
      if (location.x1 <= rect.x1 
          && location.x2 >= rect.x1
          && location.y1 >= rect.y1
          && location.y2 <= rect.y1) {
        filteredLocation.add(location);
      } else
      if (location.x1 <= rect.x2 
          && location.x2 >= rect.x2
          && location.y1 >= rect.y1
          && location.y2 <= rect.y1) {
        filteredLocation.add(location);
      } else
      if (location.x1 <= rect.x1 
          && location.x2 >= rect.x1
          && location.y1 >= rect.y2
          && location.y2 <= rect.y2) {
        filteredLocation.add(location);
      } else
      if (location.x1 <= rect.x2 
          && location.x2 >= rect.x2
          && location.y1 >= rect.y2
          && location.y2 <= rect.y2) {
        filteredLocation.add(location);
      }
    }
    
    // Make Event list
    for (var i = 0; i < filteredLocation.length; i++) {
      var location = filteredLocation[i];
      Event start = Event(i, location.x1, 0);
      Event end = Event(i, location.x2, 1);
      eventList.add(start);
      eventList.add(end);
    }
    
    // Add current event
    Event mStart = Event(-1, rect.x1, 0);
    Event mEnd = Event(-1, rect.x2, 1);

    eventList.add(mStart);
    eventList.add(mEnd);

    // Sort eventList by x, state
    eventList.sort((a, b) {
      if (a.x != b.x) {
        return a.x.compareTo(b.x);
      }
      if (a.state != b.state) {
        return a.state.compareTo(b.state);
      }
      if (a.state == 0) {
        if (a.index == -1) {
          return 1; // Move even numbers to the front
        } else if (b.index == -1) {
          return -1; // Move odd numbers to the back
        }
      }
      if (a.state == 1) {
        if (a.index == -1) {
          return -1; // Move even numbers to the front
        } else if (b.index == -1) {
          return 1; // Move odd numbers to the back
        }
      }
      return a.index.compareTo(b.index);
    });
    
    // Scan
    var indexList = [];
    for (var event in eventList) {
      if (event.state == 0 && event.index != -1) {
        indexList.add(event.index);
      } else if (event.state == 1 && event.index != -1) {
        indexList.remove(event.index);
        // Check
        if (!checkLocation(indexList, filteredLocation, rect)) {
          savedLocation.add(rect);
          return true;
        };
      } else if (event.state == 0 && event.index == -1) {
        // Check
        if (!checkLocation(indexList, filteredLocation, rect)) {
          savedLocation.add(rect);
          return true;
        };
      } else if (event.state == 1 && event.index == -1) {
        // Check
        if (checkLocation(indexList, filteredLocation, rect)) {
          return false;
        } else {
          savedLocation.add(rect);
          return true;
        };
      }
    }
  }
} 

checkLocation(dynamic indexList, dynamic filteredList, dynamic rect) {
  double start = rect.y1;
  double end = rect.y2;
  for (var i = 0; i < indexList.length; i++) {
    var location = filteredList[indexList[i]];
    if (location.y1 >= start && location.y2 <= start) {
      start = location.y2;
    } else if (location.y1 <= start && location.y2 <= end) {
      end = location.y1;
    }
    if (location.y1 >= start && location.y2 <= end) {
      return true;
    }
  }
  return false;
}

void main() {
  
  print(saveLoaction(Region(20, 40, 40, 20)));
  print(saveLoaction(Region(40, 40, 60, 20)));
  print(saveLoaction(Region(20, 60, 40, 40)));
  print(saveLoaction(Region(40, 60, 60, 40)));
  print(saveLoaction(Region(40, 60, 60, 40)));
  
  Region rect = Region(
    30, 
    50, 
    50, 
    30,
  );  
  
  print("=========================> ${savedLocation.length}");
  print("=========================> ${saveLoaction(rect)}");
  print("=========================> ${savedLocation.length}");
  
}

