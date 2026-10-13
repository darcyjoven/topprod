/*
================================================================================
檔案代號:oay_file
檔案名稱:销售系统单据性质档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oay_file
(
oayslip     varchar2(5) NOT NULL,    /*单别                                   */
                                     /*單別                                   */
oaydesc     varchar2(80),            /*单据名称                               */
                                     /*單據名稱                               */
oayauno     varchar2(1),             /*自动编号否                             */
                                     /*自動編號否 (Y/N)                       */
oayconf     varchar2(1),             /*自动审核否                             */
                                     /*自動確認否 (Y/N)                       */
oayprnt     varchar2(1),             /*立即打印否                             */
                                     /*立即列印否 (Y/N)                       */
oaymxno     varchar2(20),            /*已用单号                               */
                                     /*已用單號                               */
oaydmy6     varchar2(1),             /*No Use                                 */
                                     /*1.依流水號                             */
                                     /*2.依年月                               */
oaytype     varchar2(2),             /*单据性质                               */
                                     /*Document Property                      */
                                     /*  02.Customer Inventory Transaction List*/
                                     /*  03.Send-Sales Inventory Transaction List*/
                                     /*  09.Customer Apply                    */
                                     /*  10.Quotation                         */
                                     /*  20.Contract                          */
                                     /*  30.General Order                     */
                                     /*  32.Exchange Order                    */
                                     /*  33.Order,Delivery to Offshore W/H    */
                                     /*  34.Order,Offshore W/H Delivery       */
                                     /*  35.Order,Inter-BU Sale               */
                                     /*  40.Delivery Advice                   */
                                     /*  43.Delivery Advice, Delivery to Offshore W/H*/
                                     /*  44.Delivery Advice,Offshore W/H Delivery*/
                                     /*  46.Delivery Advice Inter-BU Sale     */
                                     /*  50.Delivery Note                     */
                                     /*  53.Delivery Note, Delivery to Offshore W/H*/
                                     /*  54.Delivery Note, Offshore W/H Delivery*/
                                     /*  55.INVOICE                           */
                                     /*  56.Delivery Note Inter-BU Sale       */
                                     /*  60.Sales/Return Note                 */
                                     /*  70.RMA DOC                           */
                                     /*  71.RMA Re-Delivery Note              */
                                     /*  72.No-Good Item Analysis Report      */
oay11       varchar2(1),             /*是否转AR                               */
                                     /*是否轉AR                               */
oay12       varchar2(1),             /*是否影响呆滞日期                       */
                                     /*是否影響呆滯日期(Y/N)                  */
oay13       varchar2(1),             /*发票是否有限额                         */
                                     /*發票是否有限額(Y/N)        for 稅控系統*/
oay14       number(15,3),            /*发票限额                               */
                                     /*發票限額                   for 稅控系統*/
oayapr      varchar2(1),             /*签核处理                               */
                                     /*簽核處理(Y/N)                          */
oaysign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
oayar       varchar2(1),             /*No Use                                 */
oayacti     varchar2(1),             /*有效否                                 */
oay15       varchar2(1),             /*是否影响业绩                           */
oay16       varchar2(5),             /*出货单别                               */
oay17       varchar2(5),             /*销退单别                               */
oay18       varchar2(10),            /*销退理由码                             */
oay19       varchar2(10),            /*出货理由码                             */
oay20       varchar2(10),            /*债权代码                               */
oay21       varchar2(5),             /*No Use                                 */
oay22       varchar2(10),            /*属性群组代码                           */
oay23       varchar2(10),            /*No Use                                 */
oay24       varchar2(1) DEFAULT ' ', /*两角内部交易单据否                     */
oay25       number(5),               /*No Use                                 */
oayglcr     varchar2(1),             /*是否直接抛转总帐                       */
oaygslp     varchar2(5),             /*总帐单别                               */
oaysys      varchar2(10),            /*系统                                   */
oayud01     varchar2(255),           /*自订字段                               */
oayud02     varchar2(40),            /*自订字段                               */
oayud03     varchar2(40),            /*自订字段                               */
oayud04     varchar2(40),            /*自订字段                               */
oayud05     varchar2(40),            /*自订字段                               */
oayud06     varchar2(255),           /*自订字段                               */
oayud07     number(15,3),            /*自订字段                               */
oayud08     number(15,3),            /*自订字段                               */
oayud09     number(15,3),            /*自订字段                               */
oayud10     number(10),              /*自订字段                               */
oayud11     number(10),              /*自订字段                               */
oayud12     number(10),              /*自订字段                               */
oayud13     date,                    /*自订字段                               */
oayud14     date,                    /*自订字段                               */
oayud15     date                     /*自订字段                               */
);

alter table oay_file add  constraint oay_pk primary key  (oayslip) enable validate;
grant select on oay_file to tiptopgp;
grant update on oay_file to tiptopgp;
grant delete on oay_file to tiptopgp;
grant insert on oay_file to tiptopgp;
grant index on oay_file to public;
grant select on oay_file to ods;
