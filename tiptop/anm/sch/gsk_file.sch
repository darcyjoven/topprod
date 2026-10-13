/*
================================================================================
檔案代號:gsk_file
檔案名稱:投资资料统计档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table gsk_file
(
gsk01       varchar2(20) NOT NULL,   /*投资单号                               */
                                     /*投資單號                               */
gsk02       number(5) NOT NULL,      /*年度                                   */
gsk03       number(5) NOT NULL,      /*月份                                   */
gsk04       number(15,3) NOT NULL,   /*留仓数量                               */
                                     /*留倉數量                               */
gsk05       number(20,6) NOT NULL,   /*留仓金额                               */
                                     /*留倉金額                               */
gsklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table gsk_file add  constraint gsk_pk primary key  (gsk01,gsk02,gsk03) enable validate;
grant select on gsk_file to tiptopgp;
grant update on gsk_file to tiptopgp;
grant delete on gsk_file to tiptopgp;
grant insert on gsk_file to tiptopgp;
grant index on gsk_file to public;
grant select on gsk_file to ods;
