use('hw6');

db.students.aggregate([
  {
    $match: {
      updated: {
        $gte: ISODate("2024-01-01T00:00:00Z"),
        $lte: ISODate("2024-05-31T23:59:59Z")
      }
    }
  },
  {
    $group: {
      _id: "$dept",
      count: { $sum: 1 }
    }
  },
  {
    $merge: {
      into: "tally",
      whenMatched: "merge",
      whenNotMatched: "insert"
    }
  }
]);

db.tally.find().forEach(printjson);




db.students.aggregate([
  {
    $match: {
      updated: {
        $gte: ISODate("2024-06-01T00:00:00Z"),
        $lte: ISODate("2024-06-30T23:59:59Z")
      }
    }
  },
  {
    $group: {
      _id: "$dept",
      count: { $sum: 1 }
    }
  },
  {
    $merge: {
      into: "tally",
      whenMatched: "merge",
      whenNotMatched: "insert"
    }
  }
]);

db.tally.find().forEach(printjson);
