/*
================================================================================
檔案代號:oow_file
檔案名稱:应收系统参数设置-for 流通版
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table oow_file
(
oow00       varchar2(1) DEFAULT '0' NOT NULL, /*KEY VALUE(0)*/
oow01       varchar2(2),
oow02       varchar2(5),             /*定金/押金应收单别-费用单               */
oow03       varchar2(5),             /*收入应收单别-费用单                    */
oow04       varchar2(2),             /*银存异动码-支出单                      */
oow05       varchar2(5),             /*冲账单别-支出单                        */
oow06       varchar2(5),             /*银行收支单别                           */
oow07       varchar2(5),             /*冲账单别-储值卡退余额                  */
oow08       varchar2(2),             /*银存异动码-收款单                      */
oow09       varchar2(5),             /*储值卡定金单别                         */
oow10       varchar2(2),             /*银存异动码-储值卡销售                  */
oow11       varchar2(2),             /*银存异动码-储值卡充值                  */
oow12       varchar2(2),             /*银存异动码-储值卡余额                  */
oow13       varchar2(20),            /*银行编号-转费用                        */
oow14       varchar2(5),             /*冲账单别-收款单                        */
oow15       varchar2(5),             /*冲账单别-退款单                        */
oow16       varchar2(5),             /*应收账款单别-储值卡                    */
oow17       varchar2(2),             /*银存异动码-退款单                      */
oow18       varchar2(5),             /*代收帐款单别                           */
oow19       varchar2(5),             /*预收账款单别                           */
oow20       varchar2(5),             /*代收应返帐款单别                       */
oow21       varchar2(20),            /*银行编号-支出单                        */
oow22       varchar2(5),             /*收票单别                               */
oow23       varchar2(4),             /*变动码                                 */
oow24       varchar2(10),            /*部门                                   */
oow25       varchar2(4),             /*币种                                   */
oow26       varchar2(5),             /*待抵单别-费用支出                      */
oow27       varchar2(20)             /*银行编号-销售单                        */
);

alter table oow_file add  constraint oow_pk primary key  (oow00) enable validate;
grant select on oow_file to tiptopgp;
grant update on oow_file to tiptopgp;
grant delete on oow_file to tiptopgp;
grant insert on oow_file to tiptopgp;
grant index on oow_file to public;
grant select on oow_file to ods;
