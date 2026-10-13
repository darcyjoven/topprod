/*
================================================================================
檔案代號:pjf_file
檔案名稱:WBS累计材料需求档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjf_file
(
pjf01       varchar2(30) NOT NULL,   /*wbs编码                                */
pjf02       number(5) NOT NULL,      /*项次                                   */
pjf03       varchar2(40),            /*料件编号                               */
pjf04       varchar2(120),           /*品名                                   */
pjf05       number(15,3),            /*需求量                                 */
pjf06       date,                    /*需求日期                               */
pjf07       number(15,3)             /*转请购量                               */
);

alter table pjf_file add  constraint pjf_pk primary key  (pjf01,pjf02) enable validate;
grant select on pjf_file to tiptopgp;
grant update on pjf_file to tiptopgp;
grant delete on pjf_file to tiptopgp;
grant insert on pjf_file to tiptopgp;
grant index on pjf_file to public;
grant select on pjf_file to ods;
