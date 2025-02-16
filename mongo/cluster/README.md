## Полезные команды для настройки шардинга
```bash
docker exec -it cluster-configsvr1-1 mongosh --port 27017
```
```js
rs.initiate({
_id: "configReplSet",
configsvr: true,
members: [
{ _id: 0, host: "configsvr1:27017" },
{ _id: 1, host: "configsvr2:27017" },
{ _id: 2, host: "configsvr3:27017" }
]
});
```

```bash
docker exec -it cluster-shard1-node1-1 mongosh --port 27018
```
```js
rs.initiate({
_id: "shard1ReplSet",
members: [
{ _id: 0, host: "shard1-node1:27018" },
{ _id: 1, host: "shard1-node2:27018" },
{ _id: 2, host: "shard1-node3:27018" }
]
});
```
```bash
docker exec -it cluster-shard2-node1-1 mongosh --port 27019
```
```js
rs.initiate({
_id: "shard2ReplSet",
members: [
{ _id: 0, host: "shard2-node1:27019" },
{ _id: 1, host: "shard2-node2:27019" },
{ _id: 2, host: "shard2-node3:27019" }
]
});
```
```bash
docker exec -it cluster-mongos-1 mongosh --port 27020
```
```js
sh.addShard("shard1ReplSet/shard1-node1:27018");
sh.addShard("shard2ReplSet/shard2-node1:27019");
```

#### Пример работающего шардинга
```js
db.users.createIndex({birthDate: 1});

sh.enableSharding("mydatabase");
sh.shardCollection("mydatabase.users", { birthDate: "hashed" });

use mydatabase;
for (let i = 10; i < 100; i++) {
db.users.insertOne({ name: "User" + i, birthDate: new Date(1970 + i % 50, 0, 1) });
}
```
#### Результат вызова 
```js 
sh.status();
```
```json
...
{
ns: 'mydatabase.users',
shards: [
{
shardName: 'shard2ReplSet',
numOrphanedDocs: 0,
numOwnedDocuments: 48,
ownedSizeBytes: 2784,
orphanedSizeBytes: 0
},
{
shardName: 'shard1ReplSet',
numOrphanedDocs: 0,
numOwnedDocuments: 42,
ownedSizeBytes: 2436,
orphanedSizeBytes: 0
}
]
}
...
```