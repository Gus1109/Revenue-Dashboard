USE [Nikken_HQ]
GO
/****** Object:  StoredProcedure [dbo].[JUNIsalesrevenuebymonthuUsaCan]    Script Date: 28/06/2021 04:47:04 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[JUNIsalesrevenuebymonthuUsaCan] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
declare @fechaIni  as nvarchar(10), @fechafin as nvarchar(10)

SET @fechaIni = '2021-04-01'
SET @fechafin = '2021-04-30'

IF OBJECT_ID('tempdb..##foliosPolizasCan') IS NOT NULL  drop table  ##foliosPolizasCan

select	 distinct OJDT.Number
into ##foliosPolizasCan
from [Live_Nikken_CAD].[dbo].jdt1 left join [Live_Nikken_CAD].[dbo].oact on jdt1.Account = oact.AcctCode left join [Live_Nikken_CAD].[dbo].OJDT ON jdt1.TransId = OJDT.TransId
where year(jdt1.refDate) = year(@fechaIni) and jdt1.transType = '-3' and  Memo NOT LIKE '%'+CONVERT(CHAR(4),year(DATEADD(YEAR,-1,(@fechaIni))))+'%'

declare @fechaIniyearCanJun  as nvarchar(10), @fechafinyearCanJun as nvarchar(10)

SET @fechaIniyearCanJun= '2021-06-01'
SET @fechafinyearCanJun = '2021-06-30'

IF OBJECT_ID('tempdb..##yearCAnJun21') IS NOT NULL  drop table  ##yearCAnJun21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanJun) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnJun21
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanJun AND T0.RefDate <= @fechafinyearCanJun  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0




declare @fechaIniyearCanMay  as nvarchar(10), @fechafinyearCanMay as nvarchar(10)

SET @fechaIniyearCanMay= '2021-05-01'
SET @fechafinyearCanMay = '2021-05-31'

IF OBJECT_ID('tempdb..##yearCAnMay21') IS NOT NULL  drop table  ##yearCAnMay21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanMay) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnMay21
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanMay AND T0.RefDate <= @fechafinyearCanMay  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearCanAbri  as nvarchar(10), @fechafinyearCanAbri as nvarchar(10)

SET @fechaIniyearCanAbri= '2021-04-01'
SET @fechafinyearCanAbri = '2021-04-30'

IF OBJECT_ID('tempdb..##yearCAnAbri21') IS NOT NULL  drop table  ##yearCAnAbri21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanAbri) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnAbri21
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanAbri AND T0.RefDate <= @fechafinyearCanAbri  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearCanMar  as nvarchar(10), @fechafinyearCanMar as nvarchar(10)

SET @fechaIniyearCanMar= '2021-03-01'
SET @fechafinyearCanMar = '2021-03-31'

IF OBJECT_ID('tempdb..##yearCAnMar21') IS NOT NULL  drop table  ##yearCAnMar21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanMar) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnMar21
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanMar AND T0.RefDate <= @fechafinyearCanMar  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearCanFebr  as nvarchar(10), @fechafinyearCanFebr as nvarchar(10)

SET @fechaIniyearCanFebr= '2021-02-01'
SET @fechafinyearCanFebr = '2021-02-28'

IF OBJECT_ID('tempdb..##yearCAnFebr21') IS NOT NULL  drop table  ##yearCAnFebr21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanFebr) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnFebr21
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanFebr AND T0.RefDate <= @fechafinyearCanFebr  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearCanEne  as nvarchar(10), @fechafinyearCanEne as nvarchar(10)

SET @fechaIniyearCanEne= '2021-01-01'
SET @fechafinyearCanEne = '2021-01-31'

IF OBJECT_ID('tempdb..##yearCAnEne21') IS NOT NULL  drop table  ##yearCAnEne21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanEne) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnEne21
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanEne AND T0.RefDate <= @fechafinyearCanEne  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearCanDic20  as nvarchar(10), @fechafinyearCanDic20 as nvarchar(10)

SET @fechaIniyearCanDic20= '2020-12-01'
SET @fechafinyearCanDic20 = '2020-12-31'


IF OBJECT_ID('tempdb..##foliosPolizasCandic') IS NOT NULL  drop table  ##foliosPolizasCandic
select	 distinct OJDT.Number
into ##foliosPolizasCandic
from [Live_Nikken_CAD].[dbo].jdt1 left join [Live_Nikken_CAD].[dbo].oact on jdt1.Account = oact.AcctCode left join [Live_Nikken_CAD].[dbo].OJDT ON jdt1.TransId = OJDT.TransId
where year(jdt1.refDate) = year(@fechaIniyearCanDic20) and jdt1.transType = '-3' and  Memo NOT LIKE '%'+CONVERT(CHAR(4),year(DATEADD(YEAR,-1,(@fechaIniyearCanDic20))))+'%'


IF OBJECT_ID('tempdb..##yearCAnDic20') IS NOT NULL  drop table  ##yearCAnDic20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanDic20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnDic20
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanDic20 AND T0.RefDate <= @fechafinyearCanDic20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCandic)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearCanNov20  as nvarchar(10), @fechafinyearCanNov20 as nvarchar(10)

SET @fechaIniyearCanNov20= '2020-11-01'
SET @fechafinyearCanNov20 = '2020-11-30'

IF OBJECT_ID('tempdb..##yearCAnNov20') IS NOT NULL  drop table  ##yearCAnNov20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanNov20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnNov20
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanNov20 AND T0.RefDate <= @fechafinyearCanNov20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearCanOct20  as nvarchar(10), @fechafinyearCanOct20 as nvarchar(10)

SET @fechaIniyearCanOct20= '2020-10-01'
SET @fechafinyearCanOct20 = '2020-10-31'

IF OBJECT_ID('tempdb..##yearCAnOct20') IS NOT NULL  drop table  ##yearCAnOct20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanOct20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnOct20
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanOct20 AND T0.RefDate <= @fechafinyearCanOct20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearCanSep20  as nvarchar(10), @fechafinyearCanSep20 as nvarchar(10)

SET @fechaIniyearCanSep20= '2020-09-01'
SET @fechafinyearCanSep20 = '2020-09-30'

IF OBJECT_ID('tempdb..##yearCAnSep20') IS NOT NULL  drop table  ##yearCAnSep20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanSep20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnSep20
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanSep20 AND T0.RefDate <= @fechafinyearCanSep20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearCanAgo20  as nvarchar(10), @fechafinyearCanAgo20 as nvarchar(10)

SET @fechaIniyearCanAgo20= '2020-08-01'
SET @fechafinyearCanAgo20 = '2020-08-31'

IF OBJECT_ID('tempdb..##yearCAnAgo20') IS NOT NULL  drop table  ##yearCAnAgo20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanAgo20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnAgo20
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanAgo20 AND T0.RefDate <= @fechafinyearCanAgo20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearCanJul20  as nvarchar(10), @fechafinyearCanJul20 as nvarchar(10)

SET @fechaIniyearCanJul20= '2020-07-01'
SET @fechafinyearCanJul20 = '2020-07-31'

IF OBJECT_ID('tempdb..##yearCAnJul20') IS NOT NULL  drop table  ##yearCAnJul20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanJul20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnJul20
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanJul20 AND T0.RefDate <= @fechafinyearCanJul20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearCanJun20  as nvarchar(10), @fechafinyearCanJun20 as nvarchar(10)

SET @fechaIniyearCanJun20= '2020-06-01'
SET @fechafinyearCanJun20 = '2020-06-30'

IF OBJECT_ID('tempdb..##yearCAnJun20') IS NOT NULL  drop table  ##yearCAnJun20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_CAD].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearCanJun20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearCAnJun20
FROM [Live_Nikken_CAD].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_CAD].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_CAD].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearCanJun20 AND T0.RefDate <= @fechafinyearCanJun20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasCan)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



/********************************/
--union de tablas de canada


