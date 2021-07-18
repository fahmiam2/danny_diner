-- What is the total amount each customer spent at the restaurant?
select 
    s.customer_id,
    sum(price) as 'Total Amount'
from
    sales s 
JOIN
    menu m
    ON s.product_id = m.product_id
group by s.customer_id
;

-- How many days has each customer visited the restaurant?
select customer_id, 
       count(distinct order_date) as days
FROM sales
group by customer_id;

-- What was the first item from the menu purchased by each customer?
select s.customer_id,
       s.order_date,
       m.product_name
from
    sales s
JOIN
    menu m 
    ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.order_date ASC, s.customer_id ASC;

-- What is the most purchased item on the menu and how many times was it purchased by all customers?
select  m.product_name,
        count(m.product_name) "most_purchased"
from sales s 
JOIN menu m 
    ON s.product_id = m.product_id
group by m.product_name
order by most_purchased DESC
limit 1;

-- Which item was the most popular for each customer?
select a.customer_id, a.product_name
from 
(select b.*,
		rank() over (partition by b.customer_id
                    order by b.count) as "rank"
from
(select s.customer_id,
        m.product_name,
        count(m.product_name) as "count"
from sales s 
JOIN menu m 
    ON s.product_id = m.product_id
group by s.customer_id, m.product_name
order by s.customer_id asc, count asc) b) a
where rank = 1;

-- Which item was purchased first by the customer after they became a member?
select a.customer_id, a.product_name
from (select mb.customer_id,
        mb.join_date,
        s.order_date,
        m.product_name,
        rank() over (partition by mb.customer_id
        order by s.order_date asc) 'rank'
from members mb
JOIN sales s  
    ON mb.customer_id = s.customer_id
    JOIN menu m 
        ON m.product_id = s.product_id
where s.order_date >= mb.join_date) a
where a.rank = 1;


-- Which item was purchased just before the customer became a member?
select a.customer_id, a.product_name
from (select mb.customer_id,
        mb.join_date,
        s.order_date,
        m.product_name,
        rank() over (partition by mb.customer_id
        order by s.order_date desc) 'rank'
from members mb
JOIN sales s  
    ON mb.customer_id = s.customer_id
    JOIN menu m 
        ON m.product_id = s.product_id
where s.order_date < mb.join_date) a
where a.rank = 1;

-- What is the total items and amount spent for each member before they became a member?



-- If each $1 spent equates to 10 points and sushi has a 2x points multiplier 
-- - how many points would each customer have?


-- In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
-- - how many points do customer A and B have at the end of January