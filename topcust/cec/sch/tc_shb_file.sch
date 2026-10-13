/*
================================================================================
檔案代號:tc_shb_file
檔案名稱:开工完工明细表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_shb_file
(
tc_shb01    varchar2(1) NOT NULL,    /*资料性质                               */
tc_shb02    varchar2(20) NOT NULL,   /*单据编号                               */
tc_shb03    varchar2(20),            /*LOT单号                                */
tc_shb04    varchar2(20),            /*工单单号                               */
tc_shb05    varchar2(40),            /*生产料号                               */
tc_shb06    number(5),               /*工艺序号                               */
tc_shb07    varchar2(6),             /*工艺编号                               */
tc_shb08    varchar2(80),            /*作业编号                               */
tc_shb09    varchar2(10),            /*工作站编号                             */
tc_shb10    varchar2(1),             /*委外否                                 */
tc_shb11    varchar2(10),            /*报工人员编号                           */
tc_shb12    number(15,3),            /*数量                                   */
tc_shb13    varchar2(8),             /*线班别                                 */
tc_shb14    date,                    /*报工日期                               */
tc_shb15    varchar2(8),             /*报工时间                               */
tc_shb16    varchar2(4),             /*生产单位                               */
tc_shb17    varchar2(20),            /*转移单号                               */
tc_shbud01  varchar2(255),           /*备注                                   */
tc_shbud02  varchar2(40),            /*开工编号                               */
tc_shbud03  varchar2(40),            /*委外入库单号                           */
tc_shbud04  varchar2(40),            /*是否返工                               */
tc_shbud05  date,                    /*自定义字段                             */
tc_shbud06  date,                    /*自定义字段                             */
tc_shbud07  number(15,3),            /*机器数                                 */
tc_shbud08  number(15,3),            /*人数                                   */
tc_shbud09  number(15,3),            /*PNL量                                  */
tc_shbud10  number(15,3),            /*委外转出否                             */
                                     /*0或空表示未转出/ 1表示已转出           */
tc_shb121   number(15,3),            /*报废数量                               */
tc_shb122   number(15,3),            /*返工数量                               */
tc_shbud11  date,
tc_shbud12  date
);

alter table tc_shb_file add  constraint tpc_shb_pk primary key  (tc_shb02) enable validate;
grant select on tc_shb_file to tiptopgp;
grant update on tc_shb_file to tiptopgp;
grant delete on tc_shb_file to tiptopgp;
grant insert on tc_shb_file to tiptopgp;
grant index on tc_shb_file to public;
grant select on tc_shb_file to ods;