/*******************************/

declare @fechaIniusa  as nvarchar(10), @fechafinusa as nvarchar(10)

SET @fechaIniusa = '2021-04-01'
SET @fechafinusa = '2021-04-30'

IF OBJECT_ID('tempdb..##foliosPolizasUsa') IS NOT NULL  drop table  ##foliosPolizasUsa

select	 distinct OJDT.Number
into ##foliosPolizasUsa
from [Live_Nikken_INC].[dbo].jdt1 left join [Live_Nikken_INC].[dbo].oact on jdt1.Account = oact.AcctCode left join [Live_Nikken_INC].[dbo].OJDT ON jdt1.TransId = OJDT.TransId
where year(jdt1.refDate) = year(@fechaIniusa) and jdt1.transType = '-3' and  Memo NOT LIKE '%'+CONVERT(CHAR(4),year(DATEADD(YEAR,-1,(@fechaIniusa))))+'%'

declare @fechaIniyearUsaJun  as nvarchar(10), @fechafinyearUsaJun as nvarchar(10)

SET @fechaIniyearUsaJun= '2021-06-01'
SET @fechafinyearUsaJun = '2021-06-30'

IF OBJECT_ID('tempdb..##yearUsaJun21') IS NOT NULL  drop table  ##yearUsaJun21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaJun) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaJun21
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaJun AND T0.RefDate <= @fechafinyearUsaJun  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0




