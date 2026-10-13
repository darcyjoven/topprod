/*
================================================================================
檔案代號:hrai_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrai_file
(
hrai01      varchar2(20),            /*营运中心编码                           */
hrai02      varchar2(50),            /*营运中心名称                           */
hrai03      varchar2(20) NOT NULL,   /*成本中心编码                           */
hrai04      varchar2(20) NOT NULL,   /*成本中心名称                           */
hrai05      varchar2(255),           /*备注                                   */
hraiacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hraiuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hraigrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hraimodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hraidate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hraioriu    varchar2(10),            /*资料建立者                             */
hraiorig    varchar2(10)             /*资料建立部门                           */
);

alter table hrai_file add  constraint tpc_hrai_pk primary key  (hrai03) enable validate;
grant select on hrai_file to tiptopgp;
grant update on hrai_file to tiptopgp;
grant delete on hrai_file to tiptopgp;
grant insert on hrai_file to tiptopgp;
grant index on hrai_file to public;
grant select on hrai_file to ods;
