/*
================================================================================
檔案代號:gbr_file
檔案名稱:自订字段检查维护档
檔案目的:自订字段检查设置
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gbr_file
(
gbr01       varchar2(20) NOT NULL,   /*画面代码                               */
gbr02       varchar2(20) NOT NULL,   /*字段代码                               */
gbr03       varchar2(1) NOT NULL,    /*客制码                                 */
gbr04       varchar2(50),            /*对应检查的表格字段                     */
gbr05       varchar2(1),             /*是否要设置范围                         */
gbr06       varchar2(15),            /*范围起始                               */
gbr07       varchar2(15),            /*范围结束                               */
gbr08       varchar2(20),            /*动态开窗查询                           */
gbr09       varchar2(1),             /*No Use                                 */
gbr10       varchar2(1),             /*No Use                                 */
gbr11       varchar2(1)              /*No Use                                 */
);

grant select on gbr_file to tiptopgp;
grant update on gbr_file to tiptopgp;
grant delete on gbr_file to tiptopgp;
grant insert on gbr_file to tiptopgp;
grant index on gbr_file to public;
grant select on gbr_file to ods;