declare @fechaIniyearUsaMay  as nvarchar(10), @fechafinyearUsaMay as nvarchar(10)

SET @fechaIniyearUsaMay= '2021-05-01'
SET @fechafinyearUsaMay = '2021-05-31'

IF OBJECT_ID('tempdb..##yearUsaMay21') IS NOT NULL  drop table  ##yearUsaMay21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaMay) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaMay21
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaMay AND T0.RefDate <= @fechafinyearUsaMay  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearUsaAbri  as nvarchar(10), @fechafinyearUsaAbri as nvarchar(10)

SET @fechaIniyearUsaAbri= '2021-04-01'
SET @fechafinyearUsaAbri = '2021-04-30'

IF OBJECT_ID('tempdb..##yearUsaAbri21') IS NOT NULL  drop table  ##yearUsaAbri21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaAbri) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaAbri21
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaAbri AND T0.RefDate <= @fechafinyearUsaAbri  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearUsaMar  as nvarchar(10), @fechafinyearUsaMar as nvarchar(10)

SET @fechaIniyearUsaMar= '2021-03-01'
SET @fechafinyearUsaMar = '2021-03-31'

IF OBJECT_ID('tempdb..##yearUsaMar21') IS NOT NULL  drop table  ##yearUsaMar21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaMar) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaMar21
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaMar AND T0.RefDate <= @fechafinyearUsaMar  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearUsaFebr  as nvarchar(10), @fechafinyearUsaFebr as nvarchar(10)

SET @fechaIniyearUsaFebr= '2021-02-01'
SET @fechafinyearUsaFebr = '2021-02-28'

IF OBJECT_ID('tempdb..##yearUsaFebr21') IS NOT NULL  drop table  ##yearUsaFebr21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaFebr) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaFebr21
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaFebr AND T0.RefDate <= @fechafinyearUsaFebr  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearUsaEne  as nvarchar(10), @fechafinyearUsaEne as nvarchar(10)

SET @fechaIniyearUsaEne= '2021-01-01'
SET @fechafinyearUsaEne = '2021-01-31'

IF OBJECT_ID('tempdb..##yearUsaEne21') IS NOT NULL  drop table  ##yearUsaEne21

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaEne) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaEne21
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaEne AND T0.RefDate <= @fechafinyearUsaEne  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearUsaDic20  as nvarchar(10), @fechafinyearUsaDic20 as nvarchar(10)

SET @fechaIniyearUsaDic20= '2020-12-01'
SET @fechafinyearUsaDic20 = '2020-12-31'


