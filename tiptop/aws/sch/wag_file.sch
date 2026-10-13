/*
================================================================================
檔案代號:wag_file
檔案名稱:通用接口之目标系统设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table wag_file
(
wag01       varchar2(10) DEFAULT ' ' NOT NULL, /*系统标示*/
wag02       varchar2(30) DEFAULT ' ' NOT NULL, /*系统说明*/
wag03       varchar2(200),           /*no use                                 */
wag04       varchar2(200) DEFAULT ' ' NOT NULL, /*服务名称*/
wag05       varchar2(200),           /*no use                                 */
wag06       varchar2(200) DEFAULT ' ' NOT NULL, /*Soap Action*/
wag07       varchar2(200),           /*参数NameSpace                          */
wag08       varchar2(20) DEFAULT ' ' NOT NULL, /*服务器IP地址*/
wag09       varchar2(500),           /*报表存放路径                           */
wag10       varchar2(200),           /*传入记录名                             */
wag11       varchar2(200),           /*传入参数名                             */
wag12       varchar2(200),           /*返回记录名                             */
wag13       varchar2(200),           /*返回参数名                             */
wag14       varchar2(200),           /*记录NameSpace                          */
wag15       varchar2(200),           /*返回值名                               */
wag16       varchar2(200),           /*参数NameSpace                          */
wag17       varchar2(1),             /*语言别                                 */
wag18       varchar2(10)             /*Port                                   */
);

alter table wag_file add  constraint wag_pk primary key  (wag01) enable validate;
grant select on wag_file to tiptopgp;
grant update on wag_file to tiptopgp;
grant delete on wag_file to tiptopgp;
grant insert on wag_file to tiptopgp;
grant index on wag_file to public;
grant select on wag_file to ods;
