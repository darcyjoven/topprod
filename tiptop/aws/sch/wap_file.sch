/*
================================================================================
檔案代號:wap_file
檔案名稱:CROSS 整合配置文件
檔案目的:提供 TIPTOP 基本服务参数设定
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wap_file
(
wap01       varchar2(40) DEFAULT '0' NOT NULL, /*KEY VALUE (0)*/
wap02       varchar2(1) DEFAULT 'N' NOT NULL, /*是否使用CROSS整合平台*/
wap03       varchar2(255),           /*TIPTOP WSDL 位置                       */
wap04       varchar2(255),           /*CROSS WSDL 位置                        */
wap05       number(5),               /*服务联机失败重试次数                   */
wap06       number(5),               /*服务联机失败重试间隔                   */
wap07       number(5),               /*同时联机人数                           */
wapdate     date,                    /*最近更改日                             */
wapgrup     varchar2(10),            /*资料所有群                             */
wapmodu     varchar2(10),            /*资料更改者                             */
waporig     varchar2(10),            /*资料建立部门                           */
waporiu     varchar2(10),            /*资料建立者                             */
wapuser     varchar2(10),            /*资料所有者                             */
wap08       varchar2(1) DEFAULT ' ' NOT NULL,
wap09       varchar2(1) DEFAULT 'N' NOT NULL /*是否启用编码*/
);

alter table wap_file add  constraint wap_pk primary key  (wap01) enable validate;
grant select on wap_file to tiptopgp;
grant update on wap_file to tiptopgp;
grant delete on wap_file to tiptopgp;
grant insert on wap_file to tiptopgp;
grant index on wap_file to public;
grant select on wap_file to ods;
