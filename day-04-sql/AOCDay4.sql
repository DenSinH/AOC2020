-- setup environment
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'AOC')
BEGIN
	CREATE DATABASE [AOC]
END

USE [AOC]

DROP TABLE IF EXISTS #aoc
CREATE TABLE #aoc (
	passport NVARCHAR(MAX)
)

-- read file
BULK INSERT #aoc
FROM 'D:\Data\AOC2020\day-04-sql\input.txt'
WITH
(
	ROWTERMINATOR = '\n\n'
)

-- remove intermittent enters
UPDATE #aoc
SET passport = REPLACE(REPLACE(passport, CHAR(13), ' '), CHAR(10), '')

DROP TABLE IF EXISTS #Valid

SELECT * INTO #Valid FROM #aoc WHERE (
		([passport] LIKE '%byr:%')
	AND ([passport] LIKE '%iyr:%')
	AND ([passport] LIKE '%eyr:%')
	AND ([passport] LIKE '%hgt:%')
	AND ([passport] LIKE '%hcl:%')
	AND ([passport] LIKE '%ecl:%')
	AND ([passport] LIKE '%pid:%')
)
SELECT 'PART 1 ', COUNT([passport]) FROM [#Valid]


SELECT 'PART 2 ', COUNT([passport]) FROM [#Valid] WHERE (
		CAST(SUBSTRING([passport], CHARINDEX('byr:', [passport]) + 4, 4) AS INT) >= 1920
	AND CAST(SUBSTRING([passport], CHARINDEX('byr:', [passport]) + 4, 4) AS INT) <= 2020
	AND CAST(SUBSTRING([passport], CHARINDEX('iyr:', [passport]) + 4, 4) AS INT) >= 2010
	AND CAST(SUBSTRING([passport], CHARINDEX('iyr:', [passport]) + 4, 4) AS INT) <= 2020
	AND CAST(SUBSTRING([passport], CHARINDEX('eyr:', [passport]) + 4, 4) AS INT) >= 2020
	AND CAST(SUBSTRING([passport], CHARINDEX('eyr:', [passport]) + 4, 4) AS INT) <= 2030
	AND ((([passport] LIKE '%hgt:___cm%') AND (
					CAST(SUBSTRING([passport], CHARINDEX('hgt:', [passport]) + 4, 3) AS INT) >= 150
				AND CAST(SUBSTRING([passport], CHARINDEX('hgt:', [passport]) + 4, 3) AS INT) <= 193
		)) OR (([passport] LIKE '%hgt:__in%') AND (
					CAST(SUBSTRING([passport], CHARINDEX('hgt:', [passport]) + 4, 2) AS INT) >= 59
				AND CAST(SUBSTRING([passport], CHARINDEX('hgt:', [passport]) + 4, 2) AS INT) <= 76
		))
	)
	AND (
		SUBSTRING([passport], CHARINDEX('hcl:', [passport]) + 4, 8) LIKE '#[0123456789abcdef][0123456789abcdef][0123456789abcdef][0123456789abcdef][0123456789abcdef][0123456789abcdef] %'
		OR (
			LEN(SUBSTRING([passport], CHARINDEX('hcl:', [passport]) + 4, 8)) = 7
			AND SUBSTRING([passport], CHARINDEX('hcl:', [passport]) + 4, 8) LIKE '#[0123456789abcdef][0123456789abcdef][0123456789abcdef][0123456789abcdef][0123456789abcdef][0123456789abcdef]'
		)
	)
	-- 3 chars (end of string) or 3 + space (need a field to follow)
	AND SUBSTRING([passport], CHARINDEX('ecl:', [passport]) + 4, 4) IN ('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth', 'amb ', 'blu ', 'brn ', 'gry ', 'grn ', 'hzl ', 'oth ')
	AND (
		SUBSTRING([passport], CHARINDEX('pid:', [passport]) + 4, LEN([passport])) LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9] %'  -- next field
		OR (
			-- end of string
			LEN(SUBSTRING([passport], CHARINDEX('pid:', [passport]) + 4, LEN([passport]))) = 9
			AND SUBSTRING([passport], CHARINDEX('pid:', [passport]) + 4, LEN([passport])) LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		)
	)
)

;
DROP TABLE #aoc