
#first create the backup table.
CREATE TABLE layoffs_backup
	LIKE layoffs;
    
SELECT * FROM layoffs;

#Try to identify duplicates
SELECT *, 
ROW_NUMBER() OVER(
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
				stage, country, funds_raised_millions) AS row_num 
FROM layoffs ;
    

#since in mysql we cannot update or delete data using cte (in ms server we can), we will
#be using another duplicate table to do so
#create table using layoffs>copy to clipboard>create statement
CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#blank table named layoffs2 has been created

INSERT INTO layoffs2 
		SELECT *, 
	ROW_NUMBER() OVER(
	PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, 
				stage, country, funds_raised_millions) AS row_num 
	FROM layoffs;

SELECT * FROM layoffs2;

#now we print all the duplicates 
SELECT * FROM layoffs2
	WHERE row_num > 1;

#delete those 
DELETE 
FROM layoffs2
	WHERE 	row_num > 1;
    
    
#standardising data
#removing any space around data in cell
SELECT company, TRIM(company)
FROM layoffs2;

SELECT DISTINCT industry
	FROM layoffs2
    ORDER BY 1; #orders data alphabetically
    
#show the column names to be changed
SELECT 	DISTINCT industry
FROM layoffs2
WHERE industry LIKE 'Crypto%';

#change name to crypto only
UPDATE layoffs2
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

SELECT 	DISTINCT country
FROM layoffs2
order by 1;
#country has some problem

UPDATE layoffs2 
SET country = "United States"
WHERE country  LIKE 'United States_';
#Or we could use this

UPDATE layoffs2 
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE;

#now it is fixed
SELECT 	DISTINCT country
FROM layoffs2
order by 1;

#change column to date as YYYY/MM/DD
SELECT date
FROM layoffS2;

SELECT `date`,
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffS2;

UPDATE layoffs2
SET date = STR_TO_DATE(`date`,'%m/%d/%Y');


#see the date table is still str now, we will change it into date column
ALTER TABLE layoffs2
MODIFY COLUMNS `date` DATE ;


#populate the missing values if we can
SELECT *
FROM layoffs2
 WHERE industry IS NULL
 OR industry = '';
   
SELECT * 
FROM layoffs2
WHERE company = "Juul";

SELECT *
FROM layoffs2
WHERE industry = ''
OR  industry IS NULL;   
   
 
UPDATE  layoffs2 
SET industry = 'Consumer'
WHERE company = 'Juul' ; 
   
#delting rows that have null value for total laid off and percentage laid off

DELETE 
FROM layoffs2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;


ALTER TABLE layoffs2
DROP COLUMN row_num;


# all four points are done.alter
SELECT * 
FROM layoffs2