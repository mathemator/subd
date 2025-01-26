# Статистика БД по результатам теста sysbench
### Сам результат автоматически получается при запуске контейнера sysbench - в sysbench/run.log
### Результат отформатирован для красоты 🐱😊🎉 
# SQL Statistics

## Queries Performed
| Type   | Count  |
|--------|--------|
| Read   | 11396  |
| Write  | 3256   |
| Other  | 1628   |
| **Total** | **16280** |

## Transactions
| Metric               | Value         |
|----------------------|---------------|
| Transactions         | 814           |
| Queries              | 16280         |
| Ignored Errors       | 0             |
| Reconnects           | 0             |

## General Statistics
| Metric               | Value         |
|----------------------|---------------|
| Total Time           | 10.0030s      |
| Total Number of Events | 814         |

## Latency (ms)
| Metric               | Value         |
|----------------------|---------------|
| Min                  | 10.11         |
| Avg                  | 12.28         |
| Max                  | 38.53         |
| 95th Percentile      | 14.73         |
| Sum                  | 9998.37       |

## Threads Fairness
| Metric               | Value         |
|----------------------|---------------|
| Events (avg/stddev)  | 814.0000/0.00 |
| Execution Time (avg/stddev) | 9.9984/0.00 |