/*
================================================================================
檔案代號:hrbdb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbdb_file
(
hrbdb01     varchar2(20) NOT NULL,   /*争议单号                               */
hrbdb02     number(5) NOT NULL,      /*项次                                   */
hrbdb03     varchar2(50),            /*费用名称                               */
hrbdb04     date,                    /*日期                                   */
hrbdb05     varchar2(50),            /*费用负责人                             */
hrbdb06     number(15,2),            /*费用额                                 */
hrbdbacti   varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrbdbuser   varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrbdbgrup   varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrbdbmodu   varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrbdbdate   date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrbdboriu   varchar2(10),            /*资料建立者                             */
hrbdborig   varchar2(10)             /*资料建立部门                           */
);

alter table hrbdb_file add  constraint tpc_hrbdb_pk primary key  (hrbdb01,hrbdb02) enable validate;
grant select on hrbdb_file to tiptopgp;
grant update on hrbdb_file to tiptopgp;
grant delete on hrbdb_file to tiptopgp;
grant insert on hrbdb_file to tiptopgp;
grant index on hrbdb_file to public;
grant select on hrbdb_file to ods;
