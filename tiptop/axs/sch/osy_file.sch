/*
================================================================================
檔案代號:osy_file
檔案名稱:销售分析系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table osy_file
(
osyslip     varchar2(5) NOT NULL,    /*单别                                   */
                                     /*單別                                   */
osydesc     varchar2(80),            /*单据名称                               */
                                     /*單據名稱                               */
osyauno     varchar2(1),             /*自动编号否                             */
                                     /*自動編號否 (Y/N)                       */
osymxno     varchar2(20),            /*已用单号                               */
                                     /*已用單號                               */
osytype     varchar2(2),             /*单据性质                               */
                                     /*單據性質                               */
                                     /*  1.訂單                               */
                                     /*  2.出貨                               */
osydmy1     varchar2(1),             /*No Use                                 */
                                     /*編號方式1.流水號 2.年月                */
osyud01     varchar2(255),           /*自订字段                               */
osyud02     varchar2(40),            /*自订字段                               */
osyud03     varchar2(40),            /*自订字段                               */
osyud04     varchar2(40),            /*自订字段                               */
osyud05     varchar2(40),            /*自订字段                               */
osyud06     varchar2(255),           /*自订字段                               */
osyud07     number(15,3),            /*自订字段                               */
osyud08     number(15,3),            /*自订字段                               */
osyud09     number(15,3),            /*自订字段                               */
osyud10     number(10),              /*自订字段                               */
osyud11     number(10),              /*自订字段                               */
osyud12     number(10),              /*自订字段                               */
osyud13     date,                    /*自订字段                               */
osyud14     date,                    /*自订字段                               */
osyud15     date                     /*自订字段                               */
);

alter table osy_file add  constraint osy_pk primary key  (osyslip) enable validate;
grant select on osy_file to tiptopgp;
grant update on osy_file to tiptopgp;
grant delete on osy_file to tiptopgp;
grant insert on osy_file to tiptopgp;
grant index on osy_file to public;
grant select on osy_file to ods;
