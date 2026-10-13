/*
================================================================================
檔案代號:mpz_file
檔案名稱:主生产排程(MPS)系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table mpz_file
(
mpz00       varchar2(1) NOT NULL,    /*KEY, VALUE(0), 隐藏字段                */
                                     /*KEY, VALUE(0), 隱藏欄位                */
mpz_v       varchar2(10),            /*当前MPS 版本                           */
                                     /*目前MPS 版本                           */
mpz02       varchar2(1),             /*使用时距方式                           */
                                     /*使用時距方式                           */
                                     /*1:依時距代號 2.天 3.週 4.旬 5.月       */
mpz03       varchar2(10),            /*时距编号                               */
                                     /*時距代號                               */
mpz04       varchar2(19),            /*当前版本释放日期时间                   */
                                     /*目前版本釋放日期時間                   */
mpz05       varchar2(2),             /*产能负荷计算时缺省使用的每             */
mpzuser     varchar2(10),            /*资料所有者                             */
mpzgrup     varchar2(10),            /*资料所有群                             */
mpzmodu     varchar2(10),            /*资料更改者                             */
mpzdate     date,                    /*最近更改日                             */
mpzoriu     varchar2(10),            /*资料建立者                             */
mpzorig     varchar2(10),            /*资料建立部门                           */
mpzud01     varchar2(255),           /*自订字段                               */
mpzud02     varchar2(40),            /*自订字段                               */
mpzud03     varchar2(40),            /*自订字段                               */
mpzud04     varchar2(40),            /*自订字段                               */
mpzud05     varchar2(40),            /*自订字段                               */
mpzud06     varchar2(255),           /*自订字段                               */
mpzud07     number(15,3),            /*自订字段                               */
mpzud08     number(15,3),            /*自订字段                               */
mpzud09     number(15,3),            /*自订字段                               */
mpzud10     number(10),              /*自订字段                               */
mpzud11     number(10),              /*自订字段                               */
mpzud12     number(10),              /*自订字段                               */
mpzud13     date,                    /*自订字段                               */
mpzud14     date,                    /*自订字段                               */
mpzud15     date                     /*自订字段                               */
);

alter table mpz_file add  constraint mpz_pk primary key  (mpz00) enable validate;
grant select on mpz_file to tiptopgp;
grant update on mpz_file to tiptopgp;
grant delete on mpz_file to tiptopgp;
grant insert on mpz_file to tiptopgp;
grant index on mpz_file to public;
grant select on mpz_file to ods;
