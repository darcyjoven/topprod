/*
================================================================================
檔案代號:oaj_file
檔案名稱:费用代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oaj_file
(
oaj01       varchar2(10) NOT NULL,   /*费用代码                               */
                                     /*費用代碼                               */
oaj02       varchar2(80),            /*费用名称                               */
                                     /*費用名稱                               */
oaj03       varchar2(10),            /*No Use                                 */
oajacti     varchar2(1),             /*有效码                                 */
oaj031      varchar2(10),            /*费用总类编号                           */
oaj04       varchar2(24),            /*会计科目                               */
oaj041      varchar2(24),            /*会计科目二                             */
oaj05       varchar2(2),             /*费用类型                               */
oaj06       varchar2(1) DEFAULT ' ', /*No Use                                 */
oaj07       varchar2(1) DEFAULT ' ' NOT NULL, /*核算制度*/
oajpos      varchar2(1) DEFAULT '1'  /*已传pos否                              */
);

alter table oaj_file add  constraint oaj_pk primary key  (oaj01) enable validate;
grant select on oaj_file to tiptopgp;
grant update on oaj_file to tiptopgp;
grant delete on oaj_file to tiptopgp;
grant insert on oaj_file to tiptopgp;
grant index on oaj_file to public;
grant select on oaj_file to ods;
