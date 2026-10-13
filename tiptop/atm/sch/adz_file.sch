/*
================================================================================
檔案代號:adz_file
檔案名稱:分销系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adz_file
(
adzslip     varchar2(5) NOT NULL,    /*单别                                   */
adzdesc     varchar2(80),            /*单据名称                               */
adzauno     varchar2(1),             /*自动编号否                             */
adzconf     varchar2(1),             /*自动审核                               */
adzprnt     varchar2(1),             /*立即打印否                             */
adzdmy6     varchar2(1),             /*1.依流水号                             */
adztype     varchar2(2),             /*单据性质                               */
adz11       varchar2(1),             /*是否影响呆滞日期                       */
adzapr      varchar2(1),             /*是否签核                               */
adzsign     varchar2(4)              /*签核等级                               */
);

alter table adz_file add  constraint adz_pk primary key  (adzslip) enable validate;
grant select on adz_file to tiptopgp;
grant update on adz_file to tiptopgp;
grant delete on adz_file to tiptopgp;
grant insert on adz_file to tiptopgp;
grant index on adz_file to public;
grant select on adz_file to ods;
