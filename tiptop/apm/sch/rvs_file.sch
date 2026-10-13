/*
================================================================================
檔案代號:rvs_file
檔案名稱:B2B退厂申请单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:Y
============.========================.==========================================
*/
create table rvs_file
(
rvs01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
rvs02       varchar2(20),            /*收货单号                               */
rvs03       date,                    /*单据日期                               */
rvs04       varchar2(10),            /*申请人员                               */
rvs05       date,                    /*退货日期                               */
rvs06       varchar2(10) DEFAULT ' ' NOT NULL, /*供应商代号*/
rvs07       varchar2(4),             /*税种                                   */
rvs08       varchar2(255),           /*備注                                   */
rvs09       date,                    /*核准日期                               */
rvs10       varchar2(8),
rvs11       varchar2(10),
rvs12       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
rvsacti     varchar2(1) DEFAULT 'N' NOT NULL, /*资料有效码*/
rvscond     date,                    /*审核日期                               */
rvsconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核否*/
rvscont     varchar2(8),             /*审核时间                               */
rvsconu     varchar2(10),            /*审核人员                               */
rvscrat     date,
rvsdate     date,                    /*最近更改日                             */
rvsdays     number(5),               /*签核完成天数                           */
rvsgrup     varchar2(10),            /*资料所有群                             */
rvslegal    varchar2(10),            /*所属法人                               */
rvsmksg     varchar2(1) DEFAULT 'N' NOT NULL, /*是否签核*/
rvsmodu     varchar2(10),            /*资料更改者                             */
rvsorig     varchar2(10),            /*资料建立部门                           */
rvsoriu     varchar2(10),            /*资料建立者                             */
rvsplant    varchar2(10),            /*所属工厂                               */
rvsprit     number(5),               /*签核优先等级                           */
rvssign     varchar2(4),             /*签核等级                               */
rvssmax     number(5),               /*应签核顺序                             */
rvssseq     number(5),               /*已签核顺序                             */
rvsuser     varchar2(10)             /*资料所有者                             */
);

alter table rvs_file add  constraint rvs_pk primary key  (rvs01) enable validate;
grant select on rvs_file to tiptopgp;
grant update on rvs_file to tiptopgp;
grant delete on rvs_file to tiptopgp;
grant insert on rvs_file to tiptopgp;
grant index on rvs_file to public;
grant select on rvs_file to ods;
