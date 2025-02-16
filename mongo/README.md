## Знакомство с MongoDB 🛢️📄

- База проинициализирована в контейнере 📦  
с инициализирующим js-скриптом **init.js**

### Примеры команд
1️⃣ Запрос на выборку по дате с используем сравнения и типов JS
```js 
db.users.find({
  birthDate: { $lte: new Date(new Date().setFullYear(new Date().getFullYear() - 75)) }
});
```
#### Результат:
```json 
{
  _id: ObjectId('67b1d4642f5cc151d2544cda'),
  name: 'User_46',
  birthDate: 1950-02-16T12:04:52.085Z,
  email: 'user46@example.com',
  city: 'Tokyo'
}
{
  _id: ObjectId('67b1d4642f5cc151d2544d0d'),
  name: 'User_97',
  birthDate: 1950-02-16T12:04:52.121Z,
  email: 'user97@example.com',
  city: 'Paris'
}
```

2️⃣ 
```js
db.users.updateOne({ email: "alice@example.com" }, { $set: { city: "Boston" } });
```
#### Результат:
```json 
{
  acknowledged: true,
  insertedId: null,
  matchedCount: 1,
  modifiedCount: 1,
  upsertedCount: 0
}
```

## Анализ запросов в контексте индексов
Рассмотрим запрос, запрашивающий данные по 
полю birthDate и план:

**ВАЖНО**
запросы выполнялись с изначальным наполнением 100 тыс. записей
```js 
db.users.find({ birthDate: { $lte: new Date(new Date().setFullYear(new Date().getFullYear() - 30)) } }).explain("executionStats");
```
#### Результат:
```json
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'mydatabase.users',
    parsedQuery: {
      birthDate: {
        '$lte': 1985-02-16T10:49:40.459Z
      }
    },
    indexFilterSet: false,
    planCacheShapeHash: '8BBF77A7',
    planCacheKey: '9EA8C5EB',
    optimizationTimeMillis: 0,
    maxIndexedOrSolutionsReached: false,
    maxIndexedAndSolutionsReached: false,
    maxScansToExplodeReached: false,
    prunedSimilarIndexes: false,
    winningPlan: {
      isCached: false,
      stage: 'COLLSCAN',
      filter: {
        birthDate: {
          '$lte': 1985-02-16T10:49:40.459Z
        }
      },
      direction: 'forward'
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 71914,
    executionTimeMillis: 25,
    totalKeysExamined: 0,
    totalDocsExamined: 100005,
    executionStages: {
      isCached: false,
      stage: 'COLLSCAN',
      filter: {
        birthDate: {
          '$lte': 1985-02-16T10:49:40.459Z
        }
      },
      nReturned: 71914,
      executionTimeMillisEstimate: 20,
      works: 100006,
      advanced: 71914,
      needTime: 28091,
      needYield: 0,
      saveState: 1,
      restoreState: 1,
      isEOF: 1,
      direction: 'forward',
      docsExamined: 100005
    }
  },
  queryShapeHash: '90209649CE5EA89630DC19BC10580C34B587E639B2D56FA3B5EF51CDED4DC486',
  command: {
    find: 'users',
    filter: {
      birthDate: {
        '$lte': 1985-02-16T10:49:40.459Z
      }
    },
    '$db': 'mydatabase'
  },
  serverInfo: {
    host: '721cc6fde74d',
    port: 27017,
    version: '8.0.4',
    gitVersion: 'bc35ab4305d9920d9d0491c1c9ef9b72383d31f9'
  },
  serverParameters: {
    internalQueryFacetBufferSizeBytes: 104857600,
    internalQueryFacetMaxOutputDocSizeBytes: 104857600,
    internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
    internalDocumentSourceGroupMaxMemoryBytes: 104857600,
    internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
    internalQueryProhibitBlockingMergeOnMongoS: 0,
    internalQueryMaxAddToSetBytes: 104857600,
    internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
    internalQueryFrameworkControl: 'trySbeRestricted',
    internalQueryPlannerIgnoreIndexWithCollationForRegex: 1
  },
  ok: 1
}
```
Комментарий:
- используетеся **COLLSCAN**
- используется фильтр
- время выполнения 25ms ⚡

