/*
================================================================================
檔案代號:rxx_file
檔案名稱:交款汇总档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxx_file
(
rxx00       varchar2(2) DEFAULT ' ' NOT NULL, /*单据别*/
rxx01       varchar2(20) DEFAULT ' ' NOT NULL, /*单号*/
rxx02       varchar2(2) DEFAULT ' ' NOT NULL, /*款别*/
                                     /*01.现金付款,                           */
                                     /*02.信用卡付款,                         */
                                     /*03.支票付款,                           */
                                     /*04.券付款,                             */
                                     /*05.联盟卡付款,                         */
                                     /*06.储值卡付款,                         */
                                     /*07.冲预收款,                           */
                                     /*08.手工转帐,                           */
                                     /*09.积分抵现                            */
rxx03       varchar2(2),             /*款别类型                               */
rxx04       number(20,6),            /*交款金额                               */
rxx05       number(20,6),            /*溢交款金额                             */
rxx11       varchar2(20),            /*销售单号                               */
rxxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxxplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rxx_file add  constraint rxx_pk primary key  (rxx00,rxx01,rxx02) enable validate;
grant select on rxx_file to tiptopgp;
grant update on rxx_file to tiptopgp;
grant delete on rxx_file to tiptopgp;
grant insert on rxx_file to tiptopgp;
grant index on rxx_file to public;
grant select on rxx_file to ods;
