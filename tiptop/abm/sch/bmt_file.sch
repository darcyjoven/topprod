/*
================================================================================
檔案代號:bmt_file
檔案名稱:产品结构插件位置
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bmt_file
(
bmt01       varchar2(40) NOT NULL,   /*主件料件编号                           */
                                     /*主件料件編號                           */
bmt02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
bmt03       varchar2(40) NOT NULL,   /*元件料件编号                           */
                                     /*元件料件編號                           */
bmt04       date NOT NULL,           /*生效日期                               */
bmt05       number(5) NOT NULL,      /*行序                                   */
bmt06       varchar2(10),            /*插件位置                               */
bmt07       number(16,8),            /*组成用量                               */
                                     /*組成用量     #NO:6542                  */
bmt08       varchar2(20) NOT NULL    /*特性代码                               */
);

alter table bmt_file add  constraint bmt_pk primary key  (bmt01,bmt02,bmt03,bmt04,bmt05,bmt08) enable validate;
grant select on bmt_file to tiptopgp;
grant update on bmt_file to tiptopgp;
grant delete on bmt_file to tiptopgp;
grant insert on bmt_file to tiptopgp;
grant index on bmt_file to public;
grant select on bmt_file to ods;
