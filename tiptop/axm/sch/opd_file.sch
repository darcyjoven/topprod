/*
================================================================================
檔案代號:opd_file
檔案名稱:产品销售预测单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table opd_file
(
opd01       varchar2(40) NOT NULL,   /*预测料件                               */
                                     /*預測料件                               */
opd02       varchar2(10) NOT NULL,   /*客户编号                               */
                                     /*客戶編號                               */
opd03       date NOT NULL,           /*计划日期                               */
                                     /*計劃日期                               */
opd04       varchar2(10) NOT NULL,   /*业务员                                 */
                                     /*業務員                                 */
opd05       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
opd06       date,                    /*起始日期                               */
opd07       date,                    /*截止日期                               */
opd08       number(15,3),            /*计划数量                               */
                                     /*計劃數量                               */
opd09       number(15,3),            /*审核数量                               */
                                     /*確認數量                               */
opd10       number(20,6),            /*单价                                   */
                                     /*單價                                   */
opd11       number(20,6),            /*金额                                   */
                                     /*金額                                   */
opd12       varchar2(1),             /*No Use                                 */
opd13       varchar2(1),             /*No Use                                 */
opdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
opdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table opd_file add  constraint opd_pk primary key  (opd01,opd02,opd03,opd04,opd05) enable validate;
grant select on opd_file to tiptopgp;
grant update on opd_file to tiptopgp;
grant delete on opd_file to tiptopgp;
grant insert on opd_file to tiptopgp;
grant index on opd_file to public;
grant select on opd_file to ods;
