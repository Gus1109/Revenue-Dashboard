USE [Nikken_HQ]
GO
/****** Object:  StoredProcedure [dbo].[Usp_JUNI_Reconciliation_Revenud]    Script Date: 23/06/2021 08:01:30 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*

EXEC [dbo].[Usp_JUNI_Reconciliation_Revenud]'20210601','20210630'

*/
ALTER PROCEDURE  [dbo].[Usp_JUNI_Reconciliation_Revenud] ( @FechaIni AS  nvarchar(8),@FechaFin AS nvarchar(8))
AS
 BEGIN 
/*
Declare @FechaIni nvarchar(8),@FechaFin nvarchar(8)
SET @FechaIni= '20201101'
SET @FechaFin ='20201131'
*/
IF(@FechaIni='' AND @FechaFin ='')
BEGIN
declare @fecha as DateTime  = DATEADD(DD,-1,GETDATE())
 WHILE(DATEPART(dw,@fecha)=1 OR DATEPART(dw,@fecha)=7)
 BEGIN 
   SET @fecha =  DATEADD(DD,-1,@fecha)
 END 
--SET @FechaIni =CONVERT(CHAR(8),DATEADD(DD,-1,GETDATE()),112)
--SET @FechaFin =CONVERT(CHAR(8),DATEADD(DD,-1,GETDATE()),112)
SET @FechaIni =CONVERT(CHAR(8),@fecha,112)
SET @FechaFin =CONVERT(CHAR(8),@fecha,112)
END 
PRINT @FechaIni
PRINT @FechaFin

/*Inicializacion  de Tabla de Ventas Global*/
IF OBJECT_ID('tempdb..##Vtas') IS NOT NULL  DROP TABLE  ##Vtas
SELECT SPACE(3)as Country,SPACE(25)as Distribuitors,GETDATE() as Post_Date,SPACE(4000) as Order_Num,123456789.123456 as Amount,GETDATE() AS SAP_Date,SPACE(4000) as Order_SAP,123456789.123456 AS Order_Total,SPACE(4000) as Inv_SAP,123456789.123456 AS Inv_Total,SPACE(4000) as Down_SAP,123456789.123456 AS Down_Total,SPACE(4000) as Pay_SAP,123456789.123456 AS Pay_Total into ##Vtas
Truncate Table ##Vtas
/******************************************/


/*Inicializacion de Tabla de Ventas USA*/
IF OBJECT_ID('tempdb..##VtasUSA') IS NOT NULL  DROP TABLE  ##VtasUSA
SELECT SPACE(3)as Country,SPACE(25)as CardCode,GETDATE() as Post_Date,SPACE(4000) as Order_Num,123456789.123456 AS Amount,GETDATE() AS SAP_Date,SPACE(4000) as Order_SAP,123456789.123456 AS Order_Total,SPACE(4000) as Inv_SAP,123456789.123456 AS Inv_Total,SPACE(4000) as Down_SAP,123456789.123456 AS Down_Total,SPACE(4000) as Pay_SAP,123456789.123456 AS Pay_Total into ##VtasUSA
Truncate Table ##VtasUSA
/*****************************************/

/*Obtencion de Ventas de USA y Ordenes de SAP*/
INSERT INTO ##VtasUSA
SELECT DISTINCT  COU,Dist_id as CardCode,isnull(PST_DT,''),isnull(Order_Num,0),sum(Debit),isnull(DocDate,''),isnull(B.DocNum,0) AS [Order_SAP],isnull(DocTotal,0),'',0.0,'',0.0,'',0.0
FROM [Sales_Dashboard].[dbo].Sales_DataTrax  A WITH(NOLOCK)
     LEFT JOIN [Live_Nikken_INC].dbo.ORDR B WITH(NOLOCK) ON  cast(A.Order_Num AS NVARCHAR(max)) = B.NumAtCard
