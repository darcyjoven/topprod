/*
================================================================================
檔案代號:tc_ibb_file
檔案名稱:条码基本资料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ibb_file
(
tc_ibb01    varchar2(80) NOT NULL,   /*条码编号                               */
tc_ibb02    varchar2(1) NOT NULL,    /*条码产生来源                           */
tc_ibb03    varchar2(20) NOT NULL,   /*来源单号                               */
tc_ibb04    number(5) NOT NULL,      /*来源项次                               */
tc_ibb05    number(5) NOT NULL,      /*序号                                   */
tc_ibb06    varchar2(40),            /*料号                                   */
tc_ibb07    number(10,3),            /*数量                                   */
tc_ibb08    varchar2(1),
tc_ibb09    varchar2(10),
tc_ibb10    number(10,3),            /*最小包装量                             */
tc_ibb11    varchar2(1) NOT NULL,    /*使用否                                 */
tc_ibb12    number(10),
tc_ibbacti  varchar2(1),             /*资料有效否                             */
tc_ibb13    number(5),
tc_ibb14    number(10,3),
tc_ibb15    number(10),
tc_ibb16    number(10),
tc_ibb17    varchar2(40),            /*批号                                   */
tc_ibb18    number(10),
tc_ibb19    number(10),
tc_ibb20    date,                    /*生成日期                               */
tc_ibb21    date,                    /*生产（收货）日期                       */
tc_ibb22    varchar2(40)             /*厂商编号（客户编号，工单号             */
);

create unique index tic_ibb_01 on tc_ibb_file (tc_ibb01,tc_ibb02,tc_ibb03,tc_ibb04,tc_ibb05);
alter table tc_ibb_file add  constraint tpc_ibb_pk primary key  (tc_ibb01,tc_ibb02,tc_ibb03,tc_ibb04,tc_ibb05) enable validate;
grant select on tc_ibb_file to tiptopgp;
grant update on tc_ibb_file to tiptopgp;
grant delete on tc_ibb_file to tiptopgp;
grant insert on tc_ibb_file to tiptopgp;
grant index on tc_ibb_file to public;
grant select on tc_ibb_file to ods;
