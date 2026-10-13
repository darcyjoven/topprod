/*
================================================================================
檔案代號:tqw_file
檔案名稱:现金折扣单资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqw_file
(
tqw01       varchar2(20) NOT NULL,   /*现金折扣单号                           */
tqw02       date,                    /*日期                                   */
tqw03       varchar2(10),            /*部门编码                               */
tqw04       varchar2(10),            /*人员编码                               */
tqw05       varchar2(10),            /*客户编码                               */
tqw06       varchar2(4),             /*摘要编号                               */
tqw07       number(20,6),            /*应返金额                               */
tqw08       number(20,6),            /*已返金额                               */
tqw081      number(20,6),            /*已扣金额                               */
tqw09       varchar2(255),           /*备注                                   */
tqw10       varchar2(1),             /*状态码                                 */
tqw11       varchar2(4),             /*税种                                   */
tqw12       number(9,4),             /*税率                                   */
tqw13       varchar2(1),             /*联数                                   */
tqw14       varchar2(1),             /*含税否                                 */
tqw15       varchar2(10),            /*理由码                                 */
tqw16       varchar2(80),            /*摘要名称                               */
tqw17       varchar2(4),             /*币种                                   */
tqw18       number(20,10),           /*汇率                                   */
tqw19       varchar2(15),            /*非直营KAB                              */
tqwacti     varchar2(1),             /*有效否                                 */
tqwuser     varchar2(10),            /*资料所有者                             */
tqwgrup     varchar2(10),            /*部门                                   */
tqwmodu     varchar2(10),            /*资料更改者                             */
tqwdate     date,                    /*最后更改日期                           */
tqw20       varchar2(1),             /*折扣类型                               */
tqw21       varchar2(1),             /*现返类型 1-单次返,2-累计返,现          */
tqw22       varchar2(20),            /*合同编号,现返依据的合同编号            */
tqw23       varchar2(20),            /*订单单号,单次返依据的订单号            */
tqwplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
tqworiu     varchar2(10),            /*资料建立者                             */
tqworig     varchar2(10)             /*资料建立部门                           */
);

alter table tqw_file add  constraint tqw_pk primary key  (tqw01) enable validate;
grant select on tqw_file to tiptopgp;
grant update on tqw_file to tiptopgp;
grant delete on tqw_file to tiptopgp;
grant insert on tqw_file to tiptopgp;
grant index on tqw_file to public;
grant select on tqw_file to ods;
