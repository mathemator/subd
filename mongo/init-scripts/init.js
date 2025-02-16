db = db.getSiblingDB("mydatabase");  // Переключаемся на нужную БД

db.users.insertMany([
    { name: "Alice", birthDate: new Date("1998-04-15"), city: "New York", email: "alice@example.com" },
    { name: "Bob", birthDate: new Date("1993-06-20"), city: "San Francisco", email: "bob@example.com" },
    { name: "Charlie", birthDate: new Date("1988-11-11"), city: "Los Angeles", email: "charlie@example.com" },
    { name: "David", birthDate: new Date("1983-02-25"), city: "Chicago", email: "david@example.com" },
    { name: "Eve", birthDate: new Date("1978-09-30"), city: "Miami", email: "eve@example.com" }
]);

for (let i = 0; i < 100; i++) {
    db.users.insertOne({
        name: "User_" + i,
        birthDate: new Date(
            new Date().setFullYear(1950 + Math.floor(Math.random() * 50))
        ),
        email: "user" + i + "@example.com",
        city: ["Moscow", "Berlin", "New York", "Tokyo", "Paris"][Math.floor(Math.random() * 5)]
    });
}

db.users.createIndex({birthDate: 1});