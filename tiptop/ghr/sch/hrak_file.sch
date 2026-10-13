/*
================================================================================
檔案代號:hrak_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrak_file
(
hrak01      varchar2(50) NOT NULL,   /*费用类型名称                           */
hrak02      varchar2(50),            /*费用类型简称                           */
hrak03      varchar2(100),           /*备注                                   */
hrakacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrakuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrakgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrakmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrakdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hrakoriu    varchar2(10),            /*资料建立者                             */
hrakorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrak_file add  constraint tpc_hrak_pk primary key  (hrak01) enable validate;
grant select on hrak_file to tiptopgp;
grant update on hrak_file to tiptopgp;
grant delete on hrak_file to tiptopgp;
grant insert on hrak_file to tiptopgp;
grant index on hrak_file to public;
grant select on hrak_file to ods;
