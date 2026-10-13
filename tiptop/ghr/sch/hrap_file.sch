/*
================================================================================
檔案代號:hrap_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrap_file
(
hrap01      varchar2(20) NOT NULL,   /*部门编号                               */
hrap02      varchar2(40),            /*部门名称                               */
hrap03      varchar2(40),            /*配置所选公司                           */
hrap04      number(5),               /*项次                                   */
hrap05      varchar2(50) NOT NULL,   /*职位编号                               */
hrap06      varchar2(100),           /*职位名称                               */
hrap07      varchar2(1),             /*主职位否                               */
hrap08      varchar2(1),             /*继位否                                 */
hrap09      varchar2(50),            /*上级职位                               */
hrapacti    varchar2(1),             /*资料有效码                             */
                                     /*系统维护                               */
hrapuser    varchar2(10),            /*资料所有者                             */
                                     /*系统维护                               */
hrapgrup    varchar2(10),            /*资料所有群                             */
                                     /*系统维护                               */
hrapmodu    varchar2(10),            /*资料更改者                             */
                                     /*系统维护                               */
hrapdate    date,                    /*最近修改日                             */
                                     /*系统维护                               */
hraporiu    varchar2(10),            /*资料建立者                             */
hraporig    varchar2(10)             /*资料建立部门                           */
);

alter table hrap_file add  constraint tpc_hrap_pk primary key  (hrap01,hrap05) enable validate;
grant select on hrap_file to tiptopgp;
grant update on hrap_file to tiptopgp;
grant delete on hrap_file to tiptopgp;
grant insert on hrap_file to tiptopgp;
grant index on hrap_file to public;
grant select on hrap_file to ods;
