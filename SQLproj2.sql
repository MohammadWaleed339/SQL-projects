# using the layoffs database
use layoffs;

# selecting rows where location that starts with P and contains 4 words
select * 
from layoffs2
where location like "P___";


select Max(total_laid_off) MaxTLF
from layoffs2;

select funds_raised_millions as frm, country
from layoffs2
group by country;

select percentage_laid_off, country, company
from layoffs2
where percentage_laid_off = 1;

select percentage_laid_off, country, company, `date`
from layoffs2
where percentage_laid_off = 0
order by `date` desc;

update layoffs2
set percentage_laid_off = percentage_laid_off  * 100 
where percentage_laid_off >= 0 or percentage_laid_off <= 1;

select *
from layoffs2
where percentage_laid_off = 100;

select company, sum(total_laid_off) as comp_tlf
from layoffs2
group by company
order by comp_tlf desc;

select min(date), max(date)
from layoffs2;

select total_laid_off , industry
from layoffs2
group by industry;

select sum(total_laid_off), year(`date`)
from layoffs2
group by year(`date`)
order by 1 desc;

select sum(total_laid_off), stage
from layoffs2
where stage is not null
group by stage
order by 2 desc;

select substring(`date`, 1,7) as `month`, sum(total_laid_off) as sum_tlo
from layoffs2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc;

with rolling_total as
(
select substring(`date`, 1,7) as `month`, sum(total_laid_off) as sum_tlo
from layoffs2
where substring(`date`, 1,7) is not null
group by `month`
order by 1 asc
)
select `month`, sum_tlo, sum(sum_tlo) OVER(order by `month`) as roll_total
from rolling_total;

select company, sum(total_laid_off) as sum_tlo
from layoffs2
group by company
order by sum_tlo desc;

select company, year(`date`)
from layoffs2
group by year(`date`), company
order by 1  desc;

with company_year (company, years, sum_tlo) as
 (
	select company, year(`date`), sum(total_laid_off)
    from layoffs2
	group by company, year(`date`)
), company_year_rank as 
(
	select *, Dense_rank() over(partition by years order by sum_tlo desc) as ranking 
    from company_year
    where years is not null
)
select * from company_year_rank
where ranking <= 5;

















