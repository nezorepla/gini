USE [DecisionTree]
GO

/****** Object:  Table [dbo].[person_fact]    Script Date: 05/04/2015 22:44:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[person_fact](
	[SICIL] [nvarchar](255) NULL,
	[MANAGERSICIL] [nvarchar](255) NULL,
	[DESCRIPTION] [nvarchar](255) NULL,
	[IBTECH_MAIL] [float] NULL,
	[COCUK] [float] NULL,
	[NM] [nvarchar](255) NULL,
	[SCND_NM] [nvarchar](255) NULL,
	[SURNM] [nvarchar](255) NULL,
	[BRTH_DT] [datetime] NULL,
	[EMP_F] [float] NULL,
	[MRTL_ST_CODE] [nvarchar](255) NULL,
	[EDUC_LVL_CODE] [float] NULL,
	[GND_CODE] [nvarchar](255) NULL,
	[EMPL_DT] [datetime] NULL,
	[EMP_TP] [nvarchar](255) NULL,
	[BRTH_PL] [nvarchar](255) NULL,
	[EMPE_ST] [nvarchar](255) NULL,
	[TITLE] [float] NULL,
	[YAS] [float] NULL,
	[ISTANBUL_IKAMET_FLG] [float] NULL,
	[SC] [nvarchar](255) NULL,
	[TELBANKING] [nvarchar](255) NULL,
	[UMRANIYE_FLG] [float] NULL
) ON [PRIMARY]

GO

USE [DecisionTree]
GO

/****** Object:  Table [dbo].[PERSON_DIM_RESPONSE]    Script Date: 05/04/2015 22:40:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PERSON_DIM_RESPONSE](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QID] [int] NOT NULL,
	[PERSON] [varchar](10) NOT NULL,
	[RSP] [float] NULL,
	[UID] [int] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [DecisionTree]
GO

/****** Object:  Table [dbo].[PERSON_DIM_QUESTION]    Script Date: 05/04/2015 22:40:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[PERSON_DIM_QUESTION](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[QID] [int] NOT NULL,
	[Q] [varchar](150) NOT NULL,
	[TID] [tinyint] NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [DecisionTree]
GO

/****** Object:  Table [dbo].[FB_TBL_SESSION]    Script Date: 05/04/2015 22:40:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[FB_TBL_SESSION](
	[I] [int] IDENTITY(1,1) NOT NULL,
	[S] [bigint] NOT NULL,
	[U] [varchar](15) NOT NULL,
	[D] [tinyint] NOT NULL,
	[T] [datetime] NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

USE [DecisionTree]
GO

/****** Object:  Table [dbo].[FB_TBL_ANSWERS]    Script Date: 05/04/2015 22:40:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FB_TBL_ANSWERS](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[SID] [bigint] NULL,
	[QID] [int] NULL,
	[RSP] [float] NULL
) ON [PRIMARY]

GO
USE [DecisionTree]
GO

/****** Object:  UserDefinedFunction [dbo].[log2]    Script Date: 05/04/2015 22:42:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[log2]
(
@v float
)
RETURNS float
AS
BEGIN 
	-- Return the result of the function
	RETURN  log10(@v) / log10(2)

END

GO


USE [DecisionTree]
GO

/****** Object:  StoredProcedure [dbo].[FB_SP_ENTROPY]    Script Date: 05/04/2015 22:42:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[FB_SP_ENTROPY]( @S VARCHAR(20)) AS 

 /* declare @S BIGINT=6593212564815;

SELECT * FROM dbo.FB_TBL_SESSION

FB_SP_ENTROPY 1580147697832

 SELECT  R1.QID,CONVERT(FLOAT,COUNT(*)) B
    FROM PERSON_DIM_RESPONSE R1 LEFT JOIN (SELECT * FROM FB_TBL_ANSWERS  WHERE SID =@S AND RSP<>0) R2 
    ON R1.QID=R2.QID
WHERE (R2.RSP IS NULL OR R1.RSP<=R2.RSP)
AND R1.QID not in (select QID from FB_TBL_ANSWERS  WHERE SID =@S AND RSP<>0 ) 
GROUP BY R1.QID
*/
 
