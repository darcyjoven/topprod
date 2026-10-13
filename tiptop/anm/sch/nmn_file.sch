/*
================================================================================
檔案代號:nmn_file
檔案名稱:借款状况资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nmn_file
(
nmn01       number(5) NOT NULL,      /*资料年度                               */
                                     /*資料年度                               */
nmn02       number(5) NOT NULL,      /*资料月份                               */
                                     /*資料月份                               */
nmn03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
nmn04       number(5),               /*日期                                   */
nmn05       number(20,6),            /*融资金额                               */
                                     /*融資金額                               */
nmn06       number(20,6),            /*还款金额                               */
                                     /*還款金額                               */
nmn07       number(20,6),            /*融资余额                               */
                                     /*融資餘額                               */
nmn08       number(5),               /*天数                                   */
                                     /*天數                                   */
nmnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nmn_file add  constraint nmn_pk primary key  (nmn01,nmn02,nmn03) enable validate;
grant select on nmn_file to tiptopgp;
grant update on nmn_file to tiptopgp;
grant delete on nmn_file to tiptopgp;
grant insert on nmn_file to tiptopgp;
grant index on nmn_file to public;
grant select on nmn_file to ods;
