/*
================================================================================
檔案代號:ibb_file
檔案名稱:条码基本资料-明细档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ibb_file
(
ibb01       varchar2(80) DEFAULT ' ' NOT NULL, /*条码编号*/
ibb02       varchar2(1) DEFAULT 'A' NOT NULL, /*条码产生时机点*/
ibb03       varchar2(20) DEFAULT ' ' NOT NULL, /*来源单号*/
ibb04       number(5) DEFAULT '0' NOT NULL, /*来源项次*/
ibb05       number(5) DEFAULT '0' NOT NULL, /*包号*/
ibb06       varchar2(40),            /*料号                                   */
ibb07       number(10),              /*数量                                   */
ibb08       varchar2(1),             /*包装类型                               */
ibb09       varchar2(10),            /*包装系列                               */
ibb10       number(5),               /*总包数                                 */
ibb11       varchar2(1) DEFAULT 'Y' NOT NULL, /*使用否*/
ibb12       number(10) DEFAULT '0' NOT NULL, /*打印次数*/
ibbacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
ibb13       number(5) DEFAULT '0' NOT NULL /*检验批号(分批检验顺序)*/
);

alter table ibb_file add  constraint ibb_pk primary key  (ibb01,ibb02,ibb03,ibb04,ibb05,ibb13) enable validate;
grant select on ibb_file to tiptopgp;
grant update on ibb_file to tiptopgp;
grant delete on ibb_file to tiptopgp;
grant insert on ibb_file to tiptopgp;
grant index on ibb_file to public;
grant select on ibb_file to ods;
