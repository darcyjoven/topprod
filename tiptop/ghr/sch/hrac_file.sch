/*
================================================================================
檔案代號:hrac_file
檔案名稱:财年维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrac_file
(
hrac01      varchar2(10) NOT NULL,   /*财年                                   */
hrac02      varchar2(10) NOT NULL,   /*财年月                                 */
hrac03      date,                    /*开始日期                               */
hrac04      date,                    /*结束日期                               */
hracuser    varchar2(10),            /*资料所有者                             */
hracgrup    varchar2(10),            /*资料所有群                             */
hracmodu    varchar2(10),            /*资料修改者                             */
hracdate    date,                    /*最近修改日                             */
hracorig    varchar2(10),            /*资料建立者                             */
hracoriu    varchar2(10)             /*资料建立部门                           */
);

alter table hrac_file add  constraint tpc_hrac_pk primary key  (hrac01,hrac02) enable validate;
grant select on hrac_file to tiptopgp;
grant update on hrac_file to tiptopgp;
grant delete on hrac_file to tiptopgp;
grant insert on hrac_file to tiptopgp;
grant index on hrac_file to public;
grant select on hrac_file to ods;
