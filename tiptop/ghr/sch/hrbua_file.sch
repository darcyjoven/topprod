/*
================================================================================
檔案代號:hrbua_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbua_file
(
hrbua01     varchar2(50) NOT NULL,   /*型号编码                               */
hrbua02     varchar2(50) NOT NULL,   /*功能键编号                             */
hrbua03     varchar2(100),           /*功能键说明                             */
hrbua04     varchar2(255),           /*备注                                   */
hrbuauser   varchar2(10),            /*资料所有者                             */
hrbuagrup   varchar2(10),            /*资料所有群                             */
hrbuamodu   varchar2(10),            /*资料修改者                             */
hrbuadate   date,                    /*资料修改日期                           */
hrbuaorig   varchar2(10),            /*资料建立部门                           */
hrbuaoriu   varchar2(10)             /*资料建立者                             */
);

alter table hrbua_file add  constraint tpc_hrbua_pk primary key  (hrbua01,hrbua02) enable validate;
grant select on hrbua_file to tiptopgp;
grant update on hrbua_file to tiptopgp;
grant delete on hrbua_file to tiptopgp;
grant insert on hrbua_file to tiptopgp;
grant index on hrbua_file to public;
grant select on hrbua_file to ods;
