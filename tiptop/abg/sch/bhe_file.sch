/*
================================================================================
檔案代號:bhe_file
檔案名稱:会计科目维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bhe_file
(
bhe00       varchar2(1) NOT NULL,    /*性质                                   */
                                     /*性質 1產品別 2.客戶 3.廠商             */
bhe01       varchar2(40) NOT NULL,   /*产品别/客户/厂商                       */
                                     /*產品別/客戶/廠商                       */
bhe02       varchar2(24),            /*销货收入科目                           */
                                     /*銷貨收入科目                           */
bhe03       varchar2(24),            /*销货成本科目                           */
                                     /*銷貨成本科目                           */
bhe04       varchar2(24),            /*存货科目科目                           */
                                     /*存貨科目科目                           */
bhe05       varchar2(24),            /*No Use                                 */
bhe06       varchar2(24)             /*应付/应收帐款科目                      */
                                     /*應付/應收帳款科目                      */
);

alter table bhe_file add  constraint bhe_pk primary key  (bhe00,bhe01) enable validate;
grant select on bhe_file to tiptopgp;
grant update on bhe_file to tiptopgp;
grant delete on bhe_file to tiptopgp;
grant insert on bhe_file to tiptopgp;
grant index on bhe_file to public;
grant select on bhe_file to ods;
