/*
================================================================================
檔案代號:ocn_file
檔案名稱:业务人员借出信用额度
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocn_file
(
ocn01       varchar2(10) NOT NULL,   /*业务人员编号                           */
ocn02       number(20,6),            /*借货额度金额                           */
ocn03       number(20,6),            /*已借贷金额                             */
ocn04       number(20,6),            /*剩余额度                               */
ocn05       date,                    /*生效日期                               */
ocn06       varchar2(1),             /*有效否                                 */
ocn07       varchar2(10)             /*最近资料                               */
);

alter table ocn_file add  constraint ocn_pk primary key  (ocn01) enable validate;
grant select on ocn_file to tiptopgp;
grant update on ocn_file to tiptopgp;
grant delete on ocn_file to tiptopgp;
grant insert on ocn_file to tiptopgp;
grant index on ocn_file to public;
grant select on ocn_file to ods;
