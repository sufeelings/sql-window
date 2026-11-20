-- 요금제별 «고객 한 명이 한 해(2025년) 평균 몇 번 문의했나»
-- 조인 규칙(목요일): 문의를 고객별로 먼저 세고, customers를 왼쪽에 둔 LEFT JOIN
--   → 한 줄 = 고객 1명이 유지되고, 문의 0건 고객도 분모에 들어간다.
WITH tickets_per_customer AS (
    SELECT customer_id, COUNT(*) AS n_tickets
    FROM support_tickets
    WHERE created_date BETWEEN DATE '2025-01-01' AND DATE '2025-12-31'
    GROUP BY customer_id
)
SELECT
    c.plan_type                                   AS 요금제,
    COUNT(*)                                      AS 고객,
    SUM(COALESCE(t.n_tickets, 0))                 AS 문의,
    ROUND(AVG(COALESCE(t.n_tickets, 0)), 2)       AS 고객당_평균_문의
FROM customers AS c
LEFT JOIN tickets_per_customer AS t
       ON t.customer_id = c.customer_id
GROUP BY c.plan_type
ORDER BY 고객당_평균_문의 DESC;
