use('hw6');

// Update new_student
db.students.updateMany(
  { _id: { $in: ["b19303008", "b19303129", "r09303019"] } },
  { $set: { updated: ISODate("2024-06-01T00:00:00Z") } }
);

// Update myself
db.students.updateOne(
  { name: "鄧雅文 (TENG, YA-WEN)" }, 
  { $set: { updated: ISODate("2024-06-01T00:00:00Z") } }
);

db.students.find(
  { updated: ISODate("2024-06-01T00:00:00Z") },
  { _id: 0, position: 1, dept: 1, updated: 1, name: 1, email: 1 }
);



