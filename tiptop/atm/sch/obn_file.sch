/*
================================================================================
檔案代號:obn_file
檔案名稱:运输途径单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obn_file
(
obn01       varchar2(6) NOT NULL,    /*运输途径编号                           */
obn02       varchar2(80),            /*说明                                   */
obn03       varchar2(10),            /*运输方式代码                           */
obn04       varchar2(10),            /*起始地点                               */
obn05       varchar2(10),            /*目的地点                               */
obnacti     varchar2(1),             /*有效否                                 */
obnuser     varchar2(10),            /*建档人员                               */
obngrup     varchar2(10),            /*建档部门                               */
obnmodu     varchar2(10),            /*最后更改人员                           */
obndate     date,                    /*最后更改日期                           */
obn06       varchar2(10),            /*归属配送中心                           */
obn07       varchar2(10),            /*出货门号                               */
obn08       varchar2(10),            /*线路分类                               */
obnoriu     varchar2(10),            /*资料建立者                             */
obnorig     varchar2(10)             /*资料建立部门                           */
);

alter table obn_file add  constraint obn_pk primary key  (obn01) enable validate;
grant select on obn_file to tiptopgp;
grant update on obn_file to tiptopgp;
grant delete on obn_file to tiptopgp;
grant insert on obn_file to tiptopgp;
grant index on obn_file to public;
grant select on obn_file to ods;
