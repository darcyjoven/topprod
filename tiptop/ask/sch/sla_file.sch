/*
================================================================================
檔案代號:sla_file
檔案名稱:尺寸参数表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sla_file
(
sla00       varchar2(1) DEFAULT ' ' NOT NULL, /*KEY VALUE ='0'*/
sla01       varchar2(10),            /*x轴的属性                              */
sla011      number(5),               /*x轴的顺序                              */
sla02       varchar2(10),            /*y1轴的属性                             */
sla021      number(5),               /*y1轴的顺序                             */
sla03       varchar2(10),            /*y2轴的属性                             */
sla031      number(5),               /*y2轴的顺序                             */
sla04       varchar2(10),            /*z轴的属性                              */
sla041      number(5)                /*z轴的顺序                              */
);

alter table sla_file add  constraint sla_pk primary key  (sla00) enable validate;
grant select on sla_file to tiptopgp;
grant update on sla_file to tiptopgp;
grant delete on sla_file to tiptopgp;
grant insert on sla_file to tiptopgp;
grant index on sla_file to public;
grant select on sla_file to ods;
