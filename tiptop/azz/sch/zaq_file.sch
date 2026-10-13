/*
================================================================================
檔案代號:zaq_file
檔案名稱:SQL Wizard  Table 记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zaq_file
(
zaq01       varchar2(80) NOT NULL,   /*测试字段1                              */
zaq02       varchar2(15) NOT NULL,   /*测试字段2                              */
zaq03       varchar2(1),             /*outer                                  */
zaq04       number(5) NOT NULL,      /*序号                                   */
zaq05       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zaq_file add  constraint zaq_pk primary key  (zaq01,zaq02,zaq05) enable validate;
grant select on zaq_file to tiptopgp;
grant update on zaq_file to tiptopgp;
grant delete on zaq_file to tiptopgp;
grant insert on zaq_file to tiptopgp;
grant index on zaq_file to public;
grant select on zaq_file to ods;
