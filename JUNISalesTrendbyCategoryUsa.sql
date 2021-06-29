-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE JUNISalesTrendbyCategoryUsa 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @fechaInipoli  as nvarchar(10), @fechafinpoli as nvarchar(10)

SET @fechaInipoli = '2021-04-01'
SET @fechafinpoli = '2021-04-30'

IF OBJECT_ID('tempdb..##foliosPolizas') IS NOT NULL  drop table  ##foliosPolizas

select	 distinct OJDT.Number
into ##foliosPolizas
from [Live_Nikken_CAD].[dbo].jdt1 left join [Live_Nikken_CAD].[dbo].oact on jdt1.Account = oact.AcctCode left join [Live_Nikken_CAD].[dbo].OJDT ON jdt1.TransId = OJDT.TransId
where year(jdt1.refDate) = year(@fechaInipoli) and jdt1.transType = '-3' and  Memo NOT LIKE '%'+CONVERT(CHAR(4),year(DATEADD(YEAR,-1,(@fechaInipoli))))+'%'

declare @fechaIni  as nvarchar(10), @fechafin as nvarchar(10)

SET @fechaIni = '2021-04-01'
SET @fechafin = '2021-04-31'

/***************************************************************************************************************************************************************************

TABLAS PARA GENERAR SAES TRHEND BY CATEGORY YEAR 2020-2021 CANADA

***************************************************************************************************************************************************************************/
declare @fechaIniJUNIO  as nvarchar(10), @fechafinJUNIO as nvarchar(10)

SET @fechaIniJUNIO = '2021-06-01'
SET @fechafinJUNIO=  '2021-06-30'

IF OBJECT_ID('tempdb..##RevenueJUNIO21') IS NOT NULL  drop table  ##RevenueJUNIO21


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2021-06'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniJUNIO) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueJUNIO21
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniJUNIO AND  @fechafinJUNIO  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniMAYO  as nvarchar(10), @fechafinMAYO as nvarchar(10)

SET @fechaIniMAYO = '2021-05-01'
SET @fechafinMAYO = '2021-05-31'

IF OBJECT_ID('tempdb..##Revenuemayo20') IS NOT NULL  drop table  ##Revenuemayo20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2021-05'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniMAYO) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##Revenuemayo20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniMAYO AND  @fechaFinMAYO  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0






declare @fechaIniABRIL  as nvarchar(10), @fechafinABRIL as nvarchar(10)

SET @fechaIniABRIL = '2021-04-01'
SET @fechafinABRIL = '2021-04-30'

IF OBJECT_ID('tempdb..##Revenueabril20') IS NOT NULL  drop table  ##Revenueabril20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2021-04'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniABRIL) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##Revenueabril20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniABRIL AND  @fechaFinABRIL  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0

--select AcctName,'202104' as fech,fecha as Descrip,Credit AS SAB_BO from ##Revenueabril20




declare @fechaIniMARZO  as nvarchar(10), @fechafinMARZO as nvarchar(10)

SET @fechaIniMARZO = '2021-03-01'
SET @fechafinMARZO = '2021-03-31'

IF OBJECT_ID('tempdb..##Revenuemarzo20') IS NOT NULL  drop table  ##Revenuemarzo20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2021-03'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniMARZO) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##Revenuemarzo20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniMARZO AND  @fechaFinMARZO  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniFEBRE  as nvarchar(10), @fechafinFEBRE as nvarchar(10)

SET @fechaIniFEBRE = '2021-02-01'
SET @fechafinFEBRE = '2021-02-28'

IF OBJECT_ID('tempdb..##Revenuefebre20') IS NOT NULL  drop table  ##Revenuefebre20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2021-02'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniFEBRE) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##Revenuefebre20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniFEBRE AND  @fechaFinFEBRE  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0

SELECT * FROM ##Revenuefebre20



declare @fechaIniENE  as nvarchar(10), @fechafinENE as nvarchar(10)

SET @fechaIniENE = '2021-01-01'
SET @fechafinENE = '2021-01-31'

IF OBJECT_ID('tempdb..##RevenueENE20') IS NOT NULL  drop table  ##RevenueENE20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2021-01'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniENE) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueENE20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniENE AND  @fechafinENE  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0

SELECT * FROM ##RevenueENE20


declare @fechaIniDIC20  as nvarchar(10), @fechafinDIC20 as nvarchar(10)

SET @fechaIniDIC20 = '2020-12-01'
SET @fechafinDIC20 = '2020-12-31'

IF OBJECT_ID('tempdb..##RevenueDIC20') IS NOT NULL  drop table  ##RevenueDIC20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2020-12'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniDIC20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueDIC20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniDIC20 AND  @fechafinDIC20  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0





declare @fechaIniNOV20  as nvarchar(10), @fechafinNOV20 as nvarchar(10)

SET @fechaIniNOV20 = '2020-11-01'
SET @fechafinNOV20 = '2020-11-30'

