/*
================================================================================
檔案代號:gir_file
檔案名稱:现金流量群组表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gir_file
(
gir01       varchar2(6) NOT NULL,    /*群组代码                               */
                                     /*群組代碼                               */
gir02       varchar2(40),            /*说明                                   */
                                     /*說明                                   */
gir03       varchar2(1),             /*变动分类                               */
                                     /*變動分類 1.營業 2.投資 3.理財          */
gir04       varchar2(1),             /*合并否                                 */
                                     /*合併否(Y/N)                            */
gir05       number(5)                /*行序                                   */
);

alter table gir_file add  constraint gir_pk primary key  (gir01) enable validate;
grant select on gir_file to tiptopgp;
grant update on gir_file to tiptopgp;
grant delete on gir_file to tiptopgp;
grant insert on gir_file to tiptopgp;
grant index on gir_file to public;
grant select on gir_file to ods;
