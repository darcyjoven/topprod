/*
================================================================================
檔案代號:lja_file
檔案名稱:优惠变更申请单
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lja_file
(
lja01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
lja02       varchar2(1) DEFAULT ' ' NOT NULL, /*申请类型*/
lja03       date,                    /*申请日期                               */
lja04       varchar2(10),            /*申请人                                 */
lja05       varchar2(20),            /*合约编号                               */
lja06       varchar2(20),            /*摊位编号                               */
lja07       varchar2(10),            /*经营小类                               */
lja08       number(20,6),            /*建筑面积                               */
lja081      number(20,6),            /*新建筑面积                             */
lja09       number(20,6),            /*測量面積                               */
lja091      number(20,6),            /*新测量面积                             */
lja10       number(20,6),            /*经营面积                               */
lja101      number(20,6),            /*新经营面积                             */
lja11       date,                    /*生效日期                               */
lja12       varchar2(10),            /*商户编号                               */
lja13       varchar2(10),            /*主品牌                                 */
lja131      varchar2(10),            /*新主品牌                               */
lja14       date,                    /*租赁期限起日期                         */
lja15       date,                    /*租赁期限止日期                         */
lja16       number(5),               /*免租天数                               */
lja17       date,                    /*计租期限起日期                         */
lja18       date,                    /*计租期限止日期                         */
lja19       date,                    /*延期日期                               */
lja20       varchar2(255),           /*备注                                   */
lja21       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
ljaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ljacond     date,                    /*审核日期                               */
ljaconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
ljacont     varchar2(8),             /*审核时间                               */
ljaconu     varchar2(10),            /*审核人                                 */
ljacrat     date,                    /*资料创建日                             */
ljadate     date,                    /*最近更改日                             */
ljagrup     varchar2(10),            /*资料所有群                             */
ljalegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljamksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
ljamodu     varchar2(10),            /*资料更改者                             */
ljaorig     varchar2(10),            /*资料建立部门                           */
ljaoriu     varchar2(10),            /*资料建立者                             */
ljaplant    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
ljauser     varchar2(10)             /*资料所有者                             */
);

alter table lja_file add  constraint lja_pk primary key  (lja01) enable validate;
grant select on lja_file to tiptopgp;
grant update on lja_file to tiptopgp;
grant delete on lja_file to tiptopgp;
grant insert on lja_file to tiptopgp;
grant index on lja_file to public;
grant select on lja_file to ods;
