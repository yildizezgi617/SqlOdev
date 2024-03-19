--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT product_id,product_name,suppliers.company_name,suppliers.phone FROM products
INNER JOIN suppliers ON products.supplier_id=suppliers.supplier_id
WHERE units_in_stock=0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT order_id,order_date,ship_address,employees.first_name,employees.last_name FROM orders
INNER JOIN employees ON orders.employee_id=employees.employee_id
WHERE DATE_PART('month', order_date) = 3 AND DATE_PART('year', order_date) = 1998;

--28. 1997 yılı şubat ayında kaç siparişim var?

SELECT COUNT(DISTINCT orders.order_id) AS toplam_siparis_sayisi
FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
WHERE DATE_PART('month', order_date) = 2 AND DATE_PART('year', order_date) = 1997;

--29. London şehrinden 1998 yılında kaç siparişim var?

SELECT *
FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE EXTRACT(YEAR FROM order_date) = 1998 AND customers.city='London';
--EXTRACT(MONTH FROM order_date) = 4 AND EXTRACT(DAY FROM order_date) = 24

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası  //Soralım

SELECT DISTINCT customers.contact_name, customers.phone FROM orders
INNER JOIN customers ON orders.customer_id = customers.customer_id
WHERE EXTRACT(YEAR FROM order_date) = 1997;

--31. Taşıma ücreti 40 üzeri olan siparişlerim

SELECT * FROM orders WHERE freight>40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı

SELECT customers.contact_name,customers.city,freight FROM orders
INNER JOIN customers ON orders.customer_id=customers.customer_id
where freight>40
ORDER BY freight;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),

SELECT order_date,ship_city, UPPER(CONCAT(employees.first_name,employees.laSt_name)) AS "AD SOYAD" FROM orders
INNER JOIN employees ON orders.employee_id=employees.employee_id
WHERE EXTRACT(YEAR FROM order_date) = 1997;


--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları


SELECT DISTINCT customers.contact_name,customers.phone FROM orders
INNER JOIN customers ON orders.customer_id=customers.customer_id
WHERE EXTRACT(YEAR FROM order_date)=1997;

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad

SELECT customers.contact_name,order_date,concat(employees.first_name,' ',employees.last_name) as "Ad Soyad" FROM orders
INNER JOIN employees ON orders.employee_id=employees.employee_id
INNER JOIN customers ON orders.customer_id=customers.customer_id;



--36. Geciken siparişlerim?

SELECT * FROM orders
WHERE shipped_date>required_date

--37. Geciken siparişlerimin tarihi, müşterisinin adı

SELECT customers.contact_name,shipped_date FROM orders
INNER JOIN customers ON orders.customer_id=customers.customer_id
WHERE shipped_date>required_date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

SELECT products.product_name,categories.category_name,order_details.quantity FROM products
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN order_Details ON products.product_id=order_details.product_id
WHERE order_details.order_id=10248;


--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

SELECT products.product_name,categories.category_name,suppliers.company_name FROM products
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN order_Details ON products.product_id=order_details.product_id
INNER JOIN suppliers ON products.supplier_id=suppliers.supplier_id
WHERE order_details.order_id=10248;

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

SELECT orders.employee_id,products.product_name,order_details.quantity FROM orders
INNER JOIN order_details ON order_details.order_id=orders.order_id
INNER JOIN products ON order_details.product_id=products.product_id
WHERE orders.employee_id=3 AND EXTRACT(YEAR FROM order_date)=1997


--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

SELECT employees.employee_id, employees.first_name, employees.last_name, SUM(order_details.quantity) FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN employees ON orders.employee_id = employees.employee_id
WHERE EXTRACT(YEAR FROM order_date) = 1997
GROUP BY order_details.order_id, employees.employee_id
ORDER BY SUM(order_details.quantity) DESC LIMIT 1

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

SELECT employees.employee_id, employees.first_name, employees.last_name, SUM(order_details.quantity) FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN employees ON orders.employee_id = employees.employee_id
WHERE EXTRACT(YEAR FROM order_date) = 1997
GROUP BY employees.employee_id
ORDER BY SUM(order_details.quantity) DESC LIMIT 1;

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

SELECT product_name,unit_price,categories.category_name FROM products
INNER JOIN categories ON products.category_id=categories.category_id
WHERE unit_price=(SELECT MAX(unit_price) FROM products);

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

SELECT e.first_name, e.last_name, o.order_date, o.order_id FROM orders o 
INNER JOIN employees e ON o.employee_id = e.employee_id 
ORDER BY o.order_date DESC;

--45. SON 5 siparişimin ortalama fiyatı ve order_id nedir?

SELECT orders.order_id, AVG(order_details.unit_price*order_details.quantity)  FROM orders
INNER JOIN order_details ON orders.order_id=order_details.order_id
GROUP BY orders.order_id
ORDER BY orders.order_date DESC LIMIT 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

