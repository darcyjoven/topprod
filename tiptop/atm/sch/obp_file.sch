/*
================================================================================
檔案代號:obp_file
檔案名稱:单位运费数据文件
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obp_file
(
obp01       varchar2(10) NOT NULL,   /*运输方式代码                           */
obp02       varchar2(10) NOT NULL,   /*始起运输地点                           */
obp03       varchar2(10) NOT NULL,   /*目的运输地点                           */
obp04       number(15,3),            /*耗用天数                               */
obp05       varchar2(4),             /*币种                                   */
obp06       number(20,6),            /*单位运费                               */
obp07       number(20,6),            /*单位运费(退回)                         */
obpacti     varchar2(1),             /*资料有效码                             */
obpuser     varchar2(10),            /*资料所有者                             */
obpgrup     varchar2(10),            /*资料所有部门                           */
obpmodu     varchar2(10),            /*资料更改者                             */
obpdate     date,                    /*最近更改日                             */
obporig     varchar2(10),            /*资料建立部门                           */
obporiu     varchar2(10)             /*资料建立者                             */
);

alter table obp_file add  constraint obp_pk primary key  (obp01,obp02,obp03) enable validate;
grant select on obp_file to tiptopgp;
grant update on obp_file to tiptopgp;
grant delete on obp_file to tiptopgp;
grant insert on obp_file to tiptopgp;
grant index on obp_file to public;
grant select on obp_file to ods;
