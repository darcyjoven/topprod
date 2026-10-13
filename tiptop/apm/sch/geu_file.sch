/*
================================================================================
檔案代號:geu_file
檔案名稱:集团中心资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table geu_file
(
geu00       varchar2(1),             /*集团中心类型                           */
                                     /*Group Category                         */
                                     /*1:Data Center 2:Forecast Center 3:Order Center 4:Purchase Center*/
                                     /*5:Credit Control Center 6:Accounting Center 7:Funds Center 8:Deliver Center*/
geu01       varchar2(10) NOT NULL,   /*集团中心代码                           */
geu02       varchar2(80),            /*集团中心名称                           */
geuacti     varchar2(1),             /*资料有效码                             */
geuuser     varchar2(10),            /*资料所有者                             */
geugrup     varchar2(10),            /*资料所有群                             */
geumodu     varchar2(10),            /*资料更改者                             */
geudate     date,                    /*最近更改日                             */
geuorig     varchar2(10),            /*资料建立部门                           */
geuoriu     varchar2(10)             /*资料建立者                             */
);

alter table geu_file add  constraint geu_pk primary key  (geu01) enable validate;
grant select on geu_file to tiptopgp;
grant update on geu_file to tiptopgp;
grant delete on geu_file to tiptopgp;
grant insert on geu_file to tiptopgp;
grant index on geu_file to public;
grant select on geu_file to ods;