IF OBJECT_ID('tempdb..##foliosPolizasUsadic') IS NOT NULL  drop table  ##foliosPolizasUsadic
select	 distinct OJDT.Number
into ##foliosPolizasUsadic
from [Live_Nikken_INC].[dbo].jdt1 left join [Live_Nikken_INC].[dbo].oact on jdt1.Account = oact.AcctCode left join [Live_Nikken_INC].[dbo].OJDT ON jdt1.TransId = OJDT.TransId
where year(jdt1.refDate) = year(@fechaIniyearUsaDic20) and jdt1.transType = '-3' and  Memo NOT LIKE '%'+CONVERT(CHAR(4),year(DATEADD(YEAR,-1,(@fechaIniyearUsaDic20))))+'%'


IF OBJECT_ID('tempdb..##yearUsaDic20') IS NOT NULL  drop table  ##yearUsaDic20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaDic20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaDic20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaDic20 AND T0.RefDate <= @fechafinyearUsaDic20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsadic)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearUsaNov20  as nvarchar(10), @fechafinyearUsaNov20 as nvarchar(10)

SET @fechaIniyearUsaNov20= '2020-11-01'
SET @fechafinyearUsaNov20 = '2020-11-30'

IF OBJECT_ID('tempdb..##yearUsaNov20') IS NOT NULL  drop table  ##yearUsaNov20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaNov20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaNov20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaNov20 AND T0.RefDate <= @fechafinyearUsaNov20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearUsaOct20  as nvarchar(10), @fechafinyearUsaOct20 as nvarchar(10)

SET @fechaIniyearUsaOct20= '2020-10-01'
SET @fechafinyearUsaOct20 = '2020-10-31'

IF OBJECT_ID('tempdb..##yearUsaOct20') IS NOT NULL  drop table  ##yearUsaOct20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaOct20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaOct20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaOct20 AND T0.RefDate <= @fechafinyearUsaOct20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0



declare @fechaIniyearUsaSep20  as nvarchar(10), @fechafinyearUsaSep20 as nvarchar(10)

SET @fechaIniyearUsaSep20= '2020-09-01'
SET @fechafinyearUsaSep20 = '2020-09-30'

IF OBJECT_ID('tempdb..##yearUsaSep20') IS NOT NULL  drop table  ##yearUsaSep20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaSep20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaSep20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaSep20 AND T0.RefDate <= @fechafinyearUsaSep20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearUsaAgo20  as nvarchar(10), @fechafinyearUsaAgo20 as nvarchar(10)

SET @fechaIniyearUsaAgo20= '2020-08-01'
SET @fechafinyearUsaAgo20 = '2020-08-31'

IF OBJECT_ID('tempdb..##yearUsaAgo20') IS NOT NULL  drop table  ##yearUsaAgo20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaAgo20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaAgo20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaAgo20 AND T0.RefDate <= @fechafinyearUsaAgo20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearUsaJul20  as nvarchar(10), @fechafinyearUsaJul20 as nvarchar(10)

SET @fechaIniyearUsaJul20= '2020-07-01'
SET @fechafinyearUsaJul20 = '2020-07-31'

IF OBJECT_ID('tempdb..##yearUsaJul20') IS NOT NULL  drop table  ##yearUsaJul20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaJul20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaJul20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaJul20 AND T0.RefDate <= @fechafinyearUsaJul20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


declare @fechaIniyearUsaJun20  as nvarchar(10), @fechafinyearUsaJun20 as nvarchar(10)

SET @fechaIniyearUsaJun20= '2020-06-01'
SET @fechafinyearUsaJun20 = '2020-06-30'

IF OBJECT_ID('tempdb..##yearUsaJun20') IS NOT NULL  drop table  ##yearUsaJun20

