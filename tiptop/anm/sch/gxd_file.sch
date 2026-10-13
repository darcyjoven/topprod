/*
================================================================================
檔案代號:gxd_file
檔案名稱:外汇科目设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gxd_file
(
gxd00       varchar2(1) NOT NULL,    /*KEY, VALUE(0), 隐藏字段                */
                                     /*KEY, VALUE(0), 隱藏欄位                */
gxd01       varchar2(24),            /*应收远汇款外币 会计科目                */
                                     /*應收遠匯款外幣 會計科目                */
gxd02       varchar2(24),            /*应付购入远汇   会计科目                */
                                     /*應付購入遠匯   會計科目                */
gxd03       varchar2(24),            /*购入远汇溢价                           */
                                     /*購入遠匯溢價   會計科目                */
gxd04       varchar2(24),            /*购入远汇折价                           */
                                     /*購入遠匯折價   會計科目                */
gxd05       varchar2(24),            /*应收出售远汇款                         */
                                     /*應收出售遠匯款 會計科目                */
gxd06       varchar2(24),            /*应付远汇款                             */
                                     /*應付遠匯款     會計科目                */
gxd07       varchar2(24),            /*出售远汇溢价                           */
                                     /*出售遠匯溢價   會計科目                */
gxd08       varchar2(24),            /*出售远汇折价                           */
                                     /*出售遠匯折價   會計科目                */
gxd09       varchar2(24),            /*外汇汇兑收益                           */
                                     /*外匯匯兌收益   會計科目                */
gxd10       varchar2(24),            /*外汇汇兑损失                           */
                                     /*外匯匯兌損失   會計科目                */
gxd11       varchar2(24),            /*其他流动资产                           */
                                     /*其他流動資產   會計科目                */
gxd12       varchar2(24),            /*定期存款                               */
                                     /*定期存款       會計科目                */
gxd011      varchar2(24),            /*应收远汇款外币 会计科目二              */
gxd021      varchar2(24),            /*应付购入远汇   会计科目二              */
gxd031      varchar2(24),            /*购入远汇溢价 会计科目二                */
gxd041      varchar2(24),            /*购入远汇折价 会计科目二                */
gxd051      varchar2(24),            /*应收出售远汇款二                       */
gxd061      varchar2(24),            /*应付远汇款二                           */
gxd071      varchar2(24),            /*出售远汇溢价二                         */
gxd081      varchar2(24),            /*出售远汇折价二                         */
gxd091      varchar2(24),            /*外汇汇兑收益二                         */
gxd101      varchar2(24),            /*外汇汇兑损失二                         */
gxd111      varchar2(24),            /*其他流动资产二                         */
gxd121      varchar2(24)             /*定期存款二                             */
);

alter table gxd_file add  constraint gxd_pk primary key  (gxd00) enable validate;
grant select on gxd_file to tiptopgp;
grant update on gxd_file to tiptopgp;
grant delete on gxd_file to tiptopgp;
grant insert on gxd_file to tiptopgp;
grant index on gxd_file to public;
grant select on gxd_file to ods;
