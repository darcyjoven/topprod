/*
================================================================================
檔案代號:pow_file
檔案名稱:多角贸易调拨单价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pow_file
(
pow01       varchar2(8) NOT NULL,    /*流程代码                               */
                                     /*流程代碼 -> pox01,poz01                */
pow02       date NOT NULL,           /*生效日期                               */
                                     /*生效日期 -> pox02                      */
pow03       varchar2(10) NOT NULL,   /*营运中心编号                           */
                                     /*工廠編號 -> poy04                      */
pow04       varchar2(4),             /*No Use                                 */
pow05       varchar2(40) NOT NULL,   /*料号条件范围                           */
                                     /*料號條件範圍(為QBE格式)                */
pow06       number(20,6),            /*单价                                   */
                                     /*單價                                   */
pow07       varchar2(1),             /*No Use                                 */
pow08       varchar2(1),             /*No Use                                 */
powuser     varchar2(10),            /*资料所有者                             */
powgrup     varchar2(10),            /*资料所有部门                           */
powmodu     varchar2(10),            /*资料更改者                             */
powdate     date,                    /*最近更改日                             */
poworig     varchar2(10),            /*资料建立部门                           */
poworiu     varchar2(10)             /*资料建立者                             */
);

alter table pow_file add  constraint pow_pk primary key  (pow01,pow02,pow03,pow05) enable validate;
grant select on pow_file to tiptopgp;
grant update on pow_file to tiptopgp;
grant delete on pow_file to tiptopgp;
grant insert on pow_file to tiptopgp;
grant index on pow_file to public;
grant select on pow_file to ods;
