/*
================================================================================
檔案代號:csf_file
檔案名稱:附加成本--料件分群码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table csf_file
(
csf01       varchar2(10) NOT NULL,   /*料件分群码                             */
csf02       varchar2(10) NOT NULL,   /*成本项目                               */
csf03       varchar2(1),             /*成本归类                               */
csf04       number(9,4),             /*比率%                                  */
csf05       number(20,6)             /*金额                                   */
);

alter table csf_file add  constraint csf_pk primary key  (csf01,csf02) enable validate;
grant select on csf_file to tiptopgp;
grant update on csf_file to tiptopgp;
grant delete on csf_file to tiptopgp;
grant insert on csf_file to tiptopgp;
grant index on csf_file to public;
grant select on csf_file to ods;
