/*
================================================================================
檔案代號:tc_zaj_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zaj_file
(
zaj01       varchar2(80) NOT NULL,   /*查询单ID                               */
zaj02       number(5) NOT NULL,      /*运行顺序                               */
zaj03       varchar2(1),             /*启动否                                 */
zaj04       varchar2(1),             /*来源类型                               */
zaj05       varchar2(255),           /*运行指令                               */
zaj06       varchar2(255),           /*备注                                   */
zaj07       varchar2(1) NOT NULL     /*客制码                                 */
);

grant select on tc_zaj_file to tiptopgp;
grant update on tc_zaj_file to tiptopgp;
grant delete on tc_zaj_file to tiptopgp;
grant insert on tc_zaj_file to tiptopgp;
grant index on tc_zaj_file to public;
grant select on tc_zaj_file to ods;