DECLARE @T TABLE(SICIL VARCHAR(15),NM VARCHAR(150),SURNM VARCHAR(150))

INSERT INTO @T(SICIL,NM,SURNM)
EXEC FB_SP_ListItem  @S;


 DECLARE @A FLOAT; 
 SELECT @A=COUNT(distinct PERSON) 
 FROM PERSON_DIM_RESPONSE 
 WHERE QID <> 0
-- and QID not in (select QID from FB_TBL_ANSWERS  WHERE SID =@S AND RSP<>0  );   
 AND PERSON IN(SELECT SICIL FROM @T)
 
   SELECT TOP 1 QID,B,@A A, CASE WHEN @A-B=0 THEN 0 ELSE   -((B/@A)*dbo.log2(B/@A))  -(((@A-B)/@A )*dbo.log2( (@A-B)/@A )) END E
        FROM( 
 SELECT  R1.QID,CONVERT(FLOAT,COUNT(*)) B
    FROM PERSON_DIM_RESPONSE R1 LEFT JOIN (SELECT * FROM FB_TBL_ANSWERS  WHERE SID =@S) R2 
    ON R1.QID=R2.QID
WHERE /* (R2.RSP IS NULL OR R1.RSP<=R2.RSP)*/
  R1.QID <> 0
AND R1.QID not in (select QID from FB_TBL_ANSWERS  WHERE SID =@S  ) 
AND R1.PERSON  IN(SELECT SICIL FROM @T)
GROUP BY R1.QID
  ) AS X  GROUP BY QID,B
  ORDER BY CASE WHEN @A-B=0 THEN 0 ELSE   -((B/@A)*dbo.log2(B/@A))  -(((@A-B)/@A )*dbo.log2( (@A-B)/@A )) END DESC, QID ASC;
 
 
 /*
 
 
 /*
1	1	Bu kiþi erkek mi?	NULL
2	2	Çift ismi mi var?	NULL
3	3	Evli mi?	NULL
4	4	Çocuðu var mý?	NULL
5	5	Ýki veya daha fazla çocuðu mu var?	NULL
6	6	30 yaþýndan büyük mü?	NULL
7	7	bu kiþi müdür ya da üzeri bir pozisyonda mý çalýþmaktadýr?	NULL
8	8	Gözlük kullanýr mý sürekli olarak?	NULL
9	9	Bu kiþi Müdürün de müdürü bir görevde midir?	NULL
*/

 DECLARE @A FLOAT; 
 SELECT @A=COUNT(distinct PERSON) 
 FROM PERSON_DIM_RESPONSE 
 WHERE QID <> 0
 
   SELECT  QID,B,@A A, CASE WHEN @A-B=0 THEN 0 ELSE   -((B/@A)*dbo.log2(B/@A))  -(((@A-B)/@A )*dbo.log2( (@A-B)/@A )) END E
        FROM( 
 SELECT R1.QID,CONVERT(FLOAT,COUNT(*)) B
    FROM PERSON_DIM_RESPONSE R1 LEFT JOIN (SELECT * FROM FB_TBL_ANSWERS  WHERE SID =1580147697832) R2 
    ON R1.QID=R2.QID
WHERE  R1.QID <> 0
AND R1.QID not in (select QID from FB_TBL_ANSWERS  WHERE SID =1580147697832  ) 
--AND R1.PERSON  IN(SELECT SICIL FROM @T)
GROUP BY R1.QID
  ) AS X  GROUP BY QID,B
  ORDER BY CASE WHEN @A-B=0 THEN 0 ELSE   -((B/@A)*dbo.log2(B/@A))  -(((@A-B)/@A )*dbo.log2( (@A-B)/@A )) END DESC, QID ASC;
 
 
 */
