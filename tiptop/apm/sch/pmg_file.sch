/*
================================================================================
檔案代號:pmg_file
檔案名稱:供应厂商重要备注资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmg_file
(
pmg01       varchar2(10) NOT NULL,   /*供应厂商编号                           */
                                     /*供應廠商編號                           */
pmg02       number(5) NOT NULL,      /*行序号                                 */
                                     /*行序號                                 */
pmg03       varchar2(255)            /*重要备注                               */
                                     /*重要備註                               */
);

alter table pmg_file add  constraint pmg_pk primary key  (pmg01,pmg02) enable validate;
grant select on pmg_file to tiptopgp;
grant update on pmg_file to tiptopgp;
grant delete on pmg_file to tiptopgp;
grant insert on pmg_file to tiptopgp;
grant index on pmg_file to public;
grant select on pmg_file to ods;
