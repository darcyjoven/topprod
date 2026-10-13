/*
================================================================================
檔案代號:npt_file
檔案名稱:支付指令对私明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table npt_file
(
npt01       varchar2(30) NOT NULL,   /*业务参考号                             */
npt03       varchar2(26) NOT NULL,   /*帐号                                   */
npt04       varchar2(40),            /*户名                                   */
npt05       number(20,6),            /*金额                                   */
npt06       varchar2(80)             /*注释                                   */
);

alter table npt_file add  constraint npt_pk primary key  (npt01,npt03) enable validate;
grant select on npt_file to tiptopgp;
grant update on npt_file to tiptopgp;
grant delete on npt_file to tiptopgp;
grant insert on npt_file to tiptopgp;
grant index on npt_file to public;
grant select on npt_file to ods;