GO

USE [DecisionTree]
GO

/****** Object:  StoredProcedure [dbo].[FB_SP_SA]    Script Date: 05/04/2015 22:43:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROC [dbo].[FB_SP_SA]( @S VARCHAR(20), @U VARCHAR(20)) AS 

/*
CREATE TABLE FB_TBL_SESSION (
I INT NOT NULL IDENTITY(1,1),
S BIGINT NOT NULL,
U VARCHAR(15) NOT NULL,
D TINYINT NOT NULL,
T DATETIME NOT NULL)
*/
INSERT INTO FB_TBL_SESSION(S,U,D,T)
VALUES (@S,@U,0,GETDATE())

GO

USE [DecisionTree]
GO

/****** Object:  StoredProcedure [dbo].[FB_SP_ANSWERS]    Script Date: 05/04/2015 22:43:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[FB_SP_ANSWERS] (@S BIGINT, @Q INT, @R FLOAT) AS


/*
CREATE TABLE FB_TBL_ANSWERS(
ID INT IDENTITY(1,1),
SID BIGINT,
QID INT,
RSP FLOAT
)

select * from FB_TBL_ANSWERS

*/

INSERT INTO FB_TBL_ANSWERS (SID,QID,RSP)
VALUES (@S,@Q,@R)
GO

USE [DecisionTree]
GO

/****** Object:  StoredProcedure [dbo].[FB_SP_ListItem]    Script Date: 05/04/2015 22:44:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[FB_SP_ListItem]( @S VARCHAR(20)) AS 
  
 
--  declare @S BIGINT=6658998996106;
 
/*
SELECT * FROM dbo.person_fact 
where SICIL in(
 
 SELECT  DISTINCT PERSON
    FROM PERSON_DIM_RESPONSE R1 LEFT JOIN (SELECT * FROM FB_TBL_ANSWERS  WHERE SID =@S AND RSP<>0) R2 
    ON R1.QID=R2.QID
    left JOIN PERSON_DIM_QUESTION Q ON R1.QID=Q.QID
    WHERE R1.QID <> 0
   AND   (R2.RSP IS NULL OR R1.RSP<=R2.RSP)
 )
 and SICIL not in (
 
 SELECT DISTINCT PERSON
    FROM PERSON_DIM_RESPONSE R1 LEFT JOIN (SELECT * FROM FB_TBL_ANSWERS  WHERE SID =@S AND RSP<>0) R2 
    ON R1.QID=R2.QID
    left JOIN PERSON_DIM_QUESTION Q ON R1.QID=Q.QID
    WHERE R1.QID <> 0
   AND   ( R1.RSP>R2.RSP)
 )
 */
 

DECLARE @WS VARCHAR(MAX);
SET @WS='SELECT SICIL,NM,SURNM FROM dbo.person_fact  WHERE SICIL<>''A00000'' ';

SELECT  @WS= @WS + CASE WHEN RSP>0.5 THEN 
' AND EXISTS (SELECT 1 FROM PERSON_DIM_RESPONSE WHERE QID='+CONVERT(VARCHAR(10),QID)+' AND RSP>='+CONVERT(VARCHAR(10),RSP)+' AND PERSON = SICIL)'
ELSE
' AND NOT EXISTS (SELECT 1 FROM PERSON_DIM_RESPONSE WHERE QID='+CONVERT(VARCHAR(10),QID)+' AND RSP>='+CONVERT(VARCHAR(10),RSP)+' AND PERSON = SICIL)'
END
--QID,RSP  
 FROM FB_TBL_ANSWERS  --A LEFT JOIN 
 WHERE SID =@S AND RSP<>0 order by ID asc;
 
 
 
 EXEC(@WS);
 
-- exec FB_SP_ListItem 0907360930457
GO

