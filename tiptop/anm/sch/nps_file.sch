/*
================================================================================
檔案代號:nps_file
檔案名稱:银行支付指令档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nps_file
(
nps01       varchar2(30) NOT NULL,   /*业务参考号                             */
nps03       varchar2(10),            /*业务类型                               */
nps05       varchar2(26),            /*付方银行帐号                           */
nps06       varchar2(40),            /*付方开户地区                           */
nps07       varchar2(35),            /*收方银行帐号                           */
nps08       varchar2(80),            /*收方帐号名称                           */
nps09       varchar2(80),            /*收方开户行                             */
nps10       varchar2(40),            /*收方省份                               */
nps11       varchar2(40),            /*收方城市                               */
nps12       number(20,6),            /*交易金额                               */
nps13       varchar2(10),            /*币种                                   */
nps14       varchar2(12),            /*结算方式                               */
                                     /*結算方式：                             */
                                     /*00 快速                                */
                                     /*01 普通                                */
nps15       varchar2(80),            /*用途                                   */
nps16       varchar2(255),           /*业务摘要                               */
nps17       varchar2(1),             /*支付状态                               */
                                     /*支付狀態：                             */
                                     /*0 落地支付成                           */
                                     /*1 網銀支付失敗                                                                                       2 網銀支付未明*/
                                     /*3 網銀提交成                           */
                                     /*4 網銀轉帳成功                         */
nps18       varchar2(20),            /*付方分行代码                           */
nps19       varchar2(20),            /*接口银行编号                           */
nps20       number(5),               /*总笔数                                 */
nps21       number(20,6),            /*成功金额                               */
nps22       number(5),               /*成功笔数                               */
nps23       date,                    /*支付提交日期                           */
nps24       date,                    /*实际经办日期                           */
nps25       varchar2(40),            /*落地文件编号                           */
nps26       varchar2(10),            /*收方国别代码                           */
nps27       varchar2(3),             /*费用承担方式                           */
nps28       date,                    /*支付日期                               */
nps29       varchar2(5)              /*部门编号                               */
);

alter table nps_file add  constraint nps_pk primary key  (nps01) enable validate;
grant select on nps_file to tiptopgp;
grant update on nps_file to tiptopgp;
grant delete on nps_file to tiptopgp;
grant insert on nps_file to tiptopgp;
grant index on nps_file to public;
grant select on nps_file to ods;
