/*
================================================================================
檔案代號:lpj_file
檔案名稱:卡明细状态档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lpj_file
(
lpj01       varchar2(20) DEFAULT ' ',/*会员编号                               */
lpj02       varchar2(20),            /*卡种                                   */
lpj03       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
lpj04       date,                    /*发行日期                               */
lpj05       date,                    /*结束日期                               */
lpj06       number(20,2),            /*储值卡余额                             */
lpj07       number(20) DEFAULT '0' NOT NULL, /*当前累计消费次数*/
lpj08       date,                    /*最后一次消费日期                       */
lpj09       varchar2(1),             /*卡状态                                 */
lpj10       date,                    /*废止日期                               */
lpj11       number(20,2),            /*储值折扣                               */
lpj12       number(20),              /*目前剩余积分                           */
lpj13       number(20),              /*已兑换积分                             */
lpj14       number(20) DEFAULT '0' NOT NULL, /*当前累计消费积分*/
lpj15       number(20,2),            /*当前累计消费                           */
lpj16       varchar2(1) DEFAULT ' ' NOT NULL, /*可储值*/
lpj17       varchar2(10),            /*发卡营运中心                           */
lpj18       date,                    /*开卡日期                               */
lpj19       varchar2(10),            /*开卡營運中心                           */
lpj20       varchar2(10),            /*作废营运中心                           */
lpj21       date,                    /*注销日期                               */
lpj22       varchar2(10),            /*注销营运中心                           */
lpj23       date,                    /*挂失日期                               */
lpj24       varchar2(10),            /*挂失营运中心                           */
lpj25       date,                    /*最後一次清零日期                       */
lpjpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lpj26       varchar2(40)             /*口令                                   */
);

alter table lpj_file add  constraint lpj_pk primary key  (lpj03) enable validate;
grant select on lpj_file to tiptopgp;
grant update on lpj_file to tiptopgp;
grant delete on lpj_file to tiptopgp;
grant insert on lpj_file to tiptopgp;
grant index on lpj_file to public;
grant select on lpj_file to ods;