### Теперь с индексом
```js 
db.users.createIndex({birthDate: 1});
```
#### Результат:
```json 
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'mydatabase.users',
    parsedQuery: {
      birthDate: {
        '$lte': 1995-02-16T10:30:52.931Z
      }
    },
    indexFilterSet: false,
    planCacheShapeHash: '8BBF77A7',
    planCacheKey: '82D19B94',
    optimizationTimeMillis: 0,
    maxIndexedOrSolutionsReached: false,
    maxIndexedAndSolutionsReached: false,
    maxScansToExplodeReached: false,
    prunedSimilarIndexes: false,
    winningPlan: {
      isCached: false,
      stage: 'FETCH',
      inputStage: {
        stage: 'IXSCAN',
        keyPattern: {
          birthDate: 1
        },
        indexName: 'birthDate_1',
        isMultiKey: false,
        multiKeyPaths: {
          birthDate: []
        },
        isUnique: false,
        isSparse: false,
        isPartial: false,
        indexVersion: 2,
        direction: 'forward',
        indexBounds: {
          birthDate: [
            '[new Date(-9223372036854775808), new Date(792930652931)]'
          ]
        }
      }
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 91973,
    executionTimeMillis: 108,
    totalKeysExamined: 91973,
    totalDocsExamined: 91973,
    executionStages: {
      isCached: false,
      stage: 'FETCH',
      nReturned: 91973,
      executionTimeMillisEstimate: 99,
      works: 91974,
      advanced: 91973,
      needTime: 0,
      needYield: 0,
      saveState: 5,
      restoreState: 5,
      isEOF: 1,
      docsExamined: 91973,
      alreadyHasObj: 0,
      inputStage: {
        stage: 'IXSCAN',
        nReturned: 91973,
        executionTimeMillisEstimate: 13,
        works: 91974,
        advanced: 91973,
        needTime: 0,
        needYield: 0,
        saveState: 5,
        restoreState: 5,
        isEOF: 1,
        keyPattern: {
          birthDate: 1
        },
        indexName: 'birthDate_1',
        isMultiKey: false,
        multiKeyPaths: {
          birthDate: []
        },
        isUnique: false,
        isSparse: false,
        isPartial: false,
        indexVersion: 2,
        direction: 'forward',
        indexBounds: {
          birthDate: [
            '[new Date(-9223372036854775808), new Date(792930652931)]'
          ]
        },
        keysExamined: 91973,
        seeks: 1,
        dupsTested: 0,
        dupsDropped: 0
      }
    }
  },
  queryShapeHash: '90209649CE5EA89630DC19BC10580C34B587E639B2D56FA3B5EF51CDED4DC486',
  command: {
    find: 'users',
    filter: {
      birthDate: {
        '$lte': 1995-02-16T10:30:52.931Z
      }
    },
    '$db': 'mydatabase'
  },
  serverInfo: {
    host: '721cc6fde74d',
    port: 27017,
    version: '8.0.4',
    gitVersion: 'bc35ab4305d9920d9d0491c1c9ef9b72383d31f9'
  },
  serverParameters: {
    internalQueryFacetBufferSizeBytes: 104857600,
    internalQueryFacetMaxOutputDocSizeBytes: 104857600,
    internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
    internalDocumentSourceGroupMaxMemoryBytes: 104857600,
    internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
    internalQueryProhibitBlockingMergeOnMongoS: 0,
    internalQueryMaxAddToSetBytes: 104857600,
    internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
    internalQueryFrameworkControl: 'trySbeRestricted',
    internalQueryPlannerIgnoreIndexWithCollationForRegex: 1
  },
  ok: 1
}
```
Комментарий:
- используетеся **FETCH**
- используется **IXSCAN**
- время выполнения 108ms ⏳

#### Промежуточные выводы:
1️⃣ Индекс требует дополнительных операций  
**IXSCAN** сначала проходит по индексу (totalKeysExamined: 91973),
Затем **FETCH** загружает документы (totalDocsExamined: 91973).
В то время как **COLLSCAN** просто идёт по всей коллекции одним сплошным проходом.

