use('hw6');

db.students.aggregate([
  {
    $lookup: {
      from: "student_groups",
      localField: "_id",
      foreignField: "_id",
      as: "group_info"
    }
  },
  {
    $unwind: "$group_info"
  },
  {
    $addFields: {
      group: "$group_info.group"
    }
  },
  {
    $project: {
      group_info: 0
    }
  },
  {
    $merge: {
      into: "students",
      whenMatched: "merge",
      whenNotMatched: "fail"
    }
  }
]);




