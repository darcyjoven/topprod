/*
================================================================================
檔案代號:pmz_file
檔案名稱:采购单交期审核明细资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmz_file
(
pmz01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號                               */
pmz02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*採購單所確認的項目編號                 */
pmz03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
                                     /*採購單所確認的次數                     */
pmz05       date,                    /*最近答应日期                           */
                                     /*最近答應日期                           */
pmz06       date,                    /*最近交期审核日期                       */
                                     /*最近交期確認日期                       */
pmz07       date,                    /*预计到厂日期                           */
                                     /*預計到廠日期                           */
pmz08       date,                    /*预计到库日期                           */
                                     /*預計到庫日期                           */
pmz09       number(15,3),            /*审核交货数量                           */
                                     /*確認交貨數量                           */
pmz10       varchar2(10),            /*审核人                                 */
                                     /*確認人                                 */
pmz11       varchar2(255),           /*备注一                                 */
                                     /*備註一                                 */
pmz12       varchar2(255),           /*备注二                                 */
                                     /*備註二                                 */
pmz13       varchar2(255),           /*备注三                                 */
                                     /*備註三                                 */
pmzplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmzlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pmz14       number(5)                /*更动序号                               */
);

alter table pmz_file add  constraint pmz_pk primary key  (pmz01,pmz02,pmz03) enable validate;
grant select on pmz_file to tiptopgp;
grant update on pmz_file to tiptopgp;
grant delete on pmz_file to tiptopgp;
grant insert on pmz_file to tiptopgp;
grant index on pmz_file to public;
grant select on pmz_file to ods;
