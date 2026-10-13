/*
================================================================================
檔案代號:nqg_file
檔案名稱:资金模拟明细
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nqg_file
(
nqg01       varchar2(10),            /*版本                                   */
nqg02       varchar2(10),            /*来源营运中心                           */
nqg03       varchar2(4),             /*营运币种                               */
nqg04       date,                    /*供需日期                               */
nqg05       varchar2(1),             /*变动分类                               */
nqg06       varchar2(3),             /*类型                                   */
nqg07       varchar2(20),            /*对象                                   */
nqg08       varchar2(20),            /*来源单号                               */
nqg09       number(5),               /*来源项次                               */
nqg10       varchar2(4),             /*交易币种                               */
nqg11       number(20,10),           /*交易汇率                               */
nqg12       number(20,6),            /*交易金额                               */
nqg13       number(20,6),            /*营运金额                               */
nqg14       number(20,6),            /*集团金额                               */
nqg15       varchar2(255),           /*备注                                   */
nqg16       varchar2(20),            /*银行编号                               */
nqg17       varchar2(40)             /*对象名称                               */
);

create        index nqg_01 on nqg_file (nqg01,nqg02,nqg03,nqg04,nqg05,nqg06);
grant select on nqg_file to tiptopgp;
grant update on nqg_file to tiptopgp;
grant delete on nqg_file to tiptopgp;
grant insert on nqg_file to tiptopgp;
grant index on nqg_file to public;
grant select on nqg_file to ods;
