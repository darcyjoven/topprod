/*
================================================================================
檔案代號:gsyc_file
檔案名稱:软件代工开发记录(资料同 ze.zz.zm.zmd同步清单)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gsyc_file
(
gsyc00      varchar2(20) NOT NULL,   /*审核单号                               */
gsyc01      number(5) NOT NULL,      /*项次                                   */
gsyc02      number(5) NOT NULL,      /*行序                                   */
gsyc03      varchar2(1),             /*动作                                   */
gsyc04      varchar2(1),             /*档案编号                               */
gsyc05      varchar2(15),            /*档案名称                               */
gsyc06      varchar2(80),            /*key字段的值1                           */
gsyc07      varchar2(80),            /*key字段的值2                           */
gsyc08      number(5) NOT NULL       /*版次                                   */
);

alter table gsyc_file add  constraint gsyc_pk primary key  (gsyc00,gsyc01,gsyc08,gsyc02) enable validate;
grant select on gsyc_file to tiptopgp;
grant update on gsyc_file to tiptopgp;
grant delete on gsyc_file to tiptopgp;
grant insert on gsyc_file to tiptopgp;
grant index on gsyc_file to public;
grant select on gsyc_file to ods;
