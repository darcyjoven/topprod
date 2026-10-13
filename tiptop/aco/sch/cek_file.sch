/*
================================================================================
檔案代號:cek_file
檔案名稱:归并前BOM单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cek_file
(
cek01       varchar2(10) DEFAULT ' ' NOT NULL, /*成品序号*/
cek02       varchar2(10) DEFAULT ' ' NOT NULL, /*BOM版本*/
cek03       varchar2(20) DEFAULT ' ' NOT NULL, /*特性代码*/
cek04       number(10) DEFAULT '0' NOT NULL, /*单身项次*/
cek05       varchar2(10),            /*元件归类前序号                         */
cek06       varchar2(40),            /*厂内元件料号                           */
cek07       varchar2(10),            /*归并后序号                             */
cek08       varchar2(40),            /*海关商品编号                           */
cek09       varchar2(4),             /*申报计量单位                           */
cek10       number(20,8),            /*单耗                                   */
cek11       number(20,8),            /*耗损率                                 */
cek12       varchar2(10),            /*成品归并后序号                         */
cek13       varchar2(1)              /*类型                                   */
);

create        index cek_01 on cek_file (cek01,cek02,cek04,cek06);
alter table cek_file add  constraint cek_pk primary key  (cek01,cek02,cek03,cek04) enable validate;
grant select on cek_file to tiptopgp;
grant update on cek_file to tiptopgp;
grant delete on cek_file to tiptopgp;
grant insert on cek_file to tiptopgp;
grant index on cek_file to public;
grant select on cek_file to ods;