SELECT product_name,categories.category_name, SUM(order_details.quantity) FROM products
INNER JOIN order_details ON products.product_id=order_details.product_id
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN orders ON order_details.order_id=orders.order_id
WHERE EXTRACT(MONTH FROM orders.order_date) = 1
GROUP BY products.product_name ,categories.category_name

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir? 

SELECT order_id, quantity FROM order_details
WHERE (
    SELECT order_id,SUM(quantity) AS toplam_satis_miktari  
    FROM order_details 
    GROUP BY order_id
) > (
    SELECT AVG(toplam_satis_miktari) AS ortalama 
    FROM (
        SELECT SUM(quantity) AS toplam_satis_miktari  
        FROM order_details 
        GROUP BY order_id
    ) AS subquery
);

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

SELECT products.product_name,categories.category_name,suppliers.company_name,SUM(order_details.quantity) FROM products
INNER JOIN suppliers ON products.supplier_id=suppliers.supplier_id
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN order_details ON products.product_id=order_details.product_id
GROUP BY order_details.product_id,categories.category_name,products.product_name,suppliers.company_name
ORDER BY SUM(order_details.quantity) DESC LIMIT 1;


--49. Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) FROM customers;

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

SELECT SUM(order_details.quantity * order_details.unit_price) AS toplam_satis
FROM orders
INNER JOIN order_details ON order_details.order_id = orders.order_id
WHERE orders.employee_id = 3
AND order_date >= DATE_TRUNC('month', CURRENT_DATE - INTERVAL '1 months') -- Son Ocak ayından bugüne kadar olan siparişler
AND order_date <= CURRENT_DATE; -- Bugün

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

SELECT products.product_name,categories.category_name,order_details.quantity FROM products
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN order_Details ON products.product_id=order_details.product_id
WHERE order_details.order_id=10248;

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

SELECT products.product_name,categories.category_name,suppliers.company_name FROM products
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN order_Details ON products.product_id=order_details.product_id
INNER JOIN suppliers ON products.supplier_id=suppliers.supplier_id
WHERE order_details.order_id=10248;


--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

SELECT orders.employee_id,products.product_name,order_details.quantity FROM orders
INNER JOIN order_details ON order_details.order_id=orders.order_id
INNER JOIN products ON order_details.product_id=products.product_id
WHERE orders.employee_id=3 AND EXTRACT(YEAR FROM order_date)=1997;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

SELECT employees.employee_id, employees.first_name, employees.last_name, SUM(order_details.quantity) FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN employees ON orders.employee_id = employees.employee_id
WHERE EXTRACT(YEAR FROM order_date) = 1997
GROUP BY order_details.order_id, employees.employee_id
ORDER BY SUM(order_details.quantity) DESC LIMIT 1;

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad

SELECT employees.employee_id, employees.first_name, employees.last_name, SUM(order_details.quantity) FROM orders
INNER JOIN order_details ON orders.order_id = order_details.order_id
INNER JOIN employees ON orders.employee_id = employees.employee_id
WHERE EXTRACT(YEAR FROM order_date) = 1997
GROUP BY employees.employee_id
ORDER BY SUM(order_details.quantity) DESC LIMIT 1;

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

SELECT product_name,unit_price,categories.category_name FROM products
INNER JOIN categories ON products.category_id=categories.category_id
WHERE unit_price=(SELECT MAX(unit_price) FROM products);

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

SELECT e.first_name, e.last_name, o.order_date, o.order_id FROM orders o 
INNER JOIN employees e ON o.employee_id = e.employee_id 
ORDER BY o.order_date DESC;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?

SELECT orders.order_id, AVG(order_details.unit_price*order_details.quantity)  FROM orders
INNER JOIN order_details ON orders.order_id=order_details.order_id
GROUP BY orders.order_id
ORDER BY orders.order_date DESC LIMIT 5;

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

SELECT product_name,categories.category_name, SUM(order_details.quantity) FROM products
INNER JOIN order_details ON products.product_id=order_details.product_id
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN orders ON order_details.order_id=orders.order_id
WHERE EXTRACT(MONTH FROM orders.order_date) = 1
GROUP BY products.product_name ,categories.category_name;

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

SELECT order_id,amount FROM (SELECT order_id,SUM(unit_price*quantity) as amount FROM order_details
GROUP BY order_id)
WHERE
(SELECT order_id,SUM(unit_price*quantity) as amount FROM order_details
GROUP BY order_id)
>
(SELECT AVG(amount) AS ortalama FROM (
SELECT order_id,SUM(unit_price*quantity) as amount FROM order_details
GROUP BY order_id));

-------------------------------------------------------