SELECT T2.[AcctName], t2.Groupmask as 'acc type',
 Isnull((SELECT SUM(T3.Debit - T3.Credit) FROM [Live_Nikken_INC].[dbo].OJDT T2 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T3 WITH(NOLOCK) ON T2.TransId = T3.TransId
WHERE DateDiff(dd,T2.RefDate,@fechaIniyearUsaJun20) > 0 AND T3.Account like T1.Account
GROUP BY T3.Account),0) 'Opening balance',
SUM(T1.Debit) 'Debit', SUM(T1.Credit) 'Credit',
SUM(T1.Credit - T1.Debit) AS 'Balance',T2.FatherNum
into ##yearUsaJun20
FROM [Live_Nikken_INC].[dbo].OJDT T0 WITH(NOLOCK)
INNER JOIN [Live_Nikken_INC].[dbo].JDT1 T1 WITH(NOLOCK) ON T0.TransId = T1.TransId
INNER JOIN [Live_Nikken_INC].[dbo].OACT T2 WITH(NOLOCK) ON T1.Account = T2.AcctCode
WHERE T0.RefDate >= @fechaIniyearUsaJun20 AND T0.RefDate <= @fechafinyearUsaJun20  and T2.FatherNum in('4000','4200','4300','4400','4500','4600','4700') 
and T0.Number NOT IN (SELECT * FROM ##foliosPolizasUsa)
GROUP BY   T1.Account,T2.[AcctName], t2.Groupmask,T2.FatherNum
Having SUM(T1.Debit - T1.Credit) != 0


IF OBJECT_ID('Sales_Dashboard.dbo.JUNITotalRevenuebymonth') IS NOT NULL  drop table  Sales_Dashboard.dbo.JUNITotalRevenuebymonth


--DROP TABLE Sales_Dashboard.dbo.TotalRevenuebymonth
 create table Sales_Dashboard.dbo.JUNITotalRevenuebymonth
(COUNTRY nvarchar(20),
SAP_BO NUMERIC (19,6),
FECHA numeric(19),
descrip nvarchar (100)
)



/********************************/
--union de tablas de canada
INSERT INTO Sales_Dashboard.dbo.JUNITotalRevenuebymonth

select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202006' AS FECH,'2020-06'as Descrip from ##yearUsaJun20  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202007' AS FECH,'2020-07'as Descrip from ##yearUsaJul20  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202008' AS FECH,'2020-08'as Descrip from ##yearUsaAgo20  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202009' AS FECH,'2020-09'as Descrip from ##yearUsaSep20  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202010' AS FECH,'2020-10'as Descrip from ##yearUsaOct20  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202011' AS FECH,'2020-11'as Descrip from ##yearUsaNov20  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202012' AS FECH,'2020-12'as Descrip from ##yearUsaDic20  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202101' AS FECH,'2021-01'as Descrip from ##yearUsaEne21  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202102' AS FECH,'2021-02'as Descrip from ##yearUsaFebr21  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202105' AS FECH,'2021-05'as Descrip from ##yearUsaMay21  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202104' AS FECH,'2021-04'as Descrip from ##yearUsaAbri21  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202103' AS FECH,'2021-03'as Descrip from ##yearUsaMar21  group by [acc type]
union
select 'Nikken Inc.' AS COUNTRY ,sum(Balance) as SP_BO,'202106' AS FECH,'2021-06'as Descrip from ##yearUsaJun21  group by [acc type]




union

select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202006' AS FECH,'2020-06'as Descrip from ##yearCAnJun20  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202007' AS FECH,'2020-07'as Descrip from ##yearCAnJul20  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202008' AS FECH,'2020-08'as Descrip from ##yearCAnAgo20  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202009' AS FECH,'2020-09'as Descrip from ##yearCAnSep20  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202010' AS FECH,'2020-10'as Descrip from ##yearCAnOct20  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202011' AS FECH,'2020-11'as Descrip from ##yearCAnNov20  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202012' AS FECH,'2020-12'as Descrip from ##yearCAnDic20  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202101' AS FECH,'2021-01'as Descrip from ##yearCAnEne21  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202102' AS FECH,'2021-02'as Descrip from ##yearCAnFebr21  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202105' AS FECH,'2021-05'as Descrip from ##yearCAnMay21  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202104' AS FECH,'2021-04'as Descrip from ##yearCAnAbri21  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202103' AS FECH,'2021-03'as Descrip from ##yearCAnMar21  group by [acc type]
union
select 'Nikken Canada' AS COUNTRY ,sum(Balance) as SP_BO,'202106' AS FECH,'2021-06'as Descrip from ##yearCAnJun21  group by [acc type]


SELECT * FROM Sales_Dashboard.dbo.JUNITotalRevenuebymonth
/*******************************/

END
