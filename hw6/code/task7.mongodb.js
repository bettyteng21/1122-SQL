use('hw6');

db.students.aggregate([
  {
    $match: {
      group: { $exists: true, $ne: null }
    }
  },
  {
    $group: {
      _id: "$group",
      members: { $push: "$name" }
    }
  },
  {
    $project: {
      _id: 0,
      group: "$_id",
      members: 1
    }
  }
]);