SELECT order_id,amount FROM (SELECT order_id,SUM(unit_price*quantity) as amount FROM order_details
GROUP BY order_id)
WHERE
amount
>
(SELECT AVG(amount) AS ortalama FROM (
SELECT order_id,SUM(unit_price*quantity) as amount FROM order_details
GROUP BY order_id))

ORDER BY amount ASC

--------------------------------------------------------

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

SELECT products.product_name,categories.category_name,suppliers.company_name,SUM(order_details.quantity) FROM products
INNER JOIN suppliers ON products.supplier_id=suppliers.supplier_id
INNER JOIN categories ON products.category_id=categories.category_id
INNER JOIN order_details ON products.product_id=order_details.product_id
GROUP BY order_details.product_id,categories.category_name,products.product_name,suppliers.company_name
ORDER BY SUM(order_details.quantity) DESC LIMIT 1;

--62. Kaç ülkeden müşterim var

SELECT COUNT(DISTINCT country) FROM customers;

--63. Hangi ülkeden kaç müşterimiz var

SELECT country, COUNT(contact_name) FROM customers
GROUP BY country
ORDER BY country ASC;

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

SELECT orders.order_date,orders.employee_id,order_details.order_id,SUM(order_details.quantity*order_details.unit_price) AS amount FROM orders
INNER JOIN order_details ON orders.order_id=order_details.order_id
GROUP BY order_details.order_id,orders.employee_id,orders.order_date 
HAVING 
orders.employee_id=3
AND orders.order_date >(SELECT MAX(orders.order_date) from orders WHERE EXTRACT(MONTH FROM order_date) = 12 )
ORDER BY orders.order_date ASC

--toplam amount'u istiyor subquerry

SELECT sum(amount) FROM (SELECT orders.order_date,orders.employee_id,order_details.order_id,SUM(order_details.quantity*order_details.unit_price) AS amount FROM orders
INNER JOIN order_details ON orders.order_id=order_details.order_id
GROUP BY order_details.order_id,orders.employee_id,orders.order_date  --diğer tarafta gruplayacak order id yok ki
HAVING 
orders.employee_id=3
AND orders.order_date >(SELECT MAX(orders.order_date) from orders WHERE EXTRACT(MONTH FROM order_date) = 12))


--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?


SELECT orders.order_id,product_id,SUM(unit_price*quantity) AS amount,orders.order_date FROM order_details
INNER JOIN orders ON order_details.order_id=orders.order_id
GROUP BY order_details.product_id,orders.order_date,orders.order_id
HAVING product_id=10
AND orders.order_date >= (SELECT MAX(orders.order_date) FROM orders)-INTERVAL '3 months' 
ORDER BY orders.order_date DESC


SELECT product_id,SUM(unit_price*quantity),orders.order_date FROM order_details
INNER JOIN orders ON order_details.order_id=orders.order_id
GROUP BY order_details.product_id,orders.order_date
HAVING product_id=10
AND orders.order_date >= (SELECT MAX(orders.order_date) FROM orders)-INTERVAL '3 months' 
ORDER BY orders.order_date DESC



SELECT SUM(amount) FROM(SELECT orders.order_id,product_id,SUM(unit_price*quantity) AS amount,orders.order_date FROM order_details
INNER JOIN orders ON order_details.order_id=orders.order_id
GROUP BY order_details.product_id,orders.order_date,orders.order_id
HAVING product_id=10
AND orders.order_date >= (SELECT MAX(orders.order_date) FROM orders)-INTERVAL '3 months' 
)

SELECT SUM(amount) AS total_amount FROM (SELECT product_id,SUM(unit_price * quantity) AS amount FROM order_details 
GROUP BY product_id) AS subquery;


--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

SELECT employees.first_name,employees.last_name,COUNT(order_details.order_id) FROM orders
INNER JOIN employees ON orders.employee_id=employees.employee_id
INNER JOIN order_details ON orders.order_id=order_details.order_id
GROUP BY order_details.order_id,employees.first_name,employees.last_name;

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun  /////////////////Bakılacak

SELECT DISTINCT(orders.customer_id) from orders
INNER JOIN customers ON orders.customer_id=customers.customer_id



SELECT customers.customer_id FROM customers
LEFT JOIN orders ON customers.customer_id = orders.customer_id
WHERE orders.customer_id IS NULL;

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

SELECT company_name,contact_name,address,city,country FROM customers
WHERE country='Brazil'

--69. Brezilya’da olmayan müşteriler

SELECT company_name,contact_name,address,city,country FROM customers
WHERE country!='Brazil'

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

SELECT company_name,contact_name,address,city,country FROM customers
WHERE country='Brazil' OR country='France' OR country='Germany'

--71. Faks numarasını bilmediğim müşteriler

SELECT company_name,contact_name,fax FROM customers
WHERE fax IS NULL

--72. Londra’da ya da Paris’de bulunan müşterilerim

