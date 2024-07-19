use('hw6');

db.students.updateMany(
  {},
  {
    $set: { updated: ISODate("2024-05-23T00:00:00Z") }
  }
);

db.students.find(
  { dept: "電機所" }, 
  { _id: 0, position: 1, dept: 1, updated: 1 }
);