IF OBJECT_ID('tempdb..##RevenueNOV20') IS NOT NULL  drop table  ##RevenueNOV20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2020-11'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniNOV20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueNOV20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniNOV20 AND  @fechafinNOV20  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0




	
	declare @fechaIniOCT20  as nvarchar(10), @fechafinOCT20 as nvarchar(10)

SET @fechaIniOCT20 = '2020-10-01'
SET @fechafinOCT20 = '2020-10-31'

IF OBJECT_ID('tempdb..##RevenueOCT20') IS NOT NULL  drop table  ##RevenueOCT20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2020-10'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniOCT20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueOCT20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniOCT20 AND  @fechafinOCT20  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0






declare @fechaIniSEP20  as nvarchar(10), @fechafinSEP20 as nvarchar(10)

SET @fechaIniSEP20 = '2020-09-01'
SET @fechafinSEP20 = '2020-09-30'

IF OBJECT_ID('tempdb..##RevenueSEP20') IS NOT NULL  drop table  ##RevenueSEP20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2020-09'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniSEP20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueSEP20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniSEP20 AND  @fechafinSEP20  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0





declare @fechaIniAGO20  as nvarchar(10), @fechafinAGO20 as nvarchar(10)

SET @fechaIniAGO20 = '2020-08-01'
SET @fechafinAGO20 = '2020-08-31'

IF OBJECT_ID('tempdb..##RevenueAGO20') IS NOT NULL  drop table  ##RevenueAGO20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2020-08'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniAGO20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueAGO20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniAGO20 AND  @fechafinAGO20  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0
SELECT *FROM ##RevenueAGO20





declare @fechaIniJUL20  as nvarchar(10), @fechafinJUL20 as nvarchar(10)

SET @fechaIniJUL20 = '2020-07-01'
SET @fechafinJUL20 = '2020-07-31'

IF OBJECT_ID('tempdb..##RevenueJUL20') IS NOT NULL  drop table  ##RevenueJUL20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2020-07'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniJUL20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueJUL20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniJUL20 AND  @fechafinJUL20  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0




declare @fechaIniJUN20  as nvarchar(10), @fechafinJUN20 as nvarchar(10)

SET @fechaIniJUN20 = '2020-06-01'
SET @fechafinJUN20 = '2020-06-30'

IF OBJECT_ID('tempdb..##RevenueJUN20') IS NOT NULL  drop table  ##RevenueJUN20


SELECT T2.[AcctName], t2.Groupmask as 'acc type' , '2020-06'as fecha ,
Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniJUN20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.Segment_0
INTO ##RevenueJUN20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.[RefDate] BETWEEN @fechaIniJUN20 AND  @fechafinJUN20  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
--WHERE T0.RefDate >= @fechaIni AND T0.RefDate <= @fechaFin  and  T2.Segment_0 IN('40200','40300','40400')  and T0.Number NOT IN (SELECT * FROM ##foliosPolizas)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask, T2.Segment_0
Having SUM(T1.Debit - T1.Credit) != 0







IF OBJECT_ID('Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa') IS NOT NULL  drop table Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa
 
-- DROP TABLE Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa

create table Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa
(AccountName nvarchar (70),
FECHA NUMERIC(19),
DESCRIP NVARCHAR(10),
SAP_BO NUMERIC(19,6)
)

insert into Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa
select AcctName,'202006' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueJUN20
UNION
select AcctName,'202007' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueJUL20
UNION
select AcctName,'202008' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueAGO20
UNION
select AcctName,'202009' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueSEP20
UNION
select AcctName,'202010' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueOCT20
UNION
select AcctName,'202011' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueNOV20
UNION
select AcctName,'202012' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueDIC20
UNION
select AcctName,'202101' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueENE20
UNION
select AcctName,'202102' as fech,fecha as Descrip,Credit AS SAB_BO from ##Revenuefebre20
UNION
select AcctName,'202103' as fech,fecha as Descrip,Credit AS SAB_BO from ##Revenuemarzo20
UNION
select AcctName,'202104' as fech,fecha as Descrip,Credit AS SAB_BO from ##Revenueabril20
UNION
select AcctName,'202105' as fech,fecha as Descrip,Credit AS SAB_BO from ##Revenuemayo20
UNION
select AcctName,'202106' as fech,fecha as Descrip,Credit AS SAB_BO from ##RevenueJUNIO21

update Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa set AccountName='ENVIRONMENT' where AccountName ='SALES - ENVIRONMENT (Department, Location)'
update Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa set AccountName='NUTRITION AND SKIN CARE' where AccountName ='SALES - NUTRITION AND SKIN CARE (Department, Location)'
update Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa set AccountName='REST AND RELAXATION' where AccountName ='SALES - REST AND RELAXATION (Department, Location)'

SELECT * FROM Sales_Dashboard.dbo.JUNISalesTrendbyCategoryusa

END
GO
