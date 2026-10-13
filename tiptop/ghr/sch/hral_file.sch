/*
================================================================================
檔案代號:hral_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hral_file
(
hral01      varchar2(20) NOT NULL,   /*营运中心编码                           */
hral02      varchar2(50),            /*营运中心名称                           */
hral03      varchar2(20),            /*营运中心简称                           */
hral04      varchar2(255),           /*备注                                   */
hralacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hraluser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hralgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hralmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hraldate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hraloriu    varchar2(10),            /*资料建立者                             */
hralorig    varchar2(10)             /*资料建立部门                           */
);

alter table hral_file add  constraint tpc_hral_pk primary key  (hral01) enable validate;
grant select on hral_file to tiptopgp;
grant update on hral_file to tiptopgp;
grant delete on hral_file to tiptopgp;
grant insert on hral_file to tiptopgp;
grant index on hral_file to public;
grant select on hral_file to ods;
