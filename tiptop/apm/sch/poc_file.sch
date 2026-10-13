/*
================================================================================
檔案代號:poc_file
檔案名稱:代采买多角贸易调拨单价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table poc_file
(
poc01       varchar2(2) NOT NULL,    /*通路代码                               */
                                     /*通路代碼 -> pob01,poa01                */
poc02       date NOT NULL,           /*生效日期                               */
                                     /*生效日期 -> pob02                      */
poc03       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*工廠編號 -> poa11,poa21,...,poa61      */
poc04       varchar2(4),             /*No Use                                 */
poc05       varchar2(40) NOT NULL,   /*料号条件范围                           */
                                     /*料號條件範圍(為QBE格式)                */
poc06       number(20,6),            /*单价                                   */
                                     /*單價                                   */
pocuser     varchar2(10),            /*资料所有者                             */
pocgrup     varchar2(10),            /*资料所有部门                           */
pocmodu     varchar2(10),            /*资料更改者                             */
pocdate     date,                    /*最近更改日                             */
pocorig     varchar2(10),            /*资料建立部门                           */
pocoriu     varchar2(10)             /*资料建立者                             */
);

alter table poc_file add  constraint poc_pk primary key  (poc01,poc02,poc03,poc05) enable validate;
grant select on poc_file to tiptopgp;
grant update on poc_file to tiptopgp;
grant delete on poc_file to tiptopgp;
grant insert on poc_file to tiptopgp;
grant index on poc_file to public;
grant select on poc_file to ods;