WHERE report_CD = 33  and CONVERT(CHAR(8),PST_DT,112)BETWEEN @FechaIni AND @FechaFin and Debit > 0   and COU ='USA'
group by COU,Dist_id,PST_DT,Order_Num,DocDate,B.DocNum,DocTotal
/**************************************/
/*Inicializacion de Tabla de Facturas*/
IF OBJECT_ID('tempdb..##FactUSA') IS NOT NULL  DROP TABLE  ##FactUSA
SELECT SPACE(4000) AS NumatCard,SPACE(4000) AS  DocNum,123456789.123456 AS Total into ##FactUSA
TRUNCATE TABLE ##FactUSA
/**************************************/

/** Obtencion de Facturas  de SAP **/
INSERT INTO ##FactUSA
SELECT  NumAtCard,STUFF((select cast(DocNum as nvarchar(max)) +' , ' 
                        FROM  [Live_Nikken_INC].dbo.OINV with(nolock) WHERE NumAtCard = a.NumAtCard FOR XML PATH('')),1,0,'') as [Facturas],SUM(DocTotal)+SUM(DpmAmnt)
FROM [Live_Nikken_INC].dbo.OINV  as a  with(nolock)    
WHERE   NumAtCard in (SELECT Order_Num COLLATE DATABASE_DEFAULT FROM ##VtasUSA)
GROUP BY NumAtCard





UPDATE A 
SET Inv_SAP = ISNULL(SUBSTRING (B.DocNum, 1, Len(B.DocNum) - 1 ),''), 
    Inv_Total = ISNULL(Total,0)
FROM ##VtasUSA A LEFT JOIN ##FactUSA B ON A.Order_Num = B.NumatCard
/*********************************/

/** Obtencion de DownPayments  y Payments **/
update A 
SET A.Down_SAP = CASE WHEN ISNULL((D.DpmAmnt-D.DpmAppl),0)>1 THEN ISNULL(CAST(D.DocNum AS NVARCHAR(MAX)),'') ELSE'' END ,
    A.Down_Total = ISNULL((D.DpmAmnt-D.DpmAppl),0),
    A.Pay_SAP = ISNULL(E.DocNum,''),
	A.Pay_Total = ISNULL(E.DocTotal,0)
from ##VtasUSA A 
 LEFT JOIN   [Live_Nikken_INC].dbo.ODPI D with(nolock) on A.Order_Num= D.NumAtCard COLLATE DATABASE_DEFAULT
 LEFT JOIN   [Live_Nikken_INC].dbo.ORCT E with(nolock) on A.Order_Num= E.Ref2 COLLATE DATABASE_DEFAULT
/*****************************************/

--SELECT ISNULL((DpmAmnt-DpmAppl),0),DpmAmnt,DpmAppl,* FROM  [Live_Nikken_INC].dbo.ODPI WHERE DocNum	= 1005205
/*Inicializacion de Tabla de Credit USA*/
IF OBJECT_ID('tempdb..##CreditUSA') IS NOT NULL  DROP TABLE  ##CreditUSA
SELECT SPACE(3)as Country,SPACE(25)as Distribuitors,GETDATE() as Post_Date,SPACE(4000) as Order_Num,123456789.123456 as Amount,GETDATE() AS SAP_Date,SPACE(4000) as Order_SAP,123456789.123456 AS Order_Total,SPACE(4000) as Inv_SAP,123456789.123456 AS Inv_Total,SPACE(4000) as Down_SAP,123456789.123456 AS Down_Total,SPACE(4000) as Pay_SAP,123456789.123456 AS Pay_Total into ##CreditUSA
Truncate Table ##CreditUSA
/*****************************************/
INSERT INTO ##CreditUSA
SELECT DISTINCT  COU,Dist_id as CardCode,isnull(PST_DT,''),isnull(Order_Num,0),isnull(-Credit,0),isnull(DocDate,''),B.DocNum AS [Order_SAP],isnull(-DocTotal,0),'',0.0,'',0.0,'',0.0
FROM [Sales_Dashboard].[dbo].Sales_DataTrax  A WITH(NOLOCK)
       LEFT JOIN [Live_Nikken_INC].dbo.ORIN B  WITH(NOLOCK) ON  cast(A.Order_Num AS NVARCHAR(max)) = B.NumAtCard
WHERE report_CD = 33  and CONVERT(CHAR(8),PST_DT,112)BETWEEN @FechaIni AND @FechaFin and credit > 0   and COU ='USA'

/** Obtencion de Payments de las Credit USA**/
update A 
SET A.Pay_SAP = ISNULL(E.DocNum,''),
	A.Pay_Total = ISNULL(-E.DocTotal,0)
from ##CreditUSA A 
  LEFT JOIN   [Live_Nikken_INC].dbo.OVPM E with(nolock) on A.Order_Num= E.CounterRef COLLATE DATABASE_DEFAULT
/*****************************************/

/***************************CANADA************************************/

 /*Inicializacion de Tabla de Ventas CAN*/
IF OBJECT_ID('tempdb..##VtasCAN') IS NOT NULL  DROP TABLE  ##VtasCAN
SELECT SPACE(3)as Country,SPACE(25)as CardCode,GETDATE() as Post_Date,SPACE(4000) as Order_Num,123456789.123456 AS Amount,GETDATE() AS SAP_Date,SPACE(4000) as Order_SAP,123456789.123456 AS Order_Total,SPACE(4000) as Inv_SAP,123456789.123456 AS Inv_Total,SPACE(4000) as Down_SAP,123456789.123456 AS Down_Total,SPACE(4000) as Pay_SAP,123456789.123456 AS Pay_Total into ##VtasCAN
Truncate Table ##VtasCAN
/***************************************/

/*Obtencion de Ventas de CAN y Ordenes de SAP*/
INSERT INTO ##VtasCAN
SELECT DISTINCT  COU,Dist_id as CardCode,PST_DT,Order_Num,sum(Debit),isnull(DocDate,''),isnull(B.DocNum,0) AS [Order_SAP],isnull(DocTotal,0),'',0.0,'',0.0,'',0.0
FROM [Sales_Dashboard].[dbo].Sales_DataTrax  A WITH(NOLOCK)
     LEFT JOIN [Live_Nikken_CAD].dbo.ORDR B WITH(NOLOCK) ON  cast(A.Order_Num AS NVARCHAR(max)) = B.NumAtCard
WHERE report_CD = 33  and CONVERT(CHAR(8),PST_DT,112)BETWEEN @FechaIni AND @FechaFin and Debit > 0   and COU ='CAN'
group by COU,Dist_id,PST_DT,Order_Num,DocDate,B.DocNum,DocTotal
/*******************************************/

/*Inicializacion de Tabla de Facturas*/
IF OBJECT_ID('tempdb..##FactCAN') IS NOT NULL  DROP TABLE  ##FactCAN
SELECT SPACE(4000) AS NumatCard,SPACE(4000) AS  DocNum,123456789.123456 AS Total into ##FactCAN
TRUNCATE TABLE ##FactCAN
/**************************************/

/** Obtencion de Facturas  de SAP **/
INSERT INTO ##FactCAN
SELECT  NumAtCard,STUFF((select cast(DocNum as nvarchar(max)) +' , ' 
                        FROM  [Live_Nikken_CAD].dbo.OINV with(nolock) WHERE NumAtCard = a.NumAtCard FOR XML PATH('')),1,0,'') as [Facturas],SUM(DocTotal)+SUM(DpmAmnt)
FROM [Live_Nikken_CAD].dbo.OINV  as a  with(nolock)    
WHERE   NumAtCard in (SELECT Order_Num COLLATE DATABASE_DEFAULT FROM ##VtasCAN)
GROUP BY NumAtCard

UPDATE A 
SET Inv_SAP = ISNULL(SUBSTRING (B.DocNum, 1, Len(B.DocNum) - 1 ),''),
   Inv_Total = ISNULL(Total,0)
FROM ##VtasCAN A LEFT JOIN ##FactCAN B ON A.Order_Num = B.NumatCard
/*********************************/

/** Obtencion de DownPayments  y Payments **/
update A 
SET A.Down_SAP =CASE WHEN ISNULL((D.DpmAmnt-D.DpmAppl),0)>1 THEN ISNULL(CAST(D.DocNum AS NVARCHAR(MAX)),'') ELSE'' END ,
    A.Down_Total = ISNULL((D.DpmAmnt-D.DpmAppl),0),
    A.Pay_SAP = ISNULL(E.DocNum,''),
	A.Pay_Total = ISNULL(E.DocTotal,0)
from ##VtasCAN A 
 LEFT JOIN   [Live_Nikken_CAD].dbo.ODPI D with(nolock) on A.Order_Num= D.NumAtCard COLLATE DATABASE_DEFAULT
 LEFT JOIN   [Live_Nikken_CAD].dbo.ORCT E with(nolock) on A.Order_Num= E.Ref2 COLLATE DATABASE_DEFAULT
/******************************************/

/*Inicializacion de Tabla de Credit CAN*/
IF OBJECT_ID('tempdb..##CreditCAN') IS NOT NULL  DROP TABLE  ##CreditCAN
SELECT SPACE(3)as Country,SPACE(25)as CardCode,GETDATE() as Post_Date,SPACE(4000) as Order_Num,123456789.123456 AS Amount,GETDATE() AS SAP_Date,SPACE(4000) as Order_SAP,123456789.123456 AS Order_Total,SPACE(4000) as Inv_SAP,123456789.123456 AS Inv_Total,SPACE(4000) as Down_SAP,123456789.123456 AS Down_Total,SPACE(4000) as Pay_SAP,123456789.123456 AS Pay_Total into ##CreditCAN
Truncate Table ##CreditCAN
/*****************************************/
INSERT INTO ##CreditCAN
SELECT DISTINCT  COU,Dist_id as CardCode,PST_DT,Order_Num,-credit,ISNULL(DocDate,''),B.DocNum AS [Order_SAP],-ISNULL(DocTotal,0),'',0.0,'',0.0,'',0.0
FROM [Sales_Dashboard].[dbo].Sales_DataTrax  A WITH(NOLOCK)
       LEFT JOIN [Live_Nikken_CAD].dbo.ORIN B  WITH(NOLOCK) ON  cast(A.Order_Num AS NVARCHAR(max)) = B.NumAtCard
WHERE report_CD = 33  and CONVERT(CHAR(8),PST_DT,112)BETWEEN @FechaIni AND @FechaFin and credit > 0   and COU ='CAN'

/** Obtencion de Payments de las Credit USA**/
update A 
SET A.Pay_SAP = ISNULL(E.DocNum,''),
	A.Pay_Total = ISNULL(-E.DocTotal,0)
from ##CreditCAN A 
  LEFT JOIN   [Live_Nikken_CAD].dbo.OVPM E with(nolock) on A.Order_Num= E.CounterRef COLLATE DATABASE_DEFAULT
/*****************************************/


 /** Ventas de Global **/
 INSERT ##Vtas
 SELECT * FROM ##VtasUSA
 UNION
 SELECT * FROM ##VtasCAN
 UNION
 select * from ##CreditUSA
 UNION 
 select * from ##CreditCAN
/*******************/


IF OBJECT_ID('tempdb..##vtasDTCAN') IS NOT NULL  DROP TABLE  ##vtasDTCAN
 
SELECT  CONVERT(char(10),Post_Date,101) as Post_Date,SUM(Amount) as Amount_CAN,sum(Order_Total)as OrderTotal_CAN,sum(Pay_Total) as Pay_Total_CAN
INTO ##vtasDTCAN
FROM ##Vtas 
WHERE  Country='CAN' 
group by CONVERT(char(10),Post_Date,101),Country
Order by Post_Date
 

IF OBJECT_ID('tempdb..##vtasDTUSA') IS NOT NULL  DROP TABLE  ##vtasDTUSA
 
SELECT  CONVERT(char(10),Post_Date,101) as Post_Date,SUM(Amount) as Amount_USA,sum(Order_Total)as OrderTotal_USA,sum(Pay_Total) as Pay_Total_USA
INTO ##vtasDTUSA
FROM ##Vtas 
WHERE  Country='USA' 
group by CONVERT(char(10),Post_Date,101),Country
Order by Post_Date
 
 IF OBJECT_ID('Sales_Dashboard.dbo.JUNIReporteVentaGral') IS NOT NULL  DROP TABLE  Sales_Dashboard.dbo.JUNIReporteVentaGral
 

/* drop table Sales_Dashboard.dbo.prueba;
*/
 CREATE TABLE Sales_Dashboard.dbo.JUNIReporteVentaGral
 (
 Post_Date Date,
	Amount_CAN numeric(19,6),
	OrderTotal_CAN numeric(19,6),
	Pay_Total_CAN numeric(19,6),
	Amount_USA numeric(19,6),
	OrderTotal_USA numeric(19,6),
	Pay_Total_USA numeric(19,6),
	Amount_Tot numeric(19,6),
	Amount_Order_Total numeric(19,6),
	Amount_Payment_Total numeric(19,6),
    Can_CreditCard numeric(19,6),
	USA_CreditCard numeric(19,6),
	CreditCardTotal numeric(19,6),
	Diff_Amon_Ord_Sap numeric(19,6),
	Diff_Dt_Am_Pay numeric(19,6),
	Diff_Pay_Rcc numeric(19,6),
	Diff_Can_Amon_Order numeric(19,6),
	Diff_Can_Amon_Payment numeric(19,6),
	Diff_Can_Payment_RCC numeric(19,6),
	Diff_Usa_Amon_Order numeric(19,6),
	Diff_Usa_Amon_Payment numeric(19,6),
	Diff_Usa_Payment_RCC numeric(19,6),
	Fecha_Report Date)
 

 insert into Sales_Dashboard.dbo.JUNIReporteVentaGral (Post_Date,	Amount_CAN,	OrderTotal_CAN,	Pay_Total_CAN,	Amount_USA,	OrderTotal_USA,	Pay_Total_USA,	Amount_Tot,	Amount_Order_Total,	Amount_Payment_Total,	Can_CreditCard,	USA_CreditCard,	CreditCardTotal,	Diff_Amon_Ord_Sap,	Diff_Dt_Am_Pay,	Diff_Pay_Rcc,	Diff_Can_Amon_Order,	Diff_Can_Amon_Payment,	Diff_Can_Payment_RCC,	Diff_Usa_Amon_Order,	Diff_Usa_Amon_Payment,	Diff_Usa_Payment_RCC,Fecha_Report) 

 SELECT A.Post_Date,a.Amount_CAN ,a.OrderTotal_CAN,a.Pay_Total_CAN,b.Amount_USA,b.OrderTotal_USA,b.Pay_Total_USA,a.Amount_CAN+b.Amount_USA as Amount_Tot,A.OrderTotal_CAN+b.OrderTotal_USA as Amount_Order_Total,A.Pay_Total_CAN+b.Pay_Total_USA as Amount_Payment_Total
 ,a.Amount_CAN as Can_CreditCard,b.Amount_USA as USA_CreditCard,A.Amount_CAN+b.Amount_USA as CreditCardTotal
 ,(A.OrderTotal_CAN+b.OrderTotal_USA)-(a.Amount_CAN+b.Amount_USA) as Diff_Amon_Ord_Sap,(a.Amount_CAN+b.Amount_USA)-(A.Pay_Total_CAN+b.Pay_Total_USA) as Diff_Dt_Am_Pay,(A.Pay_Total_CAN+b.Pay_Total_USA)-(A.Amount_CAN+b.Amount_USA) as Diff_Pay_Rcc
 ,(a.OrderTotal_CAN-a.Amount_CAN) as Diff_Can_Amon_Order,(a.Pay_Total_CAN-a.Amount_CAN) as Diff_Can_Amon_Payment,(A.Pay_Total_CAN -a.Amount_CAN) as Diff_Can_Payment_RCC
 ,(b.OrderTotal_USA-b.Amount_USA) as Diff_Usa_Amon_Order,(b.Pay_Total_USA-b.Amount_USA) as Diff_Usa_Amon_Payment,(b.Pay_Total_USA -b.Amount_USA) as Diff_Usa_Payment_RCC,@FechaIni as fechaReporte
 FROM ##vtasDTCAN a inner join ##vtasDTUSA b on a.Post_Date = b.Post_Date
order by 1 ;

select * from Sales_Dashboard.dbo.JUNIReporteVentaGral;

 END 


