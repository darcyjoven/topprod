/*
================================================================================
檔案代號:zoa_file
檔案名稱:开账资料单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zoa_file
(
zoa01       varchar2(1) NOT NULL,    /*资料类型                               */
zoa02       varchar2(1),             /*汇入否                                 */
zoa03       varchar2(10) NOT NULL,   /*资料代号                               */
zoa04       varchar2(5),             /*单别                                   */
zoa05       date,                    /*最后汇入日期                           */
zoa06       varchar2(10),            /*最后汇入者                             */
zoa07       number(10),              /*汇入笔数                               */
zoa08       varchar2(10)             /*检核表                                 */
);

alter table zoa_file add  constraint zoa_pk primary key  (zoa01,zoa03) enable validate;
grant select on zoa_file to tiptopgp;
grant update on zoa_file to tiptopgp;
grant delete on zoa_file to tiptopgp;
grant insert on zoa_file to tiptopgp;
grant index on zoa_file to public;
grant select on zoa_file to ods;
