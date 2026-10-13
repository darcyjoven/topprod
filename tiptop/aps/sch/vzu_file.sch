/*
================================================================================
檔案代號:vzu_file
檔案名稱:aps規劃狀態檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vzu_file
(
vzu00       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vzu01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vzu02       varchar2(10) DEFAULT ' ' NOT NULL, /*储存版本*/
vzu03       number(5) DEFAULT '0' NOT NULL, /*程序编号*/
vzu04       varchar2(80),            /*程序名称                               */
vzu05       date,                    /*开始时间(日期)                         */
vzu06       date,                    /*结束时间(日期)                         */
vzu07       varchar2(1),             /*运行状态                               */
vzu08       varchar2(1),             /*APS整合类型                            */
vzuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vzulegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table vzu_file add  constraint vzu_pk primary key  (vzu00,vzu01,vzu02,vzu03) enable validate;
grant select on vzu_file to tiptopgp;
grant update on vzu_file to tiptopgp;
grant delete on vzu_file to tiptopgp;
grant insert on vzu_file to tiptopgp;
grant index on vzu_file to public;
grant select on vzu_file to ods;
