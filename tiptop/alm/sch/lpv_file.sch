/*
================================================================================
檔案代號:lpv_file
檔案名稱:储值卡注销资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpv_file
(
lpv01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lpv02       varchar2(10),            /*no use                                 */
lpv03       varchar2(30),            /*储值卡编号                             */
lpv04       number(20,2),            /*储值卡余额                             */
lpv05       number(6,2),             /*折扣率                                 */
lpv06       number(20,2),            /*No Use                                 */
lpv07       number(20,2),            /*实际退款金额                           */
lpv08       varchar2(1),             /*审核码                                 */
lpv09       varchar2(10),            /*审核人                                 */
lpv10       date,                    /*审核日期                               */
lpv11       varchar2(50),            /*备注                                   */
lpv12       varchar2(20),            /*卡种编号                               */
lpv13       varchar2(20),            /*冲账单号                               */
lpvacti     varchar2(1),             /*资料有效码                             */
lpvcrat     date,                    /*资料创建日                             */
lpvdate     date,                    /*资料更改日                             */
lpvgrup     varchar2(10),            /*资料所有群                             */
lpvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpvmodu     varchar2(10),            /*资料更改者                             */
lpvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpvuser     varchar2(10),            /*资料所有者                             */
lpvoriu     varchar2(10),            /*资料建立者                             */
lpvorig     varchar2(10),            /*资料建立部门                           */
lpv14       number(20,2) DEFAULT '0' NOT NULL, /*已退款金额*/
lpv21       number(20,2),            /*POS交易                                */
lpv22       number(20,2),            /*POS送抵现值                            */
lpv23       number(20,2),            /*发卡充值                               */
lpv231      number(20,2),            /*发卡充值折扣金额                       */
lpv232      number(20,2),            /*发卡充值加值金额                       */
lpv24       number(20,2),            /*储值卡充值                             */
lpv241      number(20,2),            /*储值卡充值折扣金额                     */
lpv242      number(20,2),            /*储值卡充值加值金额                     */
lpv25       number(20,2),            /*订单                                   */
lpv26       number(20,2),            /*ERP出货单                              */
lpv27       number(20,2),            /*EPR销退单                              */
lpv28       number(20,2),            /*预收退款                               */
lpv29       number(20,2),            /*押金收取                               */
lpv30       number(20,2),            /*押金返还                               */
lpv31       number(20,2),            /*费用收取                               */
lpv32       number(20,2),            /*费用支出                               */
lpv33       number(20,2),            /*ERP订单送抵现值                        */
lpv34       number(20,2),            /*ERP出货单送抵现值                      */
lpv35       number(20,2) DEFAULT '0' NOT NULL,
lpv36       number(20,2) DEFAULT '0' NOT NULL,
lpv15       varchar2(20)             /*POS单号                                */
);

alter table lpv_file add  constraint lpv_pk primary key  (lpv01) enable validate;
grant select on lpv_file to tiptopgp;
grant update on lpv_file to tiptopgp;
grant delete on lpv_file to tiptopgp;
grant insert on lpv_file to tiptopgp;
grant index on lpv_file to public;
grant select on lpv_file to ods;
