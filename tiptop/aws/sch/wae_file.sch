/*
================================================================================
檔案代號:wae_file
檔案名稱:通用接口之企业报表参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wae_file
(
wae01       varchar2(20) DEFAULT ' ' NOT NULL, /*报表ID*/
wae02       number(5) DEFAULT '0' NOT NULL, /*参数*/
wae03       varchar2(20),            /*参数名称                               */
wae04       varchar2(80),            /*提示信息                               */
wae05       varchar2(1),             /*参数类型                               */
wae06       number(5),               /*长度限制                               */
wae07       varchar2(1),             /*是否必要                               */
wae08       varchar2(10),            /*控件类型                               */
wae09       varchar2(200),           /*起始值                                 */
wae10       varchar2(200),           /*截止值                                 */
wae11       varchar2(500),           /*取值列表                               */
wae12       varchar2(100),           /*缺省值                                 */
wae13       varchar2(10) DEFAULT 'default' NOT NULL, /*使用者*/
wae14       varchar2(20) DEFAULT 'default' NOT NULL /*他系统代码*/
);

alter table wae_file add  constraint wae_pk primary key  (wae01,wae02,wae13,wae14) enable validate;
grant select on wae_file to tiptopgp;
grant update on wae_file to tiptopgp;
grant delete on wae_file to tiptopgp;
grant insert on wae_file to tiptopgp;
grant index on wae_file to public;
grant select on wae_file to ods;
