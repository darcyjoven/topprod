/*
================================================================================
檔案代號:ztc_file
檔案名稱:档案名称单身档2
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table ztc_file
(
ztc01       varchar2(15) NOT NULL,   /*档案编号                               */
                                     /*Table name                             */
ztc02       varchar2(10) NOT NULL,   /*database name                          */
ztc03       varchar2(15) NOT NULL,   /*index name                             */
ztc04       varchar2(255) DEFAULT ' ', /*index field*/
ztc05       varchar2(1),             /*属性                                   */
ztc06       varchar2(1)              /*unique                                 */
);

alter table ztc_file add  constraint ztc_pk primary key  (ztc01,ztc02,ztc03) enable validate;
grant select on ztc_file to tiptopgp;
grant update on ztc_file to tiptopgp;
grant delete on ztc_file to tiptopgp;
grant insert on ztc_file to tiptopgp;
grant index on ztc_file to public;
grant select on ztc_file to ods;
