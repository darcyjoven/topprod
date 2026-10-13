/*
================================================================================
檔案代號:pjd_file
檔案名稱:WBS累计预计费用档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjd_file
(
pjd01       varchar2(30) NOT NULL,   /*wbs编码                                */
pjd02       varchar2(10) NOT NULL,   /*费用编号                               */
pjd03       varchar2(24) NOT NULL,   /*科目一                                 */
pjd04       varchar2(24) NOT NULL,   /*科目二                                 */
pjd05       number(20,6)             /*预估金额                               */
);

alter table pjd_file add  constraint pjd_pk primary key  (pjd01,pjd02,pjd03,pjd04) enable validate;
grant select on pjd_file to tiptopgp;
grant update on pjd_file to tiptopgp;
grant delete on pjd_file to tiptopgp;
grant insert on pjd_file to tiptopgp;
grant index on pjd_file to public;
grant select on pjd_file to ods;