SELECT company_name,contact_name,address,city,country FROM customers
WHERE city='Londra' OR city='Paris'

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

SELECT company_name,contact_name,city,contact_title FROM customers
WHERE city='México D.F.' AND contact_title='Owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları

SELECT product_name FROM products 
WHERE product_name LIKE 'C%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri

SELECT first_name,last_name,birth_date FROM employees
WHERE first_name LIKE 'A%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları

SELECT company_name FROM customers
WHERE company_name LIKE '%Restaurant%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları

SELECT product_name,unit_price FROM products
WHERE unit_price BETWEEN 50 AND 100
ORDER BY unit_price ASC

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) --bilgileri

SELECT order_id,order_date FROM orders
WHERE order_date BETWEEN '1996-07-01' AND '1996-12-31'
ORDER BY order_date ASC

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

SELECT company_name,contact_name,address,city,country FROM customers
WHERE country='Brazil' OR country='France' OR country='Germany'

--80. Faks numarasını bilmediğim müşteriler

SELECT company_name,contact_name,fax FROM customers
WHERE fax IS NULL

--81. Müşterilerimi ülkeye göre sıralıyorum:

SELECT customers.company_name,country FROM customers

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz

SELECT product_name,CONCAT(unit_price,' TL') FROM products
ORDER BY unit_price DESC

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz

SELECT product_name,unit_price,units_in_stock FROM products
ORDER BY unit_price DESC

--84. 1 Numaralı kategoride kaç ürün vardır..?

SELECT COUNT(*) FROM products
INNER JOIN categories ON products.category_id=categories.category_id
WHERE products.category_id=1,

--85. Kaç farklı ülkeye ihracat yapıyorum..?

SELECT COUNT(DISTINCT(ship_country)) FROM orders

--86. a.Bu ülkeler hangileri..?

SELECT DISTINCT(ship_country) FROM orders
ORDER BY ship_country 

--87. En Pahalı 5 ürün

SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC LIMIT 5

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?

SELECT COUNT(*) AS ALFKI_Siparis_Sayisi FROM orders
INNER JOIN customers ON orders.customer_id=customers.customer_id
WHERE customers.customer_id = 'ALFKI'

--89. Ürünlerimin toplam maliyeti

SELECT product_name, CONCAT(unit_price*units_on_order,' TL') AS Toplam_Maliyet FROM products

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?

SELECT SUM(unit_price*quantity) FROM order_details

--91. Ortalama Ürün Fiyatım

SELECT AVG(unit_price) AS "Ortalama Ürün Fiyatı" FROM products

--92. En Pahalı Ürünün Adı

SELECT product_name,unit_price FROM products
ORDER BY unit_price DESC LIMIT 1

--93. En az kazandıran sipariş

SELECT order_id,SUM(unit_price*quantity) AS Kazanc FROM order_details
GROUP BY order_id
ORDER BY Kazanc ASC LIMIT 1

--94. Müşterilerimin içinde en uzun isimli müşteri

SELECT contact_name AS "En Uzun İsimli Müşteri" FROM customers
ORDER BY LENGTH(contact_name) DESC LIMIT 1

--95. Çalışanlarımın Ad, Soyad ve Yaşları ///AGE fonksiyonu kullandık

SELECT first_name,last_name,EXTRACT(YEAR FROM AGE(current_date,birth_date)) as "Yaş" FROM employees

--96. Hangi üründen toplam kaç adet alınmış..?

SELECT products.product_id,products.product_name,SUM(order_details.quantity) FROM products
INNER JOIN order_details ON products.product_id=order_details.product_id
GROUP BY products.product_name,products.product_id  --hangi tabloya alıyorsam onun id si ile grupluyorum
ORDER BY products.product_id ASC

SELECT order_details.product_id,SUM(order_details.quantity) FROM order_details
GROUP BY order_details.product_id
ORDER BY product_id ASC

--97. Hangi siparişte toplam ne kadar kazanmışım..?

SELECT order_id,SUM(unit_price*quantity) AS Kazanc FROM order_details
GROUP BY order_id
ORDER BY Kazanc DESC

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?

SELECT categories.category_name,COUNT(product_name) FROM products
INNER JOIN categories ON products.category_id=categories.category_id
GROUP BY categories.category_name

--99. 1000 Adetten fazla satılan ürünler?

SELECT products.product_id,products.product_name,SUM(order_details.quantity) FROM products
INNER JOIN order_details ON products.product_id=order_details.product_id
GROUP BY products.product_id,products.product_name
HAVING SUM(order_details.quantity)>1000
ORDER BY SUM(order_details.quantity) ASC



--100. Hangi Müşterilerim hiç sipariş vermemiş..?

SELECT customers.customer_id FROM customers
LEFT JOIN orders ON customers.customer_id=orders.customer_id
WHERE orders.customer_id IS NULL 