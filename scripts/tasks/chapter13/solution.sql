--3) написать запрос суммы очков с группировкой и сортировкой по годам
-- год добавил для наглядности, asc/desc - тут по вкусу
select year_game, sum(points) from statistic s
	group by year_game order by year_game asc;

--4) написать cte показывающее тоже самое
WITH YearlyPoints AS (
    SELECT
        year_game,
        SUM(points) AS total_points
    FROM statistic
    GROUP BY year_game
)
SELECT
    year_game,
    total_points
FROM YearlyPoints
ORDER BY year_game ASC;

--5) используя функцию LAG вывести кол-во очков по всем игрокам за текущий код и за предыдущий.
--Решил немного добавить аналитики, чтобы показывалась значащая разница,
--с избеганием дублирования вызоыва функции lag для читаемости
WITH YearlyPoints AS (
    SELECT
        year_game,
        SUM(points) AS total_points
    FROM statistic
    GROUP BY year_game
),
LaggedPoints AS (
    SELECT
        year_game,
        total_points,
        lag(total_points, 1) OVER (ORDER BY year_game) AS prev_total_points
    FROM YearlyPoints
)
SELECT
    year_game,
    total_points,
    prev_total_points,
    CASE
        WHEN prev_total_points IS NULL THEN NULL
        ELSE total_points - prev_total_points
    END AS points_change
FROM LaggedPoints
ORDER BY year_game ASC;
--вывод:
--2018	92.00
--2019	98.00	92.00	6.00
--2020	110.00	98.00	12.00