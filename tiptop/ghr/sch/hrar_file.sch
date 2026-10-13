/*
================================================================================
檔案代號:hrar_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrar_file
(
hrar01      varchar2(20),            /*所属公司编码                           */
hrar02      varchar2(20),            /*职务分类编码                           */
hrar03      varchar2(50) NOT NULL,   /*职务序列编码                           */
hrar04      varchar2(100),           /*职务序列名称                           */
hrar05      varchar2(100),           /*备注                                   */
hrar06      varchar2(10),            /*职务等级                               */
hraracti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hraruser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrargrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrarmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrardate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hraroriu    varchar2(10),            /*资料建立者                             */
hrarorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrar_file add  constraint tpc_hrar_pk primary key  (hrar03) enable validate;
grant select on hrar_file to tiptopgp;
grant update on hrar_file to tiptopgp;
grant delete on hrar_file to tiptopgp;
grant insert on hrar_file to tiptopgp;
grant index on hrar_file to public;
grant select on hrar_file to ods;
