/*
================================================================================
檔案代號:nmt_file
檔案名稱:全国银行编号档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmt_file
(
nmt01       varchar2(20) DEFAULT ' ' NOT NULL, /*银行编号*/
                                     /*銀行編號 (金資中心標準編號)            */
nmt02       varchar2(200),           /*银行名称                               */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
                                     /*銀行名稱                               */
nmt03       number(5),               /*预估票据兑现入帐日数                   */
                                     /*預估票據兌現入帳日數                   */
nmtacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nmt04       varchar2(20),            /*所属银行代码                           */
nmt05       varchar2(80),            /*所属银行名称                           */
nmt06       varchar2(40),            /*开户行省份                             */
nmt07       varchar2(40),            /*开户行城市                             */
nmt08       varchar2(40),            /*开户行区县                             */
nmt09       varchar2(20),            /*系统内分行编码                         */
nmt10       varchar2(10),            /*接口系统编号                           */
nmt11       varchar2(10),            /*网络银行接口版本                       */
nmt12       varchar2(20),            /*网络银行接口来源银行编号               */
nmt13       varchar2(10),            /*国家/地区代码                          */
nmt14       varchar2(255)            /*银行地址                               */
);

alter table nmt_file add  constraint nmt_pk primary key  (nmt01) enable validate;
grant select on nmt_file to tiptopgp;
grant update on nmt_file to tiptopgp;
grant delete on nmt_file to tiptopgp;
grant insert on nmt_file to tiptopgp;
grant index on nmt_file to public;
grant select on nmt_file to ods;
