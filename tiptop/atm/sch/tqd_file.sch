/*
================================================================================
檔案代號:tqd_file
檔案名稱:集团组织机构单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqd_file
(
tqd01       varchar2(10) NOT NULL,   /*上级组织机构代码                       */
tqd02       number(5) NOT NULL,      /*项次                                   */
tqd03       varchar2(10),            /*下级组织编号                           */
tqd04       varchar2(10),            /*所属通路代码                           */
tqd05       date,                    /*生效日期                               */
tqd06       date                     /*失效日期                               */
);

create        index tqd_02 on tqd_file (tqd01,tqd03);
alter table tqd_file add  constraint tqd_pk primary key  (tqd01,tqd02) enable validate;
grant select on tqd_file to tiptopgp;
grant update on tqd_file to tiptopgp;
grant delete on tqd_file to tiptopgp;
grant insert on tqd_file to tiptopgp;
grant index on tqd_file to public;
grant select on tqd_file to ods;
