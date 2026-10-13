/*
================================================================================
檔案代號:npc_file
檔案名稱:银行实际对账记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table npc_file
(
npc01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號                               */
npc02       date,                    /*异动日期                               */
                                     /*異動日期                               */
npc021      varchar2(5),             /*异动时间                               */
                                     /*異動時間                               */
npc03       varchar2(80) DEFAULT ' ' NOT NULL, /*交易摘要*/
npc04       varchar2(1) DEFAULT ' ' NOT NULL, /*收支别*/
                                     /*收支別 1:收 2:支                       */
npc05       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
                                     /*金額                 02/11/26 alter    */
npc06       varchar2(20) DEFAULT ' ' NOT NULL, /*票据号码*/
                                     /*票據號碼                               */
npc07       varchar2(1),             /*对帐码                                 */
                                     /*對帳碼1:已入帳2:公司未入帳D:刪除       */
npc08       number(10),              /*更新来源                               */
                                     /*更新來源  nme00                        */
npclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index npc_01 on npc_file (npc01,npc02,npc06);
alter table npc_file add  constraint npc_pk primary key  (npc01,npc03,npc04,npc05,npc06) enable validate;
grant select on npc_file to tiptopgp;
grant update on npc_file to tiptopgp;
grant delete on npc_file to tiptopgp;
grant insert on npc_file to tiptopgp;
grant index on npc_file to public;
grant select on npc_file to ods;
