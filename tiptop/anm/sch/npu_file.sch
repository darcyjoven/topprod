/*
================================================================================
檔案代號:npu_file
檔案名稱:银行对账单资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table npu_file
(
npu01       varchar2(10) DEFAULT ' ' NOT NULL, /*落地文件类型*/
                                     /*落地文件類型：                         */
                                     /*1 支付                                 */
                                     /*2 代發(工資)                           */
                                     /*3 代扣                                 */
npu02       date NOT NULL,           /*导出日期                               */
npu03       number(5) NOT NULL       /*文件序号                               */
);

alter table npu_file add  constraint npu_pk primary key  (npu01,npu02,npu03) enable validate;
grant select on npu_file to tiptopgp;
grant update on npu_file to tiptopgp;
grant delete on npu_file to tiptopgp;
grant insert on npu_file to tiptopgp;
grant index on npu_file to public;
grant select on npu_file to ods;
