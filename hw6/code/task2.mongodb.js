use('hw6');

db.students.aggregate([
  {
    $match: { position: "學生" }
  },
  {
    $group: {
      _id: "$dept",
      count: { $sum: 1 }
    }
  },
  {
    $sort: { count: -1 }
  },
  {
    $limit: 10
  }
]);




