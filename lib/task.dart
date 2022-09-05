class Task {
  // Class properties
  // Underscore makes them private
  String _name;
  String _description;
  bool _completed;
  DateTime _dateTime;

  // Default constructor
  // this syntax means that it will accept a value and set it to this.name
  //Task(this._name, this._description);
  Task(this._name);
  // Getter and setter for name
  getName() => this._name;
  setName(name) => this._name = name;

  // Getter and setter for description
  getDescription() => this._description;
  setDescription(description) => this._description = description;

  // Getter and setter for completed
  isCompleted() => this._completed;
  setCompleted(completed) => this._completed = completed;

  getDateTime() => this._dateTime;
  setDateTime() => this._dateTime;
}
