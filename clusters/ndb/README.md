## Касательно архитектуры таблиц в NDB 

- Т.к. явно не ставилась задача отдельно
выдумывать архитектуру под NDB, то архитектура
скопирована, с удалением неподдерживаемых 
внешних ключей. 
- Архитектура, скорее, должна диктоваться 
конкретной логикой приложения.
- Исходная таблица init_customers в целом тоже
перенесена в NDBCLUSTER, можно за *решение*
рассматривать даже её, с выделенными индексами 
под конкретные бизнес-кейсы.