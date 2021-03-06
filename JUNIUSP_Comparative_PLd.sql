USE [Nikken_HQ]
GO
/****** Object:  StoredProcedure [dbo].[JUNIUSP_Comparative_PLd]    Script Date: 28/06/2021 02:46:57 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[JUNIUSP_Comparative_PLd] (@FechaIni nvarchar(8),@FechaFin nvarchar(8))
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

--Declare @FechaIni nvarchar(8),@FechaFin nvarchar(8)

--Set @FechaIni = '20210601';
--Set @FechaFin = '20210630';

/**********************************/
--ELIMINA LAS TABLAS ANTES DE UTILIZAR

--exec JUNIUSP_Comparative_PLd '20210601','20210630'

IF OBJECT_ID('Sales_Dashboard.dbo.JUNISALESACCCOUNTRY') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNISALESACCCOUNTRY
IF OBJECT_ID('Sales_Dashboard.dbo.JUNICANSALES') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNICANSALES
IF OBJECT_ID('Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA') IS NOT NULL  drop table Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA
IF OBJECT_ID('Sales_Dashboard.dbo.JUNIUSASALES') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIUSASALES
IF OBJECT_ID('Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN
IF OBJECT_ID('Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTAL') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTAL
IF OBJECT_ID('tempdb..##JUNIPRODUCTSALESCANYEAR') IS NOT NULL  drop table  ##JUNIPRODUCTSALESCANYEAR
IF OBJECT_ID('tempdb..##JUNIPRODUCTSALESUSAYEAR') IS NOT NULL  drop table  ##JUNIPRODUCTSALESUSAYEAR
IF OBJECT_ID('Sales_Dashboard.dbo.JUNICANSALESYEAR') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNICANSALESYEAR
IF OBJECT_ID('Sales_Dashboard.dbo.JUNIUSASALESYEAR') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIUSASALESYEAR
IF OBJECT_ID('Sales_Dashboard.dbo.JUNISALESACCCOUNTRYYEAR') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNISALESACCCOUNTRYYEAR
IF OBJECT_ID('Sales_Dashboard.dbo.JUNIUSASALESYEAR') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIUSASALESYEAR
IF OBJECT_ID('Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTALYEAR') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTALYEAR

--IF OBJECT_ID('tempdb..Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab
--IF OBJECT_ID('Sales_Dashboard.dbo.JUNITotalRevenuebymonth') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNITotalRevenuebymonth
IF OBJECT_ID('Sales_Dashboard.dbo.JUNITotalRevenuebymonthGENRAL') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNITotalRevenuebymonthGENRAL
IF OBJECT_ID('tempdb..#JUNIReportVtasUnionCuaTab') IS NOT NULL  drop table  #JUNIReportVtasUnionCuaTab


IF OBJECT_ID('tempdb..##DataTrax_Ctas') IS NOT NULL  drop table  ##DataTrax_Ctas
IF OBJECT_ID('tempdb..##DataTrax_CtasFull') IS NOT NULL  drop table  ##DataTrax_CtasFull

SELECT A.COU,(sum(A.Debit)-SUM(A.Credit)) as Net,CASE 
 WHEN LTRIM(RTRIM(b.GLACCT)) ='4000-000-00' THEN '4000'
 WHEN b.GLACCT ='4300-000-00' THEN '4300'
 WHEN b.GLACCT ='4400-000-10' THEN '4400'
 WHEN b.GLACCT ='4900-000-00' THEN '4500'
 WHEN b.GLACCT = '4400-000-30'THEN '4400'
 WHEN b.GLACCT = '4902-000-00'THEN '4700'
END AS FatherNum,B.GLACCT
INTO ##DataTrax_Ctas
FROM [Sales_Dashboard].[dbo].Sales_DataTrax A 
INNER JOIN [Sales_Dashboard].[dbo].Codes_DataTrax B ON A.Report_CD = B.Code AND A.COU= B.COU 
where CONVERT(CHAR(8),PST_DT,112)BETWEEN @FechaIni AND @FechaFin  and A.COU ='CAN'
Group by A.COU,b.GLACCT
Order by 1,2



INSERT ##DataTrax_Ctas 
SELECT A.COU,(sum(A.Debit)-SUM(A.Credit)) as Net,CASE 
 WHEN b.GLACCT ='4000-00-000' THEN '4000'
 WHEN b.GLACCT ='4300-00-000' THEN '4300'
 WHEN b.GLACCT ='4400-00-010' THEN '4400'
 WHEN b.GLACCT ='4900-00-000' THEN '4500'
 WHEN b.GLACCT = '4400-00-030'THEN '4400'
 WHEN b.GLACCT = '4902-00-000'THEN '4700'
END AS FatherNum,B.GLACCT
FROM [Sales_Dashboard].[dbo].Sales_DataTrax A 
INNER JOIN [Sales_Dashboard].[dbo].Codes_DataTrax B ON A.Report_CD = B.Code AND A.COU= B.COU 
where CONVERT(CHAR(8),PST_DT,112)BETWEEN @FechaIni AND @FechaFin and A.COU ='USA'
Group by A.COU,b.GLACCT
Order by 1,2


SELECT COU,-1*SUM(Net)as Net,FatherNum into ##DataTrax_CtasFull FROM ##DataTrax_Ctas WHERE FatherNum IS NOT NULL  GROUP BY COU,FatherNum

IF OBJECT_ID('tempdb..##DataTrax_Ctas_USA') IS NOT NULL  drop table  ##DataTrax_Ctas_USA
IF OBJECT_ID('tempdb..##DataTrax_Ctas_CAN') IS NOT NULL  drop table  ##DataTrax_Ctas_CAN


select * into ##DataTrax_Ctas_USA from ##DataTrax_CtasFull where COU ='USA'

select * into ##DataTrax_Ctas_CAN from ##DataTrax_CtasFull where COU ='CAN'

/***********PRIMER GENERACION DE TABLA**********/
IF OBJECT_ID('tempdb..##USA4546471') IS NOT NULL  drop table  ##USA4546471

SELECT 'Nikken Inc.' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-00-000'
 WHEN T0.FatherNum = '4300' THEN '4300-00-000'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-00-000'
 WHEN T0.FatherNum = '4600' THEN '4600-00-000'
 WHEN T0.FatherNum = '4700' THEN '4902-00-000'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
SUM(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) -SUM(T1.[Credit]-T1.[Debit])) as DIFF
INTO ##USA4546471
FROM [Live_Nikken_INC].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_USA T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIni AND @FechaFin
AND T0.FatherNum in ('4000','4300','4400')
GROUP BY T0.[FatherNum],t3.Net
ORDER BY T0.[FatherNum]

/*******esta es la primer tabla para hacrla union******/
--SELECT  * FROM ##USA4546471  ORDER BY Descrip

/******************************************/
--TABLA DE USA DE 40000


--CREACION DE LA TABLA POR MES  DE USA

--IF OBJECT_ID('tempdb..##PRUEBA') IS NOT NULL  drop table  ##PRUEBA
--IF OBJECT_ID('tempdb..Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA

create table Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA
(Country nvarchar(20),
Descrip Nvarchar(50) , 
Account Nvarchar(50),
DATATRAX numeric(19,6),
SAP_BO Numeric(19,6), 
Diff numeric(19,6),
Seg numeric(19)
)

insert into Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA
SELECT 'Nikken Inc.' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-00-000'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS segmento
--into ##PRUEBA
FROM [Live_Nikken_INC].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_USA T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN  @FechaIni AND @FechaFin


--AND T0.Segment_0 in ('40000','42000','43000','44000','45000')
--GROUP BY T0.[Segment_0]
--ORDER BY T0.[Segment_0]

--SELECT  * FROM ##PRUEBA

--select * from Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA


SELECT 
CASE 
 WHEN Seg = '40000' THEN 'OTHERS PROD'
 WHEN Seg = '40200' THEN 'ENVIRONMENT'
 WHEN Seg = '40300' THEN 'NUTRITION AND SKIN CARE'
 WHEN Seg = '40400' THEN 'REST AND RELAXATION'
 WHEN Seg = '40500' THEN 'AIDS'
END AS AccountName
,sum(SAP_BO)as SAP_BO,Seg FROM Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA where Account='4000-000-00' GROUP BY Descrip,Seg

IF OBJECT_ID('tempdb..Sales_Dashboard.dbo.Sales_Dashboard.dbo.JUNIUSASALES') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIUSASALES



/********************************/
--SUMA GENERAL DE LOS 4000

IF OBJECT_ID('tempdb..##tOTALGENERALUSA') IS NOT NULL  drop table  ##tOTALGENERALUSA

-----------------------------SUMA DE LAS TABLAS

SELECT 'OTHERS REV' AS OTHER_REVGENERAL ,SUM(SAP_BO )AS TOTALGENERAL  
INTO ##tOTALGENERALUSA
FROM 
(
SELECT sum(SAP_BO)as SAP_BO,Seg FROM Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA where Account IN ('4000-000-00','4300-000-00','4400-00-010 & 4400-00-030','4900-000-00','4902-000-00') GROUP BY Descrip,Seg
)AS BI

IF OBJECT_ID('tempdb..##TOTALSALESUSA') IS NOT NULL  drop table  ##TOTALSALESUSA

SELECT 'OTHERS REV'AS OTHER_REV,SUM(SAP_BO )AS TOTALGE  
INTO ##TOTALSALESUSA
FROM (
SELECT
sum(SAP_BO)as SAP_BO,Seg FROM Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA where Account='4000-000-00' GROUP BY Descrip,Seg
)AS BSI
--UNIOND E LAS TAVLAS PARA HACER OPERACION 


SELECT 'OTHERS REV'AS OTHER_REV,(##tOTALGENERALUSA.TOTALGENERAL-##TOTALSALESUSA.TOTALGE)AS TOTI FROM ##tOTALGENERALUSA INNER JOIN ##TOTALSALESUSA ON ##tOTALGENERALUSA.OTHER_REVGENERAL=##TOTALSALESUSA.OTHER_REV


create table Sales_Dashboard.dbo.JUNIUSASALES
(AcountName nvarchar(100),
SAP_BO NUMERIC (19,6),
Segmento Numeric(19),
Country NVARCHAR (25)
)

insert into Sales_Dashboard.dbo.JUNIUSASALES
SELECT 
CASE 
 WHEN Seg = '40000' THEN 'SALES'
 WHEN Seg = '40200' THEN 'ENVIRONMENT'
 WHEN Seg = '40300' THEN 'NUTRITION AND SKIN CARE'
 WHEN Seg = '40400' THEN 'REST AND RELAXATION'
 WHEN Seg = '40500' THEN 'AIDS'
 WHEN Seg = '43000' THEN 'RETURNS AND ALLOWANCES'
 WHEN Seg = '44100' THEN 'DISCOUNTS'
 WHEN Seg = '44300' THEN 'REWARDS POINTS'
 WHEN Seg = '45000' THEN 'RENEWAL FEE'
 WHEN Seg = '47010' THEN 'DELIVERY FEE'
 WHEN Seg = '46010' THEN 'SERVICE FEE'
END AS AccountName,
--Account,
sum(SAP_BO)as SAP_BO,
Seg ,'Nikken Inc.' AS COUNTRY FROM Sales_Dashboard.dbo.JUNIPRODUCTSALESUSA where Account<>'' --
GROUP BY Descrip,Seg order by Seg 



/****************************************************************************
*PRUEBA DE GENERAL DE POR AÑO
***************************************************************************/
--declare @FechaIni varchar(8) = '20201201'
--declare @fecha VARCHAR(8)='20210430'

--declare @FechaIni varchar(8) = '20201201' 

--declare @FechaInis varchar(8) =  CONVERT(CHAR(8),DATEADD(YEAR,-1,@FechaIni),112)
declare @FechaInis varchar(8) = '20210101'

select @FechaInis
IF OBJECT_ID('tempdb..##USA45464711') IS NOT NULL  drop table  ##USA45464711


 
SELECT 'Nikken Inc.' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-00-000'
 WHEN T0.FatherNum = '4300' THEN '4300-00-000'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-00-000'
 WHEN T0.FatherNum = '4600' THEN '4600-00-000'
 WHEN T0.FatherNum = '4700' THEN '4902-00-000'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
SUM(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) -SUM(T1.[Credit]-T1.[Debit])) as DIFF
INTO ##USA45464711
FROM [Live_Nikken_INC].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_USA T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaInis AND @FechaFin
AND T0.FatherNum in ('4000','4300','4400')
GROUP BY T0.[FatherNum],t3.Net
ORDER BY T0.[FatherNum]


/****************************************************************************
****************************************************************************/



/**********************************************/
--PRUEBA PARA INGRESAR TODA LA IFNORMACION
IF OBJECT_ID('tempdb..##USA454647') IS NOT NULL  drop table  ##USA454647

/********************PRIMER PARTE DE MOSTRAR INFORMACION**********************************/
SELECT 'Nikken Inc.' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-00-000'
 WHEN T0.FatherNum = '4300' THEN '4300-00-000'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-00-000'
 WHEN T0.FatherNum = '4600' THEN '4600-00-000'
 WHEN T0.FatherNum = '4700' THEN '4902-00-000'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
SUM(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) -SUM(T1.[Credit]-T1.[Debit])) as DIFF
INTO ##USA454647
FROM [Live_Nikken_INC].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_USA T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIni AND @FechaFin
AND T0.FatherNum in ('4500','4600','4700')
GROUP BY T0.[FatherNum],t3.Net
ORDER BY T0.[FatherNum]

select * from ##USA454647


IF  NOT EXISTS (SELECT * FROM ##USA454647 WHERE Descrip ='4600- DISTRIBUTOR SERVICES FEE')

BEGIN 

  INSERT  ##USA454647
  SELECT 'USA','4600- DISTRIBUTOR SERVICES FEE','',0,0,0
END 
/******************SEGUNDA PARTE******************/
--SELECT * FROM ##USA454647   ORDER BY Descrip


IF OBJECT_ID('tempdb..##CAN4546471') IS NOT NULL  drop table  ##CAN4546471
SELECT 'Nikken Canada' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-000-00'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
SUM(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) -SUM(T1.[Credit]-T1.[Debit])) as DIFF
INTO ##CAN4546471
FROM [Live_Nikken_CAD].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_CAN T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIni AND @FechaFin
AND T0.FatherNum in ('4000','4300','4400')
GROUP BY T0.[FatherNum],t3.Net
ORDER BY T0.[FatherNum]

--SELECT * FROM ##CAN4546471 ORDER BY Descrip


/**********************************************************/

--CREACION DE LA TABLA POR MES  DE CANADA

IF OBJECT_ID('tempdb..##PRUEBA') IS NOT NULL  drop table  ##PRUEBA
IF OBJECT_ID('tempdb..Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN

create table Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN
(Country nvarchar(25),
Descrip Nvarchar(50) , 
Account Nvarchar(50),
CATATRAX numeric(19,6),
SAP_BO Numeric(19,6), 
Diff numeric(19,6),
Seg numeric(19)
)

insert into Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN
SELECT 'Nikken Canada' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-000-00'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS segmento
--into ##PRUEBA
FROM [Live_Nikken_CAD].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_CAN T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIni AND @FechaFin
--AND T0.Segment_0 in ('40000','42000','43000','44000','45000')
--GROUP BY T0.[Segment_0]
--ORDER BY T0.[Segment_0]

--SELECT  * FROM ##PRUEBA

--select * from Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN

create table Sales_Dashboard.dbo.JUNICANSALES
(AcountName nvarchar(100),
SAP_BO NUMERIC (19,6),
Segmento Numeric(19),
COUNTRY VARCHAR (20)
)

INSERT INTO Sales_Dashboard.dbo.JUNICANSALES
SELECT 
CASE 
 WHEN Seg = '40000' THEN 'SALES'
 WHEN Seg = '40200' THEN 'ENVIRONMENT'
 WHEN Seg = '40300' THEN 'NUTRITION AND SKIN CARE'
 WHEN Seg = '40400' THEN 'REST AND RELAXATION'
 WHEN Seg = '40500' THEN 'AIDS'
 WHEN Seg = '43000' THEN 'RETURNS AND ALLOWANCES'
 WHEN Seg = '44100' THEN 'DISCOUNTS'
 WHEN Seg = '44300' THEN 'REWARDS POINTS'
 WHEN Seg = '45000' THEN 'RENEWAL FEE'
 WHEN Seg = '47010' THEN 'DELIVERY FEE'
 WHEN Seg = '46010' THEN 'SERVICE FEE'
END AS AccountName,
--Account,
sum(SAP_BO)as SAP_BO,
Seg ,'Nikken Canada' AS COUNTRY FROM Sales_Dashboard.dbo.JUNIPRODUCTSALESCAN where Account<>'' --
GROUP BY Descrip,Seg
/********************************************************/

create table Sales_Dashboard.dbo.JUNISALESACCCOUNTRY
(AcountName nvarchar(100),
SAP_BO NUMERIC (19,6),
Segmento Numeric(19),
COUNTRY VARCHAR (20)
)

INSERT INTO Sales_Dashboard.dbo.JUNISALESACCCOUNTRY
SELECT * FROM Sales_Dashboard.dbo.JUNICANSALES --WHERE AcountName <> 'NULL'
UNION
SELECT * FROM Sales_Dashboard.dbo.JUNIUSASALES-- WHERE AcountName <> 'NULL'

/**************************************************************************/
--suma general de las dos tablas 

-- drop table Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTAL
create table Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTAL
(Country nvarchar (40),
Total Numeric(19,6)
)

insert into Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTAL
SELECT 'Nikken Canada'as COUNTRY,sum(SAP_BO)as total FROM Sales_Dashboard.dbo.JUNICANSALES group by COUNTRY
UNION
SELECT 'Nikken Inc.'as COUNTRY,sum(SAP_BO)as total FROM Sales_Dashboard.dbo.JUNIUSASALES GROUP BY COUNTRY
/****************************************************************************
TOTAL DE REVENUE POR AÑO
****************************************************************************/
--CANADA
IF OBJECT_ID('tempdb..##JUNIPRODUCTSALESCANYEAR') IS NOT NULL  drop table  ##JUNIPRODUCTSALESCANYEAR

SELECT 'Nikken Canada' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-000-00'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS Seg
into ##JUNIPRODUCTSALESCANYEAR
FROM [Live_Nikken_CAD].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_CAN T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN '20210101' AND @FechaFin

select * from ##JUNIPRODUCTSALESCANYEAR

create table Sales_Dashboard.dbo.JUNICANSALESYEAR
(AcountName nvarchar(100),
SAP_BO NUMERIC (19,6),
Segmento Numeric(19),
Country VARCHAR (20)
)

INSERT INTO Sales_Dashboard.dbo.JUNICANSALESYEAR
SELECT 
CASE 
 WHEN Seg = '40000' THEN 'SALES'
 WHEN Seg = '40200' THEN 'ENVIRONMENT'
 WHEN Seg = '40300' THEN 'NUTRITION AND SKIN CARE'
 WHEN Seg = '40400' THEN 'REST AND RELAXATION'
 WHEN Seg = '40500' THEN 'AIDS'
 WHEN Seg = '43000' THEN 'RETURNS AND ALLOWANCES'
 WHEN Seg = '44100' THEN 'DISCOUNTS'
 WHEN Seg = '44300' THEN 'REWARDS POINTS'
 WHEN Seg = '45000' THEN 'RENEWAL FEE'
 WHEN Seg = '47010' THEN 'DELIVERY FEE'
 WHEN Seg = '46010' THEN 'SERVICE FEE'
END AS AccountName,
--Account,
sum([SAP BO])as SAP_BO,
Seg ,'Nikken Canada' AS COUNTRY 
FROM ##JUNIPRODUCTSALESCANYEAR where Account<>'' --
GROUP BY Descrip,Seg

select * from  Sales_Dashboard.dbo.JUNICANSALESYEAR
--USA
IF OBJECT_ID('tempdb..##JUNIPRODUCTSALESUSAYEAR') IS NOT NULL  drop table  ##JUNIPRODUCTSALESUSAYEAR

SELECT 'Nikken Inc.' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-00-000'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS Seg
into ##JUNIPRODUCTSALESUSAYEAR
FROM [Live_Nikken_INC].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_USA T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN  '20210101' AND @FechaFin

SELECT * FROM ##JUNIPRODUCTSALESUSAYEAR

create table Sales_Dashboard.dbo.JUNIUSASALESYEAR
(AcountName nvarchar(100),
SAP_BO NUMERIC (19,6),
Segmento Numeric(19),
Country NVARCHAR (25)
)
insert into Sales_Dashboard.dbo.JUNIUSASALESYEAR
SELECT 
CASE 
 WHEN Seg = '40000' THEN 'SALES'
 WHEN Seg = '40200' THEN 'ENVIRONMENT'
 WHEN Seg = '40300' THEN 'NUTRITION AND SKIN CARE'
 WHEN Seg = '40400' THEN 'REST AND RELAXATION'
 WHEN Seg = '40500' THEN 'AIDS'
 WHEN Seg = '43000' THEN 'RETURNS AND ALLOWANCES'
 WHEN Seg = '44100' THEN 'DISCOUNTS'
 WHEN Seg = '44300' THEN 'REWARDS POINTS'
 WHEN Seg = '45000' THEN 'RENEWAL FEE'
 WHEN Seg = '47010' THEN 'DELIVERY FEE'
 WHEN Seg = '46010' THEN 'SERVICE FEE'
END AS AccountName,
--Account,
sum([SAP BO])as SAP_BO,
Seg ,'Nikken Inc.' AS COUNTRY FROM ##JUNIPRODUCTSALESUSAYEAR where Account<>'' --
GROUP BY Descrip,Seg order by Seg 


--TOTAL

create table Sales_Dashboard.dbo.JUNISALESACCCOUNTRYYEAR
(AcountName nvarchar(100),
SAP_BO NUMERIC (19,6),
Segmento Numeric(19),
Country VARCHAR (20)
)
INSERT INTO Sales_Dashboard.dbo.JUNISALESACCCOUNTRYYEAR
SELECT * FROM Sales_Dashboard.dbo.JUNICANSALESYEAR --WHERE AcountName <> 'NULL'
UNION
SELECT * FROM Sales_Dashboard.dbo.JUNIUSASALESYEAR WHERE AcountName <> 'NULL'

SELECT * FROM Sales_Dashboard.dbo.JUNISALESACCCOUNTRYYEAR

create table Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTALYEAR	
(Country nvarchar (40),
Total Numeric(19,6)
)

insert into Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTALYEAR	
SELECT 'Nikken Canada'as COUNTRY,sum(SAP_BO)as total FROM Sales_Dashboard.dbo.JUNICANSALESYEAR group by COUNTRY
UNION
SELECT 'Nikken Inc.'as COUNTRY,sum(SAP_BO)as total FROM Sales_Dashboard.dbo.JUNIUSASALESYEAR GROUP BY COUNTRY


SELECT * FROM Sales_Dashboard.dbo.JUNISALESACCCOUNTRYTOTALYEAR


/*************************************************************************
*************************************************************************/

IF OBJECT_ID('tempdb..##CAN454647') IS NOT NULL  drop table  ##CAN454647

SELECT 'Nikken Canada' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-000-010 & 4400-000-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN ''
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
ISNULL(t3.Net,0) as DATATRAX ,
SUM(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) -SUM(T1.[Credit]-T1.[Debit])) as DIFF
into ##CAN454647
FROM [Live_Nikken_CAD].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_CAN T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIni AND @FechaFin
AND T0.FatherNum in ('4500','4600','4700')
GROUP BY T0.[FatherNum],t3.Net
ORDER BY T0.[FatherNum]


IF  NOT EXISTS (SELECT * FROM ##CAN454647 WHERE Descrip ='4600- DISTRIBUTOR SERVICES FEE')
BEGIN 

  INSERT  ##CAN454647
  SELECT 'CAN','4600- DISTRIBUTOR SERVICES FEE','',0,0,0
END 


--SELECT * FROM ##CAN454647   ORDER BY Descrip
 

 /*drop table Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab 
 */
 
CREATE TABLE  #JUNIReportVtasUnionCuaTab(
Country nvarchar(30),
Descrip Nvarchar(50) , 
Account Nvarchar(50),
CATATRAX numeric(19,6),
SAP_BO Numeric(19,6), 
Diff numeric(19,6),
Fecha_Report date
)

 INSERT #JUNIReportVtasUnionCuaTab
 SELECT *,@Fechaini FROM ##USA4546471
 UNION 
 SELECT *,@FechaIni FROM ##USA454647
 UNION
 SELECT *,@FechaIni FROM ##CAN4546471 
 UNION 
 SELECT *,@FechaIni FROM ##CAN454647

--ALTER TABLE Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab ADD Fecha_Report date;

--update Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab set Fecha_Report = @FechaIni;
--drop table Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab

/*create table Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab
(Country nvarchar(30),
Descrip Nvarchar(50) , 
Account Nvarchar(50),
CATATRAX numeric(19,6),
SAP_BO Numeric(19,6), 
Diff numeric(19,6),
Fecha_Report date
)
*/
 INSERT Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab
-- select * from Sales_Dashboard.dbo.ReportVtasUnionCuaTab
 select * from #JUNIReportVtasUnionCuaTab

 --drop table #JUNIReportVtasUnionCuaTab
 

 --select * from Sales_Dashboard.dbo.JUNIReportVtasUnionCuaTab


 /*************************************************************
 *************************************************************/

 --TABLA DE TOTAL DE REVENUE BY MONTH 2020-2021 de canada

 
declare @FechaIniUNI varchar(8) =  CONVERT(CHAR(8),DATEADD(YEAR,-1,@FechaIni),112)
SELECT @FechaIniUNI

--SECCION PARA CANADA 
--hacer la tabla para canada 
IF OBJECT_ID('tempdb..##TotalRevenuebymonth') IS NOT NULL  drop table ##TotalRevenuebymonth

--drop table ##JUNITotalRevenuebymonth  

SELECT 'Nikken Canada' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-000-00'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
CONVERT(CHAR(6),T2.[RefDate],112) as fecha,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS segmento
into ##TotalRevenuebymonth
FROM [Live_Nikken_CAD].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_CAN T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN  @FechaIniUNI AND @FechaFin--'20200401' AND '20210430'

select * from ##TotalRevenuebymonth
--SELECCION DE USA
--table usa

IF OBJECT_ID('tempdb..##TotalRevenuebymonthusa') IS NOT NULL  drop table  ##TotalRevenuebymonthusa

--drop table ##TotalRevenuebymonthusa 

SELECT 'Nikken Inc.' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-00-000'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
CONVERT(CHAR(6),T2.[RefDate],112) as fecha,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS segmento
into ##TotalRevenuebymonthusa 
FROM [Live_Nikken_INC].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_USA T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIniUNI AND @FechaFin--'20200401' AND '20210430'

select * from ##TotalRevenuebymonthusa

 /***************************************************************
 ***************************************************************/
 -- tala para unir las dos tablas y crear total revenue by month

 --drop table Sales_Dashboard.dbo.JUNITotalRevenuebymonth
 /*IF OBJECT_ID('tempdb..Sales_Dashboard.dbo.TotalRevenuebymonth') IS NOT NULL  drop table  Sales_Dashboard.dbo.TotalRevenuebymonth
 create table Sales_Dashboard.dbo.TotalRevenuebymonth
(SAP_BO NUMERIC (19,6),
FECHA numeric(19),
country nvarchar(10),
descrip nvarchar (100)
)*/
--hacer insert en tabla general

--INSERT INTO Sales_Dashboard.dbo.TotalRevenuebymonth

 select SUM([SAP BO])AS SAP_BO,FECHA,'Nikken Canada' AS COUNTRY,
 CASE 
  WHEN FECHA = '202004' THEN '2020-04'
 WHEN FECHA = '202005' THEN '2020-05'
 WHEN FECHA = '202006' THEN '2020-06'
 WHEN FECHA = '202007' THEN '2020-07'
 WHEN FECHA = '202008' THEN '2020-08'
 WHEN FECHA = '202009' THEN '2020-09'
 WHEN FECHA = '202010' THEN '2020-10'
 WHEN FECHA = '202011' THEN '2020-11'
 WHEN FECHA = '202012' THEN '2020-12'
 WHEN FECHA = '202101' THEN '2021-01'
 WHEN FECHA = '202102' THEN '2021-02'
 WHEN FECHA = '202103' THEN '2021-03'
 WHEN FECHA = '202104' THEN '2021-04'
 END AS Descrip
 from  ##TotalRevenuebymonth WHERE ACCOUNT IN ('4000-000-00','4300-000-00','4400-00-010 & 4400-00-030','4600-000-00','4900-000-00','4902-000-00') GROUP BY FECHA
 union
 select SUM([SAP BO])AS SAP_BO,FECHA,'Nikken Inc.' AS COUNTRY,
 CASE 
 WHEN FECHA = '202004' THEN '2020-04'
 WHEN FECHA = '202005' THEN '2020-05'
 WHEN FECHA = '202006' THEN '2020-06'
 WHEN FECHA = '202007' THEN '2020-07'
 WHEN FECHA = '202008' THEN '2020-08'
 WHEN FECHA = '202009' THEN '2020-09'
 WHEN FECHA = '202010' THEN '2020-10'
 WHEN FECHA = '202011' THEN '2020-11'
 WHEN FECHA = '202012' THEN '2020-12'
 WHEN FECHA = '202101' THEN '2021-01'
 WHEN FECHA = '202102' THEN '2021-02'
 WHEN FECHA = '202103' THEN '2021-03'
 WHEN FECHA = '202104' THEN '2021-04'
  END AS Descrip
 from  ##TotalRevenuebymonthusa WHERE ACCOUNT <> '' group by fecha --IN ('4000-000-00','4300-000-00','4400-00-010 & 4400-00-030','4600-000-00','4900-000-00','4902-000-00') GROUP BY FECHA
 
-- drop table  ##TotalRevenuebymonthusa
 
 select * from Sales_Dashboard.dbo.JUNITotalRevenuebymonth order by country,FECHA
 
 /*******************************************
 ********************************************/
 --tala de niken canada sales trend by category yera 2021

 IF OBJECT_ID('tempdb..##TotalRevenuebymonthcategoryCANADA') IS NOT NULL  drop table  ##TotalRevenuebymonthcategoryCANADA
 --drop table ##TotalRevenuebymonthcategoryCANADA
 
SELECT 'Nikken Canada' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-000-00'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
CONVERT(CHAR(6),T2.[RefDate],112) as fecha,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS segmento
into ##TotalRevenuebymonthcategoryCANADA
FROM [Live_Nikken_CAD].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_CAN T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIniUNI AND @FechaFin-- '20200401' AND '20210430'

IF OBJECT_ID('tempdb..##TotalRevenuebymonthcaNADA') IS NOT NULL  drop table  ##TotalRevenuebymonthcaNADA


--drop table Sales_Dashboard.dbo.##TotalRevenuebymonthcategoryCANADA 
select 
--sum([SAP BO])AS SAP_BO,
CASE 
  WHEN segmento = '40200' THEN 'ENVIRONMENT'
 WHEN segmento = '40300' THEN 'NUTRITION AND SKIN CARE'
 WHEN segmento = '40400' THEN 'REST AND RELAXATION'
 end AS AccountName,*
 into ##TotalRevenuebymonthcaNADA
from ##TotalRevenuebymonthcategoryCANADA where segmento in('40200','40300','40400') 

/**************************************************************
**************************************************************/
--USA
IF OBJECT_ID('tempdb..##TotalRevenuebymonthcategoryUSA') IS NOT NULL  drop table  ##TotalRevenuebymonthcategoryUSA

--drop table  ##TotalRevenuebymonthcategoryUSA

SELECT 'Nikken Inc.' as Country,
CASE 
 WHEN T0.FatherNum = '4000' THEN T0.[FatherNum]+'- PRODUCT SALES'
 WHEN T0.FatherNum = '4300' THEN T0.[FatherNum]+'- SALES RETURNS AND ALLOW'
 WHEN T0.FatherNum = '4400' THEN T0.[FatherNum]+'- PRODUCT DISCOUNTS'
 WHEN T0.FatherNum = '4500' THEN T0.[FatherNum]+'- DISTRIBUTOR RENEWAL FEE'
 WHEN T0.FatherNum = '4600' THEN T0.[FatherNum]+'- DISTRIBUTOR SERVICES FEE'
 WHEN T0.FatherNum = '4700' THEN T0.[FatherNum]+'- DISTRIBUTOR DELIVERY FEE'
END AS Descrip,
CASE 
 WHEN T0.FatherNum = '4000' THEN '4000-000-00'
 WHEN T0.FatherNum = '4300' THEN '4300-000-00'
 WHEN T0.FatherNum = '4400' THEN '4400-00-010 & 4400-00-030'
 WHEN T0.FatherNum = '4500' THEN '4900-000-00'
 WHEN T0.FatherNum = '4600' THEN '4600-00-000'
 WHEN T0.FatherNum = '4700' THEN '4902-000-00'
END AS Account,
CONVERT(CHAR(6),T2.[RefDate],112) as fecha,
ISNULL(t3.Net,0) as DATATRAX ,
(T1.[Credit]-T1.[Debit]) AS [SAP BO],
-1*(ISNULL(T3.Net,0) - (T1.[Credit]-T1.[Debit])) as DIFF,
try_convert(numeric(19),T0.Segment_0)  AS segmento
into ##TotalRevenuebymonthcategoryUSA 
FROM [Live_Nikken_INC].[dbo].OACT T0 WITH(NOLOCK)
LEFT JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.AcctCode = T1.Account 
LEFT JOIN [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK) ON T1.TransId = T2.TransId
LEFT JOIN ##DataTrax_Ctas_USA T3 WITH(NOLOCK) ON T0.FatherNum = T3.FatherNum COLLATE DATABASE_DEFAULT
WHERE CONVERT(CHAR(8),T2.[RefDate],112) BETWEEN @FechaIniUNI AND @FechaFin--'20200401' AND '20210430'

IF OBJECT_ID('tempdb..##TotalRevenuebymonthcategoryUSAA') IS NOT NULL  drop table  ##TotalRevenuebymonthcategoryUSAA

select 
--sum([SAP BO])AS SAP_BO,
CASE 
  WHEN segmento = '40200' THEN 'ENVIRONMENT'
 WHEN segmento = '40300' THEN 'NUTRITION AND SKIN CARE'
 WHEN segmento = '40400' THEN 'REST AND RELAXATION'
 end AS AccountName,*
 into ##TotalRevenuebymonthcategoryUSAA
from ##TotalRevenuebymonthcategoryUSA  where segmento in('40200','40300','40400') 




--sentencia para general revenue by category month
IF OBJECT_ID('Sales_Dashboard.dbo.JUNITotalRevenuebymonthGENRAL') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNITotalRevenuebymonthGENRAL

create table Sales_Dashboard.dbo.JUNITotalRevenuebymonthGENRAL 
(COUNTRY NVARCHAR(100),
SAP_BO NUMERIC (19,6),
FECHA NUMERIC(19),
DESCRIP NVARCHAR(150)
)
INSERT INTO Sales_Dashboard.dbo.JUNITotalRevenuebymonthGENRAL 
select * from Sales_Dashboard.dbo.JUNITotalRevenuebymonth order by country,FECHA

-----
select * from Sales_Dashboard.dbo.JUNITotalRevenuebymonthGENRAL 
END
