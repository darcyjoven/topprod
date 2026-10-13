/*
================================================================================
檔案代號:rws_file
檔案名稱:促销时间变更单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rws_file
(
rws01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销时间变更单号*/
rws02       number(5) DEFAULT '0' NOT NULL, /*项次*/
rws03       number(5),               /*变更项次                               */
rws04       varchar2(40),            /*变更代码                               */
rws05       date,                    /*促销开始日期                           */
rws06       date,                    /*促销结束日期                           */
rws07       varchar2(8),             /*促销开始时间                           */
rws08       varchar2(8),             /*促销结束时间                           */
rws09       varchar2(255),           /*备注                                   */
rws10       varchar2(1),             /*有效否                                 */
rwslegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwsplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rws_file add  constraint rws_pk primary key  (rws01,rws02) enable validate;
grant select on rws_file to tiptopgp;
grant update on rws_file to tiptopgp;
grant delete on rws_file to tiptopgp;
grant insert on rws_file to tiptopgp;
grant index on rws_file to public;
grant select on rws_file to ods;
