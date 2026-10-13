/*
================================================================================
檔案代號:lia_file
檔案名稱:场地申请资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lia_file
(
lia01       varchar2(20) DEFAULT ' ' NOT NULL, /*场地申请单号*/
lia02       date,                    /*申请日期                               */
lia03       varchar2(1) DEFAULT ' ' NOT NULL, /*申请类型  1.新增 2.修改 3.作废*/
lia04       varchar2(20),            /*场地编号                               */
lia05       number(5),               /*版本号                                 */
lia06       varchar2(20),            /*合同面积变更申请                       */
lia07       varchar2(10),            /*楼栋编号                               */
lia08       varchar2(10),            /*楼层编号                               */
lia09       varchar2(10),            /*区域编号                               */
lia10       number(20,6),            /*原建築面積                             */
lia101      number(20,6),            /*建筑面积                               */
lia11       number(20,6),            /*原測量面積                             */
lia111      number(20,6),            /*測量面積                               */
lia12       number(20,6),            /*原經營面積                             */
lia121      number(20,6),            /*经营面积                               */
lia13       varchar2(1) DEFAULT ' ' NOT NULL, /*場地狀態  Y.已使用 N.未使用*/
lia14       varchar2(255),           /*备注                                   */
lia15       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
liaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
liacond     date,                    /*审核日期                               */
liaconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
liaconu     varchar2(10),            /*审核人                                 */
liadate     date,                    /*最近更改日                             */
liagrup     varchar2(10),            /*资料所有群                             */
lialegal    varchar2(10),            /*法人                                   */
liamksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
liamodu     varchar2(10),            /*资料更改者                             */
liaorig     varchar2(10),            /*资料建立部门                           */
liaoriu     varchar2(10),            /*资料建立者                             */
liaplant    varchar2(10),            /*门店编号                               */
liauser     varchar2(10)             /*资料所有者                             */
);

alter table lia_file add  constraint lia_pk primary key  (lia01) enable validate;
grant select on lia_file to tiptopgp;
grant update on lia_file to tiptopgp;
grant delete on lia_file to tiptopgp;
grant insert on lia_file to tiptopgp;
grant index on lia_file to public;
grant select on lia_file to ods;
