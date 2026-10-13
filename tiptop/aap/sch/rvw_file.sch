/*
================================================================================
檔案代號:rvw_file
檔案名稱:收货发票档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvw_file
(
rvw01       varchar2(1000) NOT NULL, /*发票号码                               */
                                     /*發票號碼                               */
rvw02       date,                    /*发票日期                               */
                                     /*發票日期                               */
rvw03       varchar2(4),             /*税种                                   */
                                     /*稅別                                   */
rvw04       number(9,4),             /*税率                                   */
                                     /*稅率                                   */
rvw05       number(20,6),            /*税前金额                               */
                                     /*未稅金額(本幣)                         */
rvw05f      number(20,6),            /*税前金额                               */
                                     /*未稅金額(原幣)                02/09/10 */
rvw06       number(20,6),            /*税额                                   */
                                     /*稅額    (本幣)                         */
rvw06f      number(20,6),            /*税额                                   */
                                     /*稅額    (原幣)                02/09/10 */
rvw07       varchar2(20),            /*发票代码                               */
                                     /*Invoice                   for Tax Control System*/
rvw08       varchar2(20) NOT NULL,   /*入库/退货单号                          */
                                     /*                                       */
rvw09       number(5) NOT NULL,      /*项次                                   */
rvw10       number(15,3),            /*数量                                   */
                                     /*數量                       for 稅控系統*/
rvw11       varchar2(4),             /*币种                                   */
                                     /*幣別                          02/09/10 */
rvw12       number(20,10),           /*汇率                                   */
                                     /*匯率                          02/09/10 */
rvw13       varchar2(1),             /*No Use                                 */
rvw14       varchar2(1),             /*No Use                                 */
rvw15       varchar2(1),             /*No Use                                 */
rvw16       varchar2(1),             /*No Use                                 */
rvw17       number(20,6),            /*原币税前单价                           */
rvwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvw99       varchar2(10),            /*来源营运中心                           */
rvw19       date,                    /*录入日期                               */
rvw18       varchar2(20),            /*帐款编号                               */
rvwacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rvwdate     date,                    /*最近更改日                             */
rvwgrup     varchar2(10),            /*资料所有群                             */
rvwmodu     varchar2(10),            /*资料更改者                             */
rvworig     varchar2(10),            /*资料建立部门                           */
rvworiu     varchar2(10),            /*资料建立者                             */
rvwuser     varchar2(10),            /*资料所有者                             */
ta_rvw01    varchar2(40),
ta_rvw02    varchar2(40),
ta_rvw03    varchar2(40),
ta_rvw04    number(20,6),
ta_rvw05    number(20,6),
ta_rvw06    number(20,6),
ta_rvw07    date,
ta_rvw08    date,
ta_rvw09    date,
ta_rvw10    date
);

alter table rvw_file add  constraint rvw_pk primary key  (rvw01,rvw08,rvw09) enable validate;
grant select on rvw_file to tiptopgp;
grant update on rvw_file to tiptopgp;
grant delete on rvw_file to tiptopgp;
grant insert on rvw_file to tiptopgp;
grant index on rvw_file to public;
grant select on rvw_file to ods;