2️⃣ MongoDB может считывать данные быстрее из коллекции, чем из индекса  
Если документ маленький, то полный скан коллекции может быть эффективнее, потому что MongoDB читает данные последовательно.
Если в коллекции есть фрагментация или документы в кеше, **COLLSCAN** может работать быстрее.

3️⃣ Нет проекции, значит приходится **FETCH**'ить всё  
Мы запрашиваем все поля документа.
Если бы мы запрашивали *_только_* поле, по которому есть индекс, MongoDB смог бы вернуть данные прямо из индекса, не переходя к документам (**FETCH**).


### Рассмотрим теперь запрос данных из индекса:
```js 
db.users.find(
  { birthDate: { $lte: new Date("1985-02-16") } },
  { _id: 0, birthDate: 1 }  // Только поле из индекса
).explain("executionStats");
```
#### Результат без индекса:
```json 
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'mydatabase.users',
    parsedQuery: {
      birthDate: {
        '$lte': 1985-02-16T00:00:00.000Z
      }
    },
    indexFilterSet: false,
    planCacheShapeHash: 'AD32B2BD',
    planCacheKey: 'AB33914C',
    optimizationTimeMillis: 0,
    maxIndexedOrSolutionsReached: false,
    maxIndexedAndSolutionsReached: false,
    maxScansToExplodeReached: false,
    prunedSimilarIndexes: false,
    winningPlan: {
      isCached: false,
      stage: 'PROJECTION_COVERED',
      transformBy: {
        _id: 0,
        birthDate: 1
      },
      inputStage: {
        stage: 'IXSCAN',
        keyPattern: {
          birthDate: 1
        },
        indexName: 'birthDate_1',
        isMultiKey: false,
        multiKeyPaths: {
          birthDate: []
        },
        isUnique: false,
        isSparse: false,
        isPartial: false,
        indexVersion: 2,
        direction: 'forward',
        indexBounds: {
          birthDate: [
            '[new Date(-9223372036854775808), new Date(477360000000)]'
          ]
        }
      }
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 69947,
    executionTimeMillis: 25,
    totalKeysExamined: 69947,
    totalDocsExamined: 0,
    executionStages: {
      isCached: false,
      stage: 'PROJECTION_COVERED',
      nReturned: 69947,
      executionTimeMillisEstimate: 20,
      works: 69948,
      advanced: 69947,
      needTime: 0,
      needYield: 0,
      saveState: 1,
      restoreState: 1,
      isEOF: 1,
      transformBy: {
        _id: 0,
        birthDate: 1
      },
      inputStage: {
        stage: 'IXSCAN',
        nReturned: 69947,
        executionTimeMillisEstimate: 20,
        works: 69948,
        advanced: 69947,
        needTime: 0,
        needYield: 0,
        saveState: 1,
        restoreState: 1,
        isEOF: 1,
        keyPattern: {
          birthDate: 1
        },
        indexName: 'birthDate_1',
        isMultiKey: false,
        multiKeyPaths: {
          birthDate: []
        },
        isUnique: false,
        isSparse: false,
        isPartial: false,
        indexVersion: 2,
        direction: 'forward',
        indexBounds: {
          birthDate: [
            '[new Date(-9223372036854775808), new Date(477360000000)]'
          ]
        },
        keysExamined: 69947,
        seeks: 1,
        dupsTested: 0,
        dupsDropped: 0
      }
    }
  },
  queryShapeHash: 'A88F2C11EEF68F8C8EFA8D556DEF20CD7DCC794233A52317B47016905613A7F6',
  command: {
    find: 'users',
    filter: {
      birthDate: {
        '$lte': 1985-02-16T00:00:00.000Z
      }
    },
    projection: {
      _id: 0,
      birthDate: 1
    },
    '$db': 'mydatabase'
  },
  serverInfo: {
    host: '721cc6fde74d',
    port: 27017,
    version: '8.0.4',
    gitVersion: 'bc35ab4305d9920d9d0491c1c9ef9b72383d31f9'
  },
  serverParameters: {
    internalQueryFacetBufferSizeBytes: 104857600,
    internalQueryFacetMaxOutputDocSizeBytes: 104857600,
    internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
    internalDocumentSourceGroupMaxMemoryBytes: 104857600,
    internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
    internalQueryProhibitBlockingMergeOnMongoS: 0,
    internalQueryMaxAddToSetBytes: 104857600,
    internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
    internalQueryFrameworkControl: 'trySbeRestricted',
    internalQueryPlannerIgnoreIndexWithCollationForRegex: 1
  },
  ok: 1
}
```
Сравним с тем же запросом без индекса:
```json 
{
  explainVersion: '1',
  queryPlanner: {
    namespace: 'mydatabase.users',
    parsedQuery: {
      birthDate: {
        '$lte': 1985-02-16T00:00:00.000Z
      }
    },
    indexFilterSet: false,
    planCacheShapeHash: 'AD32B2BD',
    planCacheKey: '9A9E4069',
    optimizationTimeMillis: 0,
    maxIndexedOrSolutionsReached: false,
    maxIndexedAndSolutionsReached: false,
    maxScansToExplodeReached: false,
    prunedSimilarIndexes: false,
    winningPlan: {
      isCached: false,
      stage: 'PROJECTION_SIMPLE',
      transformBy: {
        _id: 0,
        birthDate: 1
      },
      inputStage: {
        stage: 'COLLSCAN',
        filter: {
          birthDate: {
            '$lte': 1985-02-16T00:00:00.000Z
          }
        },
        direction: 'forward'
      }
    },
    rejectedPlans: []
  },
  executionStats: {
    executionSuccess: true,
    nReturned: 69947,
    executionTimeMillis: 37,
    totalKeysExamined: 0,
    totalDocsExamined: 100005,
    executionStages: {
      isCached: false,
      stage: 'PROJECTION_SIMPLE',
      nReturned: 69947,
      executionTimeMillisEstimate: 30,
      works: 100006,
      advanced: 69947,
      needTime: 30058,
      needYield: 0,
      saveState: 1,
      restoreState: 1,
      isEOF: 1,
      transformBy: {
        _id: 0,
        birthDate: 1
      },
      inputStage: {
        stage: 'COLLSCAN',
        filter: {
          birthDate: {
            '$lte': 1985-02-16T00:00:00.000Z
          }
        },
        nReturned: 69947,
        executionTimeMillisEstimate: 30,
        works: 100006,
        advanced: 69947,
        needTime: 30058,
        needYield: 0,
        saveState: 1,
        restoreState: 1,
        isEOF: 1,
        direction: 'forward',
        docsExamined: 100005
      }
    }
  },
  queryShapeHash: 'A88F2C11EEF68F8C8EFA8D556DEF20CD7DCC794233A52317B47016905613A7F6',
  command: {
    find: 'users',
    filter: {
      birthDate: {
        '$lte': 1985-02-16T00:00:00.000Z
      }
    },
    projection: {
      _id: 0,
      birthDate: 1
    },
    '$db': 'mydatabase'
  },
  serverInfo: {
    host: '721cc6fde74d',
    port: 27017,
    version: '8.0.4',
    gitVersion: 'bc35ab4305d9920d9d0491c1c9ef9b72383d31f9'
  },
  serverParameters: {
    internalQueryFacetBufferSizeBytes: 104857600,
    internalQueryFacetMaxOutputDocSizeBytes: 104857600,
    internalLookupStageIntermediateDocumentMaxSizeBytes: 104857600,
    internalDocumentSourceGroupMaxMemoryBytes: 104857600,
    internalQueryMaxBlockingSortMemoryUsageBytes: 104857600,
    internalQueryProhibitBlockingMergeOnMongoS: 0,
    internalQueryMaxAddToSetBytes: 104857600,
    internalDocumentSourceSetWindowFieldsMaxMemoryBytes: 104857600,
    internalQueryFrameworkControl: 'trySbeRestricted',
    internalQueryPlannerIgnoreIndexWithCollationForRegex: 1
  },
  ok: 1
```

1️⃣ Засчет PROJECTION_COVERED избегаем лишних чтений

2️⃣ имеем 25ms против 37ms без индекса

## Вывод
Нужно тщательно подбирать индекс с учётом механизма извлечения данных
и проверять его эффективность. 
Индексы "работают" иначе, чем в Реляционных БД.