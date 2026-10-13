/*
================================================================================
檔案代號:lqa_file
檔案名稱:券核销记录单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqa_file
(
lqa01       varchar2(20) DEFAULT ' ' NOT NULL, /*核销单号*/
lqa02       varchar2(1) DEFAULT ' ' NOT NULL, /*核销类型*/
lqa03       varchar2(10),            /*no use 原门店编号                      */
lqa04       date,                    /*核销日期                               */
lqa05       varchar2(1),             /*是否签核                               */
lqa06       varchar2(1),             /*签核状态                               */
lqa07       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lqa08       varchar2(10),            /*审核人                                 */
lqa09       date,                    /*审核日期                               */
lqaacti     varchar2(1),             /*资料有效码                             */
lqacrat     date,                    /*资料创建日                             */
lqadate     date,                    /*最近更改日                             */
lqagrup     varchar2(10),            /*资料所有群                             */
lqalegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqamodu     varchar2(10),            /*资料更改者                             */
lqaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lqauser     varchar2(10),            /*资料所有者                             */
lqaoriu     varchar2(10),            /*资料建立者                             */
lqaorig     varchar2(10)             /*资料建立部门                           */
);

alter table lqa_file add  constraint lqa_pk primary key  (lqa01) enable validate;
grant select on lqa_file to tiptopgp;
grant update on lqa_file to tiptopgp;
grant delete on lqa_file to tiptopgp;
grant insert on lqa_file to tiptopgp;
grant index on lqa_file to public;
grant select on lqa_file to ods;
