/*
================================================================================
檔案代號:oft_file
檔案名稱:佣金计算明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oft_file
(
oft01       varchar2(20),            /*出货单号                               */
                                     /*出貨單號                               */
oft02       date,                    /*出货日期                               */
                                     /*出貨日期                               */
oft03       varchar2(10),            /*代理商/代送商                          */
                                     /*代理商                                 */
oft04       varchar2(10),            /*业务员编号                             */
                                     /*業務員編號                             */
oft05       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
oft06       number(5),               /*出货项次                               */
                                     /*出貨項次                               */
oft07       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
oft08       number(15,3),            /*出货数量                               */
                                     /*出貨數量                               */
oft09       number(20,6),            /*出货金额                               */
                                     /*出貨金額                               */
oft10       number(20,6),            /*标准售价                               */
                                     /*標準售價                               */
oft11       number(20,6),            /*成本                                   */
oft12       number(20,6),            /*利润                                   */
                                     /*利潤                                   */
oft13       varchar2(10),            /*佣金编号                               */
                                     /*佣金編號                               */
oft14       varchar2(4),             /*佣金币种                               */
                                     /*佣金幣別                               */
oft15       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
                                     /*依單據日期當天匯率                     */
oft16       number(20,6),            /*应付佣金                               */
                                     /*應付佣金                               */
oft17       varchar2(1),             /*佣金对象                               */
oft18       number(5),               /*佣金年度                               */
oft19       number(5),               /*佣金月份                               */
oft20       varchar2(1),             /*No Use                                 */
oft21       varchar2(20),            /*应付单号                               */
oftplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oftlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oft_01 on oft_file (oft01,oft02,oft03,oft04);
grant select on oft_file to tiptopgp;
grant update on oft_file to tiptopgp;
grant delete on oft_file to tiptopgp;
grant insert on oft_file to tiptopgp;
grant index on oft_file to public;
grant select on oft_file to ods;
